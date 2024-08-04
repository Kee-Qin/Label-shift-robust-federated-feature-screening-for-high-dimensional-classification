function  w = PSIS_divide(X,Y,divide)
    %% PSIS utility
    % Rui Pan, Hansheng Wang, and Runze Li. 
    % Ultrahigh-Dimensional Multiclass Linear Discriminant Analysis by Pairwise Sure Independence Screening. Journal of the American Statistical Association, 111(513):169–179, January 2016.
    
    % input:
    % X: vector, feature
    % Y: vector, response
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % output:
    % utility

    dict = unique(Y);
    R = length(dict);
    N = length(Y);
    m = length(divide);
    divide = [0 divide];

    r_list = [];
    for i = 1 : R
        r = dict(i);
        Theta1 = 0;
        Theta2 = 0;
        for partition = 1:m
            m1 = 1 + divide(partition);
            m2 = divide(partition+1);
            X1 = X(m1:m2,:);
            Y1 = Y(m1:m2,:);
            theta1 = sum(X1(Y1==r));
            theta2 = sum(Y1==r);
            Theta1 = Theta1 + theta1;
            Theta2 = Theta2 + theta2;
        end
        theta = Theta1/Theta2;
        r_list = [r_list theta];
    end
    w = max(r_list)-min(r_list);
end