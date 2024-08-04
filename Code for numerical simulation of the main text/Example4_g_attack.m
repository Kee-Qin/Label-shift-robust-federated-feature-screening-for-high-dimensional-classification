%% Example4 (g)
%  a proportion of clients' data is contaminated, where the labels $Y$ are randomly shuffled.

%% Basic parameters
m = 30;      N = 3000;
p = 10000;   q = 1000;
iter = 200;  % iteration number, default is 200
noise_num = 50;

add_noise = false;
hide = true; % Whether to use MV and FKF methods (default is true)

M = 1:10;     % active set
Class = 7;   miu = 0.5;

pro = [1 4];
for tt = 1:2
    probability = pro(tt);
    Final = [];
    for attack_rate = 0:0.05:0.3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            5
        fprintf('the value of alpha is %d\n',attack_rate)
        final_CRU = 0;
        final_MAX = 0;
        final_MAX_pair = 0;
        final_MV = 0;
        final_FKF = 0;
        final_PSIS = 0;
        final_CAVS = 0;
    
        parfor T = 1:iter
            Generate = generation;
            Y = Generate.getY(N,m,1,probability,Class);
            divide = N/m:N/m:N;  % segmentation used to distinguish different clients
            divide = [0 divide];
            X = exprnd(2,N,p);
            X((Y==1),M) = X((Y==1),M)+miu;
            if add_noise
                X(randsample(N,noise_num),1:p) = unifrnd(0,100,noise_num,p);
            end
    
            Y = Y_attack(Y,m,attack_rate);
    
            divide = N/m:N/m:N;
            
            final_CRU = final_CRU + screening_topK(X,Y,divide,M,K, 'CRU');
            final_MAX = final_MAX + screening_topK(X,Y,divide,M,K, 'LRFFS');
            final_MAX_pair = final_MAX_pair + screening_topK(X,Y,divide,M,K, 'LRFFS_pair');
            final_PSIS = final_PSIS + screening_topK(X,Y,divide,M,K, 'PSIS');
            final_CAVS = final_CAVS + screening_topK(X,Y,divide,M,K, 'CAVS');
            if ~ hide
                final_MV = final_MV + screening_topK(X,Y,divide,M,K, 'MV');
                final_FKF = final_FKF + screening_topK(X,Y,divide,M,K, 'FKF');
            end
        end
    
        if hide
            result = [final_CRU;final_MAX;final_MAX_pair;final_PSIS;final_CAVS]/iter;
        else
            result = [final_CRU;final_MAX;final_MAX_pair;final_MV;final_FKF;final_PSIS;final_CAVS]/iter;
        end
        
        result = [attack_rate;result];
        Final = [Final result];
    end
    
    if add_noise
        name = "example4(g)_class"+num2str(Class)+'_'+num2str(probability)+"_"+num2str(100*miu)+"_noise.mat"; 
    else
        name = "example4(g)_class"+num2str(Class)+'_'+num2str(probability)+"_"+num2str(100*miu)+".mat"; 
    end
    save(name,"Final")
end