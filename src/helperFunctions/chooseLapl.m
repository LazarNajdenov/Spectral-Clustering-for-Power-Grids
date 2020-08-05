function [L, Diag, beta] = chooseLapl(W, laplMat)
% CLUSTERROWS function that computes the laplacian matrix
% L which can be, depending on the input given:
%   - unnormalized, if input = 1 
%   - symmetric normalized, if input = 2
%   - random-walk Laplacian, if input = 3
% and compute the relative K smallest magnitude eigenvectors
% 
% Input
% W      : Adjacency matrix
% K      : Number of clusters
% Output
% V      : K smallest eigenvectors
% lambda : K smallest eigenvalues
    
    beta = 0;
    n = size(W,1);
    Diag = zeros(n);
    % Unnormalized Laplacian
    if laplMat == 1
        [L] = unnormLapl(W);
    % Symmetric Normalized Laplacian
    elseif laplMat == 2
        [L] = symmLapl(W);
    % Random-Walk Laplacian
    elseif laplMat == 3
        [L, Diag] = randwalkLapl(W);
    % Random-Walk Beta Laplacian
    elseif laplMat == 4
        beta = input('Choose the beta value\n');
        [L, Diag] = randomWalkBeta(W);
    end
    
end