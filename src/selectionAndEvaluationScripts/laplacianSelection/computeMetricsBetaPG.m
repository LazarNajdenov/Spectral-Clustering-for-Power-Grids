function [Ratio, NCut, Q, beta] = computeMetricsBetaPG(L, Diag, W, K, betas)
%COMPUTEMETRICSBETAPG compute cuts, and modularity of
% different clustering results which depend on different values of beta 
% ranging from 1.1 to 1.9 for constructing the Random-Walk Laplacian

    x_results1       = zeros(size(W, 1), 9);
    x_results2       = zeros(size(W, 1), 9);
    
    
    cuts1            = zeros(9,1);
    cuts2            = zeros(9,1);
    
    
    ncuts1           = zeros(9,1);
    ncuts2           = zeros(9,1);
    
    
    modularity1      = zeros(9,1);
    modularity2      = zeros(9,1);
    
    
    i = 1;
    while i <= 9
        
        [V, ~]    = generalized_eigenvalue_computation(L, Diag^(betas(i)), K);
        [V2, ~]    = eigs(L, Diag^(betas(i)), K, 'SM');
        
        x_results1(:,i) = kmeans(V, K, 'Replicates', 10);
        x_results2(:,i) = kmeans(V2, K, 'Replicates', 10);
        
        [~, ~, cuts1(i), ncuts1(i), modularity1(i)] = evaluate_clusters([], ...
                                                   x_results1(:,i), W, 0, 1);
        [~, ~, cuts2(i), ncuts2(i), modularity2(i)] = evaluate_clusters([], ...
                                                   x_results2(:,i), W, 0, 1);
       
        i = i + 1;
    end
    
    % Take index of modularity with higher value
    [~, j] = max(modularity1);
    % Take acc, rcut, ncut, modularity and beta from index j
    
    RatioB1 = cuts1(j);
    NCutB1  = ncuts1(j);
    QB1     = modularity1(j);
    beta1   = betas(j);
    
    % Take index of modularity with higher value
    [~, k] = max(modularity2);
    % Take acc, rcut, ncut, modularity and beta from index j
    
    RatioB2 = cuts2(k);
    NCutB2  = ncuts2(k);
    QB2     = modularity2(k);
    beta2   = betas(k);
    
    
    Ratio = [RatioB1; RatioB2];
    NCut  = [NCutB1; NCutB2];
    Q     = [QB1; QB2];
    beta  = [beta1; beta2];
end

