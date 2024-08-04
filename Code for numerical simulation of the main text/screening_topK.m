function output  = screening_topK(X,Y,divide,M,K, method)
    %% Different from @screening_divide, 
    %% K features with the largest utility values ​​are retained here.
    SSR = 0;
    PSR = 0;
    FDR = 0;
    SIZE = 0;
    wRank = 0;
    m = length(divide);

    [~ ,p] = size(X);
    
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

    columns = num2cell(X,1);
    w_list = cellfun(columns_fun,columns);
    threshold = maxk(w_list,K+1);
    threshold = threshold(end);

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