%% toy example for Figure 7 to demonstrate that under the general framework, 
% methods like CRU,MV,CAVS can also achieve "unbias" estimators under label
% shifting setting.


m = 2;
N = 1000;
p = 10000;
miu = 0.35;
Final = [];
parfor probability1 = 50:95
    probability = probability1/100;
    Y1 = [ones(500*probability,1);ones(500-500*probability,1)*2]; 
    Y2 = [ones(500*probability,1)*2;ones(500-500*probability,1)]; 
    Y = [Y1; Y2];
    X = randn(N,p);
    X((Y==1),1:p) = X((Y==1),1:p)+miu;
    divide = [500 1000];

    columns = num2cell(X,1);
    columns_fun = @(x)CRU_divide(x,Y,divide); 
    w_list1 = cellfun(columns_fun,columns);

    columns_fun = @(x)CRU_new_divide(x,Y,divide);
    w_list1_1 = cellfun(columns_fun,columns);

    columns_fun = @(x)CAVS_divide(x,Y,divide);
    w_list2 = cellfun(columns_fun,columns);

    columns_fun = @(x)CAVS_new_divide(x,Y,divide);
    w_list2_1 = cellfun(columns_fun,columns);

    columns_fun = @(x)MV_divide(x,Y,divide);
    w_list3 = cellfun(columns_fun,columns);

    columns_fun = @(x)MV_new_divide(x,Y,divide);
    w_list3_1 = cellfun(columns_fun,columns);

    output = [probability;mean(w_list1);mean(w_list2);mean(w_list3);mean(w_list1_1);mean(w_list2_1);mean(w_list3_1)];
    Final = [Final output];
end