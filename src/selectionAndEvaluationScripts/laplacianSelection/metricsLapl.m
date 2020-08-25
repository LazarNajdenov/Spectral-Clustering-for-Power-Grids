function [Ratio, NCut, Q] = metricsLapl(L, K, W, Diag, typeLapl)
%METRICSUNNLAPL Computes all the metrics for the given Laplacian
    
    if typeLapl < 3
        [V1, ~]    = eigs(L, K, 'SM');
    else
        [V1, ~]    = eigs(L, Diag, K, 'SM');
    end
    
    % Compute accuracies and cuts for by computing 10 replicates of kmeans
    % for each Laplacian to help find a lower, local minimum:
    
    x_1 = kmeans(V1, K, 'Replicates', 10);
    [~, ~, Ratio1, NCut1, Q1] = evaluate_clusters([], x_1, W, 0, 1);
        
    Ratio = Ratio1;
    NCut  = NCut1;
    Q     = Q1;
end

