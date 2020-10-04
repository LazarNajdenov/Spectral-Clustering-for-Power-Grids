function [K, releigengaps, eigengaps] = findIndexBigEigengap(lambdas)
%FINDINDEXBIGEIGENGAP Summary of this function goes here
%   Detailed explanation goes here
    releigengaps = zeros(length(lambdas) - 2, 1);
    eigengaps = zeros(length(lambdas) - 2, 1);
    max = 0;
    K   = 2;
    for i = 2: length(lambdas) - 1
        releigengaps(i) = (lambdas(i+1) - lambdas(i)) / 2;
        eigengaps(i) = (lambdas(i+1) - lambdas(i));
        if releigengaps(i) > max
            max = releigengaps(i);
            K = i;
        end
    end
    

end

