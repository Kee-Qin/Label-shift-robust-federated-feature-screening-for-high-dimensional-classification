function  w = MV_divide(X,Y,divide)
    %% MV-SIS utility
    % Hengjian Cui, Runze Li, and Wei Zhong. 
    % Model-Free Feature Screening for Ultrahigh Dimensional Discriminant Analysis. Journal of the American Statistical Association, 110(510):630–641, April 2015.

    % input:
    % X: vector, feature
    % Y: vector, response
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % output:
    % utility
    MV_theta  = @MV_theta;
    dict = unique(Y);
    R = length(dict);
    w = 0;
    N = length(Y);
    m = length(divide);
    divide = [0 divide];

    for i = 1 : R
        r = dict(i);
        theta1_all = 0;
        theta2_all = 0;
        percent = 0;
        for partition = 1:m
            m1 = 1 + divide(partition);
            m2 = divide(partition+1);
            X1 = X(m1:m2,:);
            Y1 = Y(m1:m2,:);

            [theta1,theta2] = MV_theta(X1,Y1,r);
            theta1_all = theta1_all + theta1 * length(X1)/N;
            theta2_all = theta2_all + theta2 * length(X1)/N;
            percent = percent + sum(Y1==r)/N;
        end

        w = w + theta1_all/percent-2*theta2_all+percent/3;
    end
end

function [theta1,theta2] = MV_theta(X,Y,r)
    N = length(X);

    X_map = (X<=X')*1;
    X_map(Y~=r,:)=0;
    X_map = X_map - diag(diag(X_map));
    X_map1 = X_map * X_map';
    X_map1 = X_map1 - diag(diag(X_map1));
    count = sum(sum(X_map1));
    number = N * (N-1) * (N-2);
    theta1 = count/number;

    X_map2 = (X<=X')*1;
    X_map2 = X_map2 - diag(diag(X_map2));
    X_map1 = X_map * X_map2';
    X_map1 = X_map1 - diag(diag(X_map1));
    count = sum(sum(X_map1));
    theta2 = count/number;
end