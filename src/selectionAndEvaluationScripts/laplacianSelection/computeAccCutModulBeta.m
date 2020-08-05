function [accuracy, cuts, ncuts, modularity] = computeAccCutModulBeta(W, K, label)
% TO CHANGE FOR NEW IMPLEMENTATION OF CHOOSLAPL!!!!

% COMPUTEACCCUTMODULBETA compute accuracy, cuts, and modularity of
% different clustering results which depend on different values of beta 
% ranging from 1 to 2 for constructing the Random-Walk Laplacian
    x_results       = zeros(size(W, 1), 9);
%     x_inferred      = zeros(size(W, 1), 9);
    accuracy        = zeros(9,1);
    cuts            = zeros(9,1);
    ncuts           = zeros(9,1);
    modularity      = zeros(9,1);
    beta = 1.1;
    i = 1;
    while i <= 9
        [V, ~] = randomWalkBeta(W, K, beta);
        x_results(:,i) = kmeans(V, K);
%         x_inferred(:, i) = label_data(x_results(:,i), label);
        [~, accuracy(i), cuts(i), ncuts(i), modularity(i)] = evaluate_clusters(label, ...
                                                   x_results(:,i), W, 0, 0);
        beta = beta + 0.1;
        i = i + 1;
    end 
end
