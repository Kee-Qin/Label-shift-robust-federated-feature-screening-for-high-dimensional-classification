function  w = CRU_divide(X,Y,divide)
    %% CRU utility
    % Xingxiang Li and Chen Xu.
    % Feature Screening with Conditional Rank Utility for Big-Data Classification. Journal of the American Statistical Association, pages 1–11, April 2023.


    % input:
    % X: vector, feature
    % Y: vector, response
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % output:
    % utility

    myestimate = @myestimate;
    dict = unique(Y);
    R = length(dict);
    w = 0;
    N = length(Y);
    m = length(divide);
    divide = [0 divide];
    
    for i = 1 : R
        r = dict(i);
        theta_hat = 0;
        pi_hat = 0;
        denominator = 0;

        for partition = 1:m
            m1 = 1 + divide(partition);
            m2 = divide(partition+1);
            X1 = X(m1:m2,:);
            Y1 = Y(m1:m2,:);

            [theta_hat_temp,pi_hat_temp] = myestimate(X1, Y1, r);
            theta_hat = theta_hat + theta_hat_temp * floor(length(X1)/2);
            denominator = denominator + floor(length(X1)/2);
            pi_hat = pi_hat + pi_hat_temp* length(X1);

        end
        theta_hat = theta_hat/denominator;
        pi_hat = pi_hat/N;

        w = w + power((theta_hat -pi_hat/2),2);
    end
end

function [theta_hat,pi_hat] = myestimate(X, Y, r)
    % this function is used to estimate theta_hat and pi_hat
    nl = length(Y);    
    pi_hat = sum(Y==r)/nl;
    b1 = X(Y==r);
    count = sum(sum(X<b1'));
    theta_hat = count /((nl-1)*nl);
end
