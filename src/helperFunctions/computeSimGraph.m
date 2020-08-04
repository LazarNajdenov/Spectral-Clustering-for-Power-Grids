function [W] = computeSimGraph(Pts)
%COMPUTESIMGRAPH compute the adjacency matrix for the given points based on 
% the similarity graph configuration:

    kNN = input('Choose the number of kNN\n');
    G = kNNConGraph(Pts, kNN);
    if ~isConnected(G), error('The graph is not connected'); end
    S = maxSimilarityfunc(Pts, kNN);
    W = sparse(S .* G);
end

