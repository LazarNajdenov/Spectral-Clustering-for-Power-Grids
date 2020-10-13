function [Vs, Ds, Ratio, NCut, Q, beta] = computeMetricsBetaPG(L, Diag, W, J)
%COMPUTEMETRICSBETAPG compute cuts, and modularity of
% different clustering results which depend on different values of beta 
% ranging from 1.1 to 1.9 for constructing the Random-Walk Beta Laplacian
    
    rng('default');
    % Initialize variables
    betas           = 1.1:0.1:1.9; 
    x_results       = zeros(size(W, 1), 9);
    cuts            = zeros(9,1);
    ncuts           = zeros(9,1);
    modularity      = zeros(9,1);
    
    i = 1;
    while i <= 9
        
        % Generalized eigenvalue_computation with trace         
        [xsols, dsols]    = eigs(L, Diag^(betas(i)), J, 'SM');
        
        % Find number of cluster a priori
        dsols  = diag(dsols);
        [K, ~] = findIndexBigEigengap(dsols);
        
        % Cluster on the new spectral dimension         
        x_results(:,i) = kmeans(xsols(:, 1:K), K, 'Replicates', 10);
        
        % Evaluate the clusters         
        [~, ~, cuts(i), ncuts(i), modularity(i)] = evaluate_clusters([], ...
                                                   x_results(:,i), W, 0, 1);
        
        if i > 1
            if ncuts(i) < Q
                Vs = xsols;
                Ds = dsols;
                Ratio = cuts(i);
                NCut  = ncuts(i);
                Q     = modularity(i);
                beta  = betas(i); 
            end
        else
             Vs = xsols;
             Ds = dsols;
             Ratio = cuts(i);
             NCut  = ncuts(i);
             Q     = modularity(i);
             beta  = betas(i);
        end
        
        i = i + 1;
    end
    
end

