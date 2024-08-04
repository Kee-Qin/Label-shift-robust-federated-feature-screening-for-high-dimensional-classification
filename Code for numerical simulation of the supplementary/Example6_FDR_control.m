%% Example6 FDR control

%% Basic parameters
m = 30;      N = 3000;
p = 10000;   q = 1000;
iter = 200;  % iteration number, default is 200
noise_num = 50;

Class = 5;  miu = 0.4;

add_noise = false;

M = 1:8;     % active set
for prob = 1:4:5
    Final = [];

    for FDR_control = 0.1:0.05:0.4
        fprintf('the value of alpha is %d\n',FDR_control)
        final_CRU = 0;
        final_MAX = 0;
        final_MAX_pair = 0;
        final_MV = 0;
        final_FKF = 0;
        final_PSIS = 0;
        final_CAVS = 0;
    
        for T = 1:iter
            Generate = generation;
            Y = Generate.getY(N,m,1,prob,Class);
            divide = N/m : N/m : N;  % segmentation used to distinguish different clients
            divide = [0 divide];
            X = randn(N,p);
            X((Y==1),M) = X((Y==1),M)+miu;
            if add_noise
                X(randsample(N,noise_num),1:p) = unifrnd(0,100,noise_num,p);
            end

            Z = [];
            for partition = 1:m
                m1 = 1 + divide(partition);
                m2 = divide(partition+1);
                X1 = X(m1:m2,:);
                block = m2-m1+1;
                Z = [Z;X1(randsample(block,block),:)];
            end
    
            divide = N/m:N/m:N;
            final_CRU = final_CRU + screening_divide_FDR(X,Y,Z,divide,FDR_control,M, 'CRU');
            final_MAX = final_MAX + screening_divide_FDR(X,Y,Z,divide,FDR_control,M, 'LRFFS');
            final_PSIS = final_PSIS + screening_divide_FDR(X,Y,Z,divide,FDR_control,M, 'PSIS');
            final_CAVS = final_CAVS + screening_divide_FDR(X,Y,Z,divide,FDR_control,M, 'CAVS');
        end
        result = [final_CRU;final_MAX;final_MAX_pair;final_PSIS;final_CAVS]/iter;        
        result = [FDR_control;result];
        Final = [Final result];
    
    if add_noise
        name = "example6_FDR_"+num2str(100*prob)+"_noise.mat"; 
    else
        name = "example6_FDR_"+num2str(100*prob)+".mat"; 
    end
    save(name,"Final") 
    end
end