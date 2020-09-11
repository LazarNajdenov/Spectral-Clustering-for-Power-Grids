function [K] = findIndexBigEigengap(lambdas)
%FINDINDEXBIGEIGENGAP Summary of this function goes here
%   Detailed explanation goes here
    max = 0;
    for i = 2: length(lambdas) - 1
        eigengap = (lambdas(i+1) - lambdas(i)) / 2;
        if eigengap > max
            max = eigengap;
            K = i;
        end
    end
    

end

