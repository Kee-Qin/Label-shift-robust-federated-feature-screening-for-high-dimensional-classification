%% Example3 (d)
% multinomial logistic model

%% Basic parameters
m = 30;      N = 3000;
p = 8000;
iter = 200;  % iteration number, default is 200
noise_num = 30;

add_noise = false;
% add_noise = true;
hide = true; % Whether to use MV and FKF methods (default is true)


Sigma = diag(ones(p,1));
mu = zeros(p,1);
M =  1:8;
K = 50;

alpha_list =  [0.06,0.08,0.1,0.2,1,5];
for Class = 6:7
    Final = [];
    for qq = 1:length(alpha_list)
        probability_all = alpha_list(qq);    % i=1 means IID distribution
        fprintf('the value of alpha is %d\n',probability_all)
    
    
        final_CRU = 0;
        final_MAX = 0;
        final_MV = 0;
        final_FKF = 0;
        final_PSIS = 0;
        final_MAX_pair = 0;
        final_CAVS = 0;
        
        parfor T = 1:iter
            %% generation of X and Y
            X = mvnrnd(mu, Sigma, N);
            beta1 = zeros(p,1);
            W = binornd(1,0.5,8,1);
            beta_M = power(-1,W)*1;
            beta1(M) = beta_M;
              
            probability1 = exp(X*beta1-2.5);
            probability2 = ones(N,1)*1.2;
            probability_other = ones(N,1);
            
            Class1 = probability1./(probability1+probability2+(Class-2));
            Class2 = probability2./(probability1+probability2+(Class-2));
            Class_other = 1./(probability1+probability2+(Class-2));
            probability = [Class1 Class2 repmat(Class_other,1,Class-2)];
            probability = cumsum(probability,2);
            
            Y1 = rand(N,1);
            Y1 = repmat(Y1,1,Class);
            
            Y = sum(probability<Y1,2)+1;
            
            %  shuffle
            Q = [Y X];
            Q = sortrows(Q,1);
            
            Generate = generation;
            Y1 = Generate.getY_dir(N,m,probability_all,Class);
            shift = randi([1 Class],1);
            Y1 = mod(Y1+shift,Class)+1;
            
            Y2 = 1:N;
            Y1 = [Y1 Y2'];         Y1 = sortrows(Y1,1);
            Y1 = [Y1 Q];           Y1 = sortrows(Y1,2);
            Y = Y1(:,3);
            X = Y1(:,4:end);
    
    
            if add_noise
                X(randsample(N,noise_num),1:p) = unifrnd(0,100,noise_num,p);
            end
    
            divide = N/m:N/m:N;
    
            final_CRU = final_CRU + screening_topK(X,Y,divide,M,K, 'CRU');
            final_MAX = final_MAX + screening_topK(X,Y,divide,M,K, 'LRFFS');
            final_MAX_pair = final_MAX_pair + screening_topK(X,Y,divide,M,K, 'LRFFS_pair');
            final_PSIS = final_PSIS + screening_topK(X,Y,divide,M,K, 'PSIS');
            final_CAVS = final_CAVS + screening_topK(X,Y,divide,M,K, 'CAVS');
            if ~ hide
                final_MV = final_MV + screening_topK(X,Y,divide,M,K, 'MV');
                final_FKF = final_FKF + screening_topK(X,Y,divide,M,K,'FKF');
            end
        end
    
        if hide
            result = [final_CRU;final_MAX;final_MAX_pair;final_PSIS;final_CAVS]/iter;
        else
            result = [final_CRU;final_MAX;final_MAX_pair;final_MV;final_FKF;final_PSIS;final_CAVS]/iter;
        end
    
        result = [probability_all;result];
        Final = [Final result];
    end
    
    if add_noise
        name = "example3(d)_class"+num2str(Class)+"_reg_noise.mat"; 
    else
        name = "example3(d)_class"+num2str(Class)+"_reg.mat"; 
    end
    save(name,"Final")
end