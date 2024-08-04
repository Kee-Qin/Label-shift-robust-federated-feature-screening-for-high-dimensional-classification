function Y = Y_attack(Y,m,attack_rate)
    %%  shuffle function used in example4 setting (g)
    %% a proportion of labels Y are randomly shuffled

    attack_client = floor(m*attack_rate);
    block = length(Y)/m;
    Y_temp = [];
    R = length(unique(Y));
    for partition = 1:attack_client
        m1 = 1 + block*(partition-1);
        m2 = block*partition;
        Y1 = Y(m1:m2);
        Y1(randperm(block,block)) = Y1;
        Y_temp = [Y_temp;Y1];
    end

    m1 = 1 + block*attack_client;
    Y1 = Y(m1:end);
    Y = [Y_temp;Y1];
end