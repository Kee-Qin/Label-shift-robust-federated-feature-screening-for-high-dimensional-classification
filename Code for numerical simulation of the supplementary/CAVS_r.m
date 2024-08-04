function  w = CAVS_r(X,Y,r)
    %% class-specific screening for CAVS

    b1 = X(Y==r);
    b2 = X;
    count = sum(sum(b2<b1'));
    total = length(b1) * length(b2);
    w = abs(count/total-0.5);
end