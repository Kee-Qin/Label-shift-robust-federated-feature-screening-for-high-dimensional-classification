function Generate = generation
%%  this function is used to generate NonIID catagory data(Y)

%% @getY(N,m,alpha1,alpha2,class)
% The simplest category NonIID scenario

% Input: 
% N: Total sample size
% m: The number of client
% alpha1,alpha2: Range of degrees of heterogeneity
%              The greater the gap between alpha1 and alpha2, the greater the heterogeneity
% class: Number of categories
% Output:
% Y: N * 1 vector

% hint: With a simple setup, the sample size of m machines is the same

%% @getY_none(N,m,class,K)
% Each client lacks samples of K categories, 
% and the rest of the classes are IID distributed.

% Input: 
% N: Total sample size
% m: The number of client
% class: Number of categories
% K: Number of missing categories
% Output:
% Y: N * 1 vector

%% @getY_dir(N,m,alpha_d,class)
% The category proportion obeys the Dirichlet distribution

% Input: 
% N: Total sample size
% m: The number of client
% alpha_d: degree of heterogeneity
% class: Number of categories
% Output:
% Y: N * 1 vector

    Generate.getY = @getY;
    Generate.getY_none = @getY_none;
    Generate.getY_none_divide = @getY_none_divide;
    Generate.getY_none_heter = @getY_none_heter;
    Generate.getY_dir = @getY_dir;
end

function Y = getY(N,m,alpha1,alpha2,class)
%% The simplest category NonIID scenario
    block = N/m;
    Y = [];
    for t = 1:m
        alpha = unifrnd(alpha1,alpha2,1,class);
        alpha = exp(alpha) / sum(exp(alpha));
        alpha = cumsum(alpha);
        alpha = round(alpha * block);
        alpha = [0 alpha];
        Y1 = zeros(block,1);
        for tt = 1:class
            Y1(alpha(tt)+1:alpha(tt+1)) = tt;
        end
        Y = [Y;Y1];
    end
end

function Y = getY_none(N,m,class,K)
%% Each client lacks samples of K categories
    block = N/m;
    Y = [];
    for t = 1:m
        alpha = ones(1,class)/(class-K);
        set_zero = randperm(class,K);
        alpha(set_zero) = 0;
        
        alpha = cumsum(alpha);
        alpha = round(alpha * block);
        alpha = [0 alpha];

        Y1 = zeros(block,1);
        for tt = 1:class
            Y1(alpha(tt)+1:alpha(tt+1)) = tt;
        end
        Y = [Y;Y1];
    end
end

function Y = getY_none_divide(class,K,divide)
%% Each client lacks samples of K categories
    m = length(divide);
    divide = [0 divide];
    Y = [];
    for partition = 1:m
        block = divide(partition+1)-divide(partition);
        alpha = ones(1,class)/(class-K);
        set_zero = randperm(class,K);
        alpha(set_zero) = 0;
        
        alpha = cumsum(alpha);
        alpha = round(alpha * block);
        alpha = [0 alpha];

        Y1 = zeros(block,1);
        for tt = 1:class
            Y1(alpha(tt)+1:alpha(tt+1)) = tt;
        end
        Y = [Y;Y1];
    end
end


function Y = getY_dir(N,m,alpha_d,class)
%%  The category proportion obeys the Dirichlet distribution
    block = N/m;
    Y = [];
    for t = 1:m
        alpha = gamrnd(repmat(alpha_d,1,class),1);
        alpha = alpha / sum(alpha);
        alpha = cumsum(alpha);
        alpha = round(alpha * block);
        alpha = [0 alpha];
        Y1 = zeros(block,1);
        for tt = 1:class
            Y1(alpha(tt)+1:alpha(tt+1)) = tt;
        end
        Y = [Y;Y1];
    end
end

function Y = getY_none_heter(N,m,alpha1,alpha2,class,K)
    block = N/m;
    Y = [];
    for t = 1:m
        alpha = unifrnd(alpha1,alpha2,1,class);
        set_zero = randperm(class,K);
        alpha(set_zero) = 0;
        alpha = exp(alpha) / sum(exp(alpha));

        alpha = cumsum(alpha);
        alpha = round(alpha * block);
        alpha = [0 alpha];
        Y1 = zeros(block,1);
        for tt = 1:class
            Y1(alpha(tt)+1:alpha(tt+1)) = tt;
        end
        Y = [Y;Y1];
    end
end