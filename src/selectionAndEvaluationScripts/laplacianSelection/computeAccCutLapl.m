function [Acc, Ratio, NCut, Q, beta] = computeAccCutLapl(W, label, betas)
% TO CHANGE FOR NEW IMPLEMENTATION OF CHOOSLAPL!!!!

% COMPUTEAVGACC Computes the average accuracies on the three different 
% Laplacians constructed from an adjacency matrix with the kNN connectivity
% function and the Max similarity function, for a particular dataset
    
    % Compute unique values of the labels with no repetition
    unique_labels = unique(label);
    % Compute the number of unique labels
    K = size(unique_labels,1);
    % Compute unnormalized Laplacian     
    [V1, ~] = chooseLapl(W, K, 1);
    % Compute symmetric normalized Laplacian
    [V2, ~] = chooseLapl(W, K, 2);
    % Compute normalized Random-walk Laplacian (beta = 1)
    [V3, ~] = chooseLapl(W, K, 3);
    % Compute normalized Random-walk Laplacian (beta = 1.4)
    
    
    % Compute accuracies and cuts for by computing 10 replicates of kmeans
    % for each Laplacian to help find a lower, local minimum:
    
    % Unnormalized Laplacian
    x_results1 = kmeans(V1, K, 'Replicates', 10);
%     x_inferred1 = label_data(x_results1, label);
    [~, AccU, RatioU, NCutU, QU] = evaluate_clusters(label, x_results1, W, 0, 0);

    % Symmetric Laplacian
    x_results2 = kmeans(V2, K,'Replicates', 10);
%     x_inferred2 = label_data(x_results2, label);
    [~, AccS, RatioS, NCutS, QS] = evaluate_clusters(label, x_results2, W, 0, 0);
    
    % Random Walk Laplacian beta = 1
    x_results3 = kmeans(V3, K, 'Replicates', 10);
%     x_inferred3 = label_data(x_results3, label);
    [~, AccR, RatioR, NCutR, QR] = evaluate_clusters(label, x_results3, W, 0, 0);

    % Random Walk Laplacian with variable beta
    [accs, cuts, ncuts, mods] = computeAccCutModulBeta(W, K, label);
    % Take index of modularity with higher value
    [~, i] = max(mods);
    
    % Take acc, rcut, ncut, modularity and beta from index i
    AccB   = accs(i);
    RatioB = cuts(i);
    NCutB  = ncuts(i);
    QB     = mods(i);
    beta   = betas(i);
    
    % Save all the results in arrays    
    Acc    = [AccU, AccS, AccR, AccB];
    Ratio  = [RatioU, RatioS, RatioR, RatioB];
    NCut   = [NCutU, NCutS, NCutR, NCutB];
    Q      = [QU, QS, QR, QB];
    
end

