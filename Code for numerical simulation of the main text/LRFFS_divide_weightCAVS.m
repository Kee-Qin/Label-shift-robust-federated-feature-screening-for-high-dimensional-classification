function  w = LRFFS_divide_weightCAVS(X,Y,divide)
    %% proposed utility
    % The function is designed to analyze the impact of different weights eta on the utility estimates. 
    % The eta here is the same as the eta of CAVS

    % input:
    % X: vector, feature
    % Y: vector, response
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % output:
    % utility

    myestimate_count = @myestimate_count;
    dict = unique(Y);
    R = length(dict);
    w = 0;
    N = length(Y);
    m = length(divide);
    divide = [0 divide];

    for i = 1 : R
        r = dict(i);
        theta_hat = 0;
        denominator = 0;
        percent = 0;
        for partition = 1:m
            m1 = 1 + divide(partition);
            m2 = divide(partition+1);
            X1 = X(m1:m2,:);
            Y1 = Y(m1:m2,:);
            block = divide(partition+1) - divide(partition);
            [count,total] = myestimate_count(X1, Y1, r);
            theta_hat = theta_hat+floor(block/2)*count/(block-1)/block;
            denominator = denominator+floor(block/2)*total/(block-1)/block;
            percent = percent + sum(Y1==r)/N;
        end
        w = w + (1-percent)*abs(theta_hat/denominator-0.5);
    end
end

function [count,total] = myestimate_count(X, Y, r)
    b1 = X(Y==r);
    b2 = X(Y~=r);
    count = sum(sum(b2<b1'));
    total = length(b1) * length(b2);
end