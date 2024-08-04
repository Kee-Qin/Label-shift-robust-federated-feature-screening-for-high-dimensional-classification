function W = FAIR_divide(X, Y, divide)
    %% FAIR utility
    % Jianqing Fan and Yingying Fan. 
    % High-dimensional classification using features annealed independence rules. The Annals of Statistics, 36(6), December 2008.
    
    % input:
    % X: vector, feature
    % Y: vector, response
    % divide: row vector, segmentation used to identify different clients
        % For 2 clients, the samples are 20 and 80 respectively, divide =[20 100]
        % For 3 clients, the samples are 50, divide = [50,100,150]
    % output:
    % utility

    m = length(divide);
    class = unique(Y);
    R = length(class);
    Num = zeros(m, R);
    He = zeros(R, 1);
    SHe = zeros(R, 1);   
    divide = [0 divide];

    for partition = 1:m
        m1 = 1 + divide(partition);
        m2 = divide(partition+1);
        X1 = X(m1:m2,:);
        Y1 = Y(m1:m2,:);

        nii = length(Y1);
        Yheng = repmat(Y1, 1, R);
        Yshu = repmat(class', nii, 1);
        Ycha = Yheng - Yshu;
        M = zeros(nii, R);
        M(Ycha == 0) = 1;
        num = sum(M);
        Num(partition, :) = num;
        HE_ii = zeros(R, 1);
        SHE_ii = zeros(R, 1);

        for jj = 1:R
            HE_ii(jj, :) = sum(X1 .* M(:, jj));
            SHE_ii(jj, :) = sum((X1 .* M(:, jj)).^2);
        end
        He = He + HE_ii;
        SHe = SHe + SHE_ii;
    end

    % Functional aggregation of the estimated component parameters
    N12 = sum(Num);
    junzhi = He ./ N12';
    junzhi_s = SHe ./ N12';

    junzhi1 = junzhi(1);
    junzhi2 = junzhi(2);
    num1 = N12(1);
    num2 = N12(2);

    fangcha1 = (junzhi_s(1) - junzhi1.^2) .* (num1 / (num1 - 1));
    fangcha2 = (junzhi_s(2) - junzhi2.^2) .* (num2 / (num2 - 1));
    W = abs((junzhi1 - junzhi2) ./ sqrt(fangcha1 / num1 + fangcha2 / num2));
end