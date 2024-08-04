%% Example2 setting(b)
% class distributions among different clients follow Dirichlet distributions.

%% Basic parameters
m = 30;      N = 3000;
p = 10000;   q = 1000;
iter = 200;  % iteration number, default is 200
noise_num = 50;


add_noise = false;
% add_noise = true;
hide = true; % Whether to use MV and FKF methods (default is true)

M = 1:8;     % active set
alpha_list =  [0.01,0.1,0.25,0.5,1,2,5,10];

Class_miu = [7 6 5; 0.5 0.47 0.45];
for ttt = 2:3
    Class = Class_miu(1,ttt);
    miu = Class_miu(2,ttt);
    Final = [];
    for qq = 1:length(alpha_list)
        alpha = alpha_list(qq);
        fprintf('the value of alpha is %.2f\n',alpha)
    
        final_CRU = 0;
        final_MAX = 0;
        final_MAX_pair = 0;
        final_MV = 0;
        final_FKF = 0;
        final_PSIS = 0;
        final_CAVS = 0;
    
        parfor T = 1:iter
            Generate = generation;
            Y = Generate.getY_dir(N,m,alpha,Class);
    
            divide = N/m:N/m:N;  % segmentation used to distinguish different clients
            divide = [0 divide];
    
            X = trnd(2,N,p);
    
            X((Y==1),1:4) = X((Y==1),1:4)+miu;
            X((Y==2),5:8) = X((Y==2),5:8)+miu;
    
            if add_noise
                X(randsample(N,noise_num),1:p) = unifrnd(0,100,noise_num,p);
            end
    
            Z = [];     % make sure all the mathod use the same data, including uxiliary features
            select_feature = randsample(p,q);
            for partition = 1:m
                m1 = 1 + divide(partition);
                m2 = divide(partition+1);
                X1 = X(m1:m2,:);
                block = m2-m1+1;
                Z = [Z;X1(randsample(block,block),select_feature)];
            end
    
            divide = N/m:N/m:N;
    
            final_CRU = final_CRU + screening_divide(X,Y,Z,divide,M, 'CRU');
            final_MAX = final_MAX + screening_divide(X,Y,Z,divide,M, 'LRFFS');
            final_MAX_pair = final_MAX_pair + screening_divide(X,Y,Z,divide,M, 'LRFFS_pair');
            final_PSIS = final_PSIS + screening_divide(X,Y,Z,divide,M, 'PSIS');
            final_CAVS = final_CAVS + screening_divide(X,Y,Z,divide,M, 'CAVS');
    
            if ~ hide
                final_MV = final_MV + screening_divide(X,Y,Z,divide,M, 'MV');
                final_FKF = final_FKF + screening_divide(X,Y,Z,divide,M, 'FKF');
            end
        end
    
        if hide
            result = [final_CRU;final_MAX;final_MAX_pair;final_PSIS;final_CAVS]/iter;
        else
            result = [final_CRU;final_MAX;final_MAX_pair;final_MV;final_FKF;final_PSIS;final_CAVS]/iter;
        end
        
        result = [alpha;result];
        Final = [Final result];
    end
    
    if add_noise
        name = "example2(b)_class"+num2str(Class)+"_"+num2str(100*miu)+"_noise.mat"; 
    else
        name = "example2(b)_class"+num2str(Class)+"_"+num2str(100*miu)+".mat"; 
    end
    save(name,"Final")
end