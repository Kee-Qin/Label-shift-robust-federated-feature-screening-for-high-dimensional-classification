%% Example5 class-specific screening result
% The experimental setup is identical to that of Example 2 in xie_category-adaptive_2020
% In xie_category-adaptive_2020, CAVS was compared with a modified version of MV-SIS, KF, and PSIS, 
% demonstrating its optimal performance among them.
% In this paper, we compare the proposed LR-FFS with a modified version of CRU and CAVS, 
% denoted by $CRU_r$ and $CAVS_r$, respectively. 


%% Basic parameters
N = 200; p =3000;

A1  = 1:2;
A2 = 8:10;
A3 = 4:6;
A4 = 16:20;
A5 = 31:35;


wRankCAVS = []; wRankFFS = []; wRankCRU = [];
RaCAVS = []; RaFFS = []; RaCRU = [];
SelectCAVS = []; SelectFFS = []; SelectCRU = [];

r = 1; A = A1;

parfor TT = 1:400
    %TT
    Y_rand = unifrnd(0,1,N,1);
    %%% case 1
    %Y1 = (Y_rand<=0.2);
    %Y2 = (Y_rand<=0.4);
    %Y3 = (Y_rand<=0.6);
    %Y4 = (Y_rand<=0.8);
    %Y = 5-Y1 -Y2 -Y3-Y4;
    
    %%% case 2
    Y1 = (Y_rand<=0.1);
    Y2 = (Y_rand<=0.2);
    Y3 = (Y_rand<=0.3);
    Y4 = (Y_rand<=0.65);
    Y = 5-Y1 -Y2 -Y3-Y4;

    X = randn(N,p);
    X(Y==1,A1) = X(Y==1,A1)+1.5;
    X(Y==2,A2) = X(Y==2,A2)+1.5;
    X(Y==3,A3) = X(Y==3,A3)+1.5;
    X(Y==4,A4) = X(Y==4,A4)+1.5;
    X(Y==5,A5) = X(Y==5,A5)+1.5;
    
    Z = trnd(1,N,p);
    X = 0.9*X+0.1*Z;

    columns_fun = @(x)CAVS_r(x,Y,r);
    columns = num2cell(X, 1);
    w_list = cellfun(columns_fun,columns);
    
    b = sort(w_list);
    [~, I] = ismember(w_list,b);
    I = p + 1 - I;
    wRankCAVS = [wRankCAVS,max(I(A))];
    RaCAVS = [RaCAVS, mean(I(A))];
    SelectCAVS = [SelectCAVS,sum(I(A)<N/log(N))];

    columns_fun = @(x)LRFFS_r(x,Y,r);
    columns = num2cell(X, 1);
    w_list = cellfun(columns_fun,columns);
    
    b = sort(w_list);
    [~, I] = ismember(w_list,b);
    I = p + 1 - I;
    wRankFFS = [wRankFFS,max(I(A))];
    RaFFS = [RaFFS, mean(I(A))];
    SelectFFS = [SelectFFS,sum(I(A)<N/log(N))];

    columns_fun = @(x)CRU_r(x,Y,r);
    columns = num2cell(X, 1);
    w_list = cellfun(columns_fun,columns);
    
    b = sort(w_list);
    [~, I] = ismember(w_list,b);
    I = p + 1 - I;
    wRankCRU = [wRankCRU,max(I(A))];
    RaCRU = [RaCRU, mean(I(A))];
    SelectCRU = [SelectCRU,sum(I(A)<N/log(N))];
end

CAVS = [median(wRankCAVS),iqr(wRankCAVS),mean(wRankCAVS),std(wRankCAVS),mean(RaCAVS),mean(SelectCAVS)/length(A)];
FFS = [median(wRankFFS),iqr(wRankFFS),mean(wRankFFS),std(wRankFFS),mean(RaFFS),mean(SelectFFS)/length(A)];
CRU = [median(wRankCRU),iqr(wRankCRU),mean(wRankCRU),std(wRankCRU),mean(RaCRU),mean(SelectCRU)/length(A)];

Output=[CAVS;FFS;CRU];

save("R"+num2str(r)+".mat","Output")