function [Ratio, NCut, Q] = metricsLapl(L, W, Diag, typeLapl)
%METRICSUNNLAPL Computes all the metrics for the given Laplacian
    
    if typeLapl < 3
        I = eye(size(W));
        [xsols, dsols]    = generalized_eigenvalue_computation(L, I, 10, 1);
    else
        [xsols, dsols]    = generalized_eigenvalue_computation(L, Diag, 10, 1);
    end
    
    % Find number of cluster a priori
    dsols  = diag(dsols);
    [K, ~] = findIndexBigEigengap(dsols);

    % Cluster on the new spectral dimension         
    x_results = kmeans(xsols(:, 1:K), K, 'Replicates', 10);

    % Evaluate the clusters         
    [~, ~, cuts, ncuts, modularity] = evaluate_clusters([], ...
                                               x_results, W, 0, 1);
        
    Ratio = cuts;
    NCut  = ncuts;
    Q     = modularity;
end

