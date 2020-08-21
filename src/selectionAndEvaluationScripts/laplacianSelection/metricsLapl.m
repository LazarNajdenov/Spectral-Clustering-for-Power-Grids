function [Acc, Ratio, NCut, Q] = metricsLapl(L, K, W, Diag, typeLapl, label)
%METRICSUNNLAPL Computes all the metrics for the given Laplacian
    
    
    I = eye(size(W));
    
    % Different Eigenvectors Computations     
    if typeLapl < 3
        [V1, ~]    = generalized_eigenvalue_computation(L, I, K);
        [V2, ~]    = eigs(L, K, 'SM');
    else
        [V1, ~]    = generalized_eigenvalue_computation(L, Diag, K);
        [V2, ~]    = eigs(L, Diag, K, 'SM');
    end
    
    % Compute accuracies and cuts for by computing 10 replicates of kmeans
    % for each Laplacian to help find a lower, local minimum:
    if isempty(label)
        x_1 = kmeans(V1, K, 'Replicates', 10);
        [~, ~, Ratio1, NCut1, Q1] = evaluate_clusters(label, x_1, W, 0, 1);
        x_2 = kmeans(V2, K, 'Replicates', 10);
        [~, ~, Ratio2, NCut2, Q2] = evaluate_clusters(label, x_2, W, 0, 1);
        Acc = [0;0;0];
        
    else
        x_1 = kmeans(V1, K, 'Replicates', 10);
        [~, Acc1, Ratio1, NCut1, Q1] = evaluate_clusters(label, x_1, W, 0, 0);
        x_2 = kmeans(V2, K, 'Replicates', 10);
        [~, Acc2, Ratio2, NCut2, Q2] = evaluate_clusters(label, x_2, W, 0, 0);
    
        Acc   = [Acc1; Acc2; Acc3];
    end
    
    Ratio = [Ratio1; Ratio2; Ratio3];
    NCut  = [NCut1; NCut2; NCut3];
    Q     = [Q1; Q2; Q3];
end

