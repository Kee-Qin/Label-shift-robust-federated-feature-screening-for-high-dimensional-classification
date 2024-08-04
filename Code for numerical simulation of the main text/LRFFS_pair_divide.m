function  w = LRFFS_pair_divide(X,Y,divide)
    %% LR-FFS-PAIR utility

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

    for i = 1 : R-1
        for j = i+1:R
            r1 = dict(i);
            r2 = dict(j);
            theta_hat = 0;
            denominator = 0;
    
            for partition = 1:m
                m1 = 1 + divide(partition);
                m2 = divide(partition+1);
                X1 = X(m1:m2,:);
                Y1 = Y(m1:m2,:);
                block = sum(Y1==r1)+sum(Y1==r2);
                [count,total] = myestimate_count(X1, Y1, r1,r2);
                theta_hat = theta_hat+floor(block/2)*count/(block-1)/block;
                denominator = denominator+floor(block/2)*total/(block-1)/block;
            end
    
            theta_hat = abs(theta_hat/denominator-0.5);
            w = max(w, theta_hat);
        end
    end
end

function [count,total] = myestimate_count(X, Y, r, k)
    b1 = X(Y==r);
    b2 = X(Y==k);
    count = sum(sum(b2<b1'));
    total = length(b1) * length(b2);
end