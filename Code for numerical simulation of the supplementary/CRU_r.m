function  w = CRU_r(X,Y,r)
    %% class-specific screening for CRU

    n = length(Y);
    pi_hat = sum(Y==r)/n;
    b1 = X(Y==r);
    count = sum(sum(X<b1'));
    theta_hat = count /((n-1)*n);
    
    w = power((theta_hat -pi_hat/2),2);
end