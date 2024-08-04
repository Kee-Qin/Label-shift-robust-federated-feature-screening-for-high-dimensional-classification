%% Example2 setting(c)
% the presence of missing class labels and varying sample sizes across clients.

%% Basic parameters
p = 10000;   q = 1000;
iter = 200;  % iteration number, default is 200
noise_num = 50;

% add_noise = false;
add_noise = true;
hide = true;    % Whether to use MV and FKF methods (default is true)

prob =  [0,1,2,3,4];
M = 1:10;
Class = 8;   miu = 0.32;


Final = [];
for i = 1:length(prob)
    probability = prob(i);    % i=1 means IID distribution
    fprintf('the value of alpha is %d\n',probability)
    final_CRU = 0;
    final_MAX = 0;
    final_MAX_pair = 0;
    final_MV = 0;
    final_FKF = 0;
    final_PSIS = 0;
    final_CAVS = 0;


    parfor T = 1:iter
        Generate = generation;
        divide = [100 200 300 400 600 800 1000 1200 1500 1800 2100 2400 2800 3200 3600 4000];
        m = length(divide);
        N = divide(end);

        Y = Generate.getY_none_divide(Class,probability,divide);
        divide = [0 divide];

        X = exp(randn(N,p));

        X((Y==1),M) = X((Y==1),M)+miu;
        X((Y==2),M) = X((Y==2),M)+miu/4;
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

    Final = [Final result];
end

if add_noise
    name = "example2(c)_class"+num2str(Class)+"_"+num2str(100*miu)+"_noise.mat"; 
else
    name = "example2(c)_class"+num2str(Class)+"_"+num2str(100*miu)+".mat"; 
end
save(name,"Final")