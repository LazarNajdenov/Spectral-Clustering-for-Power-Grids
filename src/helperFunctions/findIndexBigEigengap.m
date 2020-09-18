function [K, eigengaps] = findIndexBigEigengap(lambdas)
%FINDINDEXBIGEIGENGAP Summary of this function goes here
%   Detailed explanation goes here
    eigengaps = zeros(length(lambdas) - 2, 1);
    max = 0;
    K   = 2;
    for i = 2: length(lambdas) - 1
        eigengaps(i) = (lambdas(i+1) - lambdas(i)) / 2;
        if eigengaps(i) > max
            max = eigengaps(i);
            K = i;
        end
    end
    

end

