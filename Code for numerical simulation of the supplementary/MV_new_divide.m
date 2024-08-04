function  w = MV_new_divide(X,Y,divide)

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
        theta3_all = 0;
        theta4_all = 0;
        percent = 0;
        for partition = 1:m
            m1 = 1 + divide(partition);
            m2 = divide(partition+1);
            X1 = X(m1:m2,:);
            Y1 = Y(m1:m2,:);

            [theta1,theta2,theta3,theta4] = MV_theta(X1,Y1,r);
            theta1_all = theta1_all + theta1 * length(X1)/N;
            theta2_all = theta2_all + theta2 * length(X1)/N;
            theta3_all = theta3_all + theta3 * length(X1)/N;
            theta4_all = theta4_all + theta4 * length(X1)/N;
        end
        percent = sum(Y==r)/N;

        w = w + percent*(1-percent)^2 * (-2/3+theta1_all /theta3_all + theta2_all/theta4_all);
    end
end

function [theta1,theta2,theta3,theta4] = MV_theta(X,Y,r)
    N = length(X);

    X_map = (X<=X')*1;
    X_map(Y~=r,:)=0;
    X_map(:,Y==r)=0;
    X_map = X_map - diag(diag(X_map));
    X_map1 = X_map * X_map';
    X_map1 = X_map1 - diag(diag(X_map1));
    count = sum(sum(X_map1));
    number = N * (N-1) * (N-2);
    theta1 = count/number;

    X_map2 = (X<=X')*1;
    X_map2(Y==r,:)=0;
    X_map2(:,Y~=r)=0;
    X_map2 = X_map2 - diag(diag(X_map2));
    X_map1 = X_map2 * X_map2';
    X_map1 = X_map1 - diag(diag(X_map1));
    count = sum(sum(X_map1));
    theta2 = count/number;

    theta3 = (sum(Y==r)-1)*sum(Y==r)*(N-sum(Y==r))/number;
    theta4 = (sum(Y~=r)-1)*sum(Y~=r)*(N-sum(Y~=r))/number;

end