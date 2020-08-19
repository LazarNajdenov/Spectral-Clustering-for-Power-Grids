function [Acc, Ratio, NCut, Q, beta] = computeMetricsLapl(W, label, betas)
% COMPUTEMETRICSLAPL Computes the metrics on the four different 
% Laplacians constructed from an adjacency matrix for Artificial/OpenML datasets

    % Compute unique values of the labels with no repetition
    unique_labels = unique(label);
    % Compute the number of unique labels
    K = size(unique_labels,1);
    % Compute unnormalized Laplacian
    [L, ~, ~] = chooseLapl(W, 1);
    % Compute symmetric normalized Laplacian
    [L_symm, ~, ~] = chooseLapl(W, 2);
    % Compute normalized Random-walk Laplacian (beta = 1)
    [~, Diag, ~] = chooseLapl(W, 3);
    
    
    
    % Unnormalized Laplacian
    fprintf('Unnormalized:\n')
    [AccU, RatioU, NCutU, QU] = metricsLapl(L, K, W, [], 1, label);
    fprintf('------------------------------------\n\n:')
    % Symmetric Laplacian
    fprintf('Normalized:\n')
    [AccS, RatioS, NCutS, QS] = metricsLapl(L_symm, K, W, [], 2, label);
    fprintf('------------------------------------\n\n:')
    % Random Walk Laplacian beta = 1
    fprintf('Random-Walk:\n')
    [AccR, RatioR, NCutR, QR] = metricsLapl(L, K, W, Diag, 3, label);
    fprintf('------------------------------------\n\n:')

    % Random Walk Laplacian with variable beta
    fprintf('Random-Walk Beta:\n')
    % Modularity is the fraction of the edges that fall within the given 
    % groups minus the expected fraction if edges were distributed at random. 
    % The value of the modularity for unweighted and undirected graphs lies 
    % in the range [-1/2,1].
    [AccB, RatioB, NCutB, QB, beta] = computeMetricsBeta(L, Diag, W, K, label, betas);
    fprintf('------------------------------------\n\n:')
    % Save all the results in arrays    
    Acc    = [AccU, AccS, AccR, AccB];
    Ratio  = [RatioU, RatioS, RatioR, RatioB];
    NCut   = [NCutU, NCutS, NCutR, NCutB];
    Q      = [QU, QS, QR, QB];
    
end

