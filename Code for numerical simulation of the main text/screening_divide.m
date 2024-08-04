function output  = screening_divide(X,Y,Z,divide,M, method)
    %%  screening function
    
    % Input: 
    % X,Y :covariate and predictor
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % Z: permulated X
    % M: active set
    % method: screening method, CRU,LRFFS,PSIS,FKF,MV
    % Output:
    % six evaluation index [SSR;PSR;FDR;SIZE;wRank;time]

    SSR = 0;
    PSR = 0;
    FDR = 0;
    SIZE = 0;
    wRank = 0;
    m = length(divide);

    [~,p] = size(X);

    if method =="CRU"
        columns_fun = @(x)CRU_divide(x,Y,divide);
    end

    if method =="LRFFS"
        columns_fun = @(x)LRFFS_divide(x,Y,divide);
    end

    if method =="LRFFS_CRU"
        columns_fun = @(x)LRFFS_divide_weightCRU(x,Y,divide);
    end

    if method =="LRFFS_MV"
        columns_fun = @(x)LRFFS_divide_weightMV(x,Y,divide);
    end

    if method =="LRFFS_CAVS"
        columns_fun = @(x)LRFFS_divide_weightCAVS(x,Y,divide);
    end

    if method =="LRFFS_EQ"
        columns_fun = @(x)LRFFS_divide_weightEQ(x,Y,divide);
    end

    if method =="LRFFS_pair"
        columns_fun = @(x)LRFFS_pair_divide(x,Y,divide);
    end

    if method =="MV"
        columns_fun = @(x)MV_divide(x,Y,divide);
    end

    if method =="FKF"
        columns_fun = @(x)FKF_divide(x,Y,divide);
    end

    if method =="PSIS"
        columns_fun = @(x)PSIS_divide(x,Y,divide);
    end

    if method =="CAVS"
        columns_fun = @(x)CAVS_divide(x,Y,divide);
    end

    tic;
    columns = num2cell(Z, 1);
    Q = cellfun(columns_fun,columns);
    threshold = max(Q);
    columns = num2cell(X,1);
    w_list = cellfun(columns_fun,columns);

    M_predict = find(w_list>threshold);
    SSR = SSR + all(ismember(M ,M_predict));
    PSR = PSR + length(intersect(M ,M_predict))/length(M);
    FDR = FDR + length(setdiff(M_predict,M))/(length(M_predict)+1e-9);
    SIZE = SIZE + length(M_predict);
    b = sort(w_list);
    [~, I] = ismember(w_list,b);
    I = p + 1 - I;
    wRank = wRank + max(I(M));
    t2 = toc;

    output = [SSR;PSR;FDR;SIZE;wRank;t2/m];
end