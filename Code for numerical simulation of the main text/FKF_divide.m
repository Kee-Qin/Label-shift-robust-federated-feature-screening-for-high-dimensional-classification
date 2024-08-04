function  w = FKF_divide(X,Y,divide)
    %% FKF utility
    % Qing Mai and Hui Zou. 
    % The fused Kolmogorov filter: A nonparametric model-free screening method. The Annals of Statistics, 43(4), August 2015.

    % input:
    % X: vector, feature
    % Y: vector, response
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % output:
    % utility
    FKF_theta = @FKF_theta;
    w = 0;
    m = length(divide);
    divide = [0 divide];

    for partition = 1:m
        m1 = 1 + divide(partition);
        m2 = divide(partition+1);
        X1 = X(m1:m2,:);
        Y1 = Y(m1:m2,:);
        w = w + FKF_theta(X1,Y1)/m;
    end
end

function w = FKF_theta(X,Y)
    N = length(X);
    dict = unique(Y);
    R = length(dict);
    w = 0;
    for i = 1 : R
        r = dict(i);

        Xnone_r = X(Y~=r);
        Xr = X(Y==r);

        Xnone_r = (Xnone_r<X')*1;
        Xr = (Xr<X')*1;

        Xnone_r = mean(Xnone_r);
        Xr = mean(Xr);

        w1 = max(abs(Xnone_r - Xr));
        w = max(w,w1);
    end
end