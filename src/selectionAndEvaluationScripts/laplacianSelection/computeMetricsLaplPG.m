function [Ratio, NCut, Q, beta] = computeMetricsLaplPG(W, K)
% COMPUTEMETRICSLAPLPG Computes the metrics on the four different 
% Laplacians constructed from an adjacency matrix for Power Grid datasets

    % Compute unnormalized Laplacian
    [L, ~, ~] = chooseLapl(W, 1);
    % Compute symmetric normalized Laplacian
    [L_symm, ~, ~] = chooseLapl(W, 2);
    % Compute normalized Random-walk Laplacian (beta = 1)
    [~, Diag, ~] = chooseLapl(W, 3);
    
    
    
    % Unnormalized Laplacian
    fprintf('Unnormalized Laplacian (standard implementation with eigs) computation:\n')
    [RatioU, NCutU, QU] = metricsLapl(L, K, W, [], 1);
    fprintf('----------------------------------------------------------------------\n\n')
    % Symmetric Laplacian
    fprintf('Normalized Laplacian (standard implementation with eigs) computation:\n')
    [RatioS, NCutS, QS] = metricsLapl(L_symm, K, W, [], 2);
    fprintf('----------------------------------------------------------------------\n\n')
    % Random Walk Laplacian beta = 1
    fprintf('Random-Walk Laplacian (standard implementation with eigs) computation:\n')
    [RatioR, NCutR, QR] = metricsLapl(L, K, W, Diag, 3);
    fprintf('----------------------------------------------------------------------\n\n')

    % Random Walk Laplacian with variable beta
    fprintf('Random-Walk Beta (generalised Grassmann manifold with trace) computation,\n')
    fprintf('and be able to switch to vector computation of the functional:\n')
    
    [RatioB, NCutB, QB, beta] = computeMetricsBetaPG(L, Diag, W, K);
    fprintf('------------------------------------------------------------------------\n\n:')
    % Save all the results in arrays    
    Ratio  = [RatioU; RatioS; RatioR; RatioB];
    NCut   = [NCutU; NCutS; NCutR; NCutB];
    Q      = [QU; QS; QR; QB];
    
end

