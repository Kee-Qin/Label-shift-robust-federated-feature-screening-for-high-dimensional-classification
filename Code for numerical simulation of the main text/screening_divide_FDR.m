function output  = screening_divide_FDR(X,Y,Z,divide,FDR_control,M, method)
    %%  screening function with FDR control
    
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
    FDR = 0;
    SIZE = 0;

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

    columns = num2cell(X, 1);
    QX = cellfun(columns_fun,columns);

    columns = num2cell(Z, 1);
    QZ = cellfun(columns_fun,columns);
    Q = QX-QZ;
    Q1 = sort(abs(Q),'descend');
    QQ_positive  =sum(Q'>=Q1);
    QQ_negative  =sum(Q'<=-Q1);
    L = (QQ_negative+1)./(max(QQ_positive,1));
    threshold = min(Q1(L<=FDR_control));
    if isempty(threshold)
        threshold = min(Q1(L==min(L)));
    end
    M_predict = find(Q>=threshold);

    SSR = SSR + all(ismember(M ,M_predict));
    FDR = FDR + length(setdiff(M_predict,M))/(length(M_predict)+1e-9);
    SIZE = SIZE + length(M_predict);
    target = M_predict(M_predict<=max(M));
    target_1 = M*0;
    target_1(target) = 1;

    output = [target_1';SSR;FDR;SIZE];
end