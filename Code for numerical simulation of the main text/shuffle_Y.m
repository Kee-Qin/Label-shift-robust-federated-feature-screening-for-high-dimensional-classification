function Y = shuffle_Y(Y,m,shuffle_rate)
    %%  shuffle function used in example4 setting (f)
    %% a proportion of clients misalign the parameters of different categories.

    shuffle_client = floor(m*shuffle_rate);
    block = length(Y)/m;
    Y_temp = [];
    R = length(unique(Y));
    for partition = 1:shuffle_client
        m1 = 1 + block*(partition-1);
        m2 = block*partition;
        Y1 = Y(m1:m2);
        shuffle = randperm(R,R);
        for j =1:R
            Y1(Y1==j) = shuffle(j)+R;
        end
        Y1 = Y1-R;
        Y_temp = [Y_temp;Y1];
    end

    m1 = 1 + block*shuffle_client;
    Y1 = Y(m1:end);
    Y = [Y_temp;Y1];
end