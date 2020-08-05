function [V, lambda] = main(caseName, laplMat, SimComputed)
% MAIN main function which clusters a real-world dataset using different types of
% spectral clustering techniques and evaluates the results.
% 
% Input
% caseName: name of the dataset, i.e. 'ecoli' for the Ecoli_all.mat dataset
% laplMat:  input value deciding the type of Laplacian matrix to generate 
%           from the adjacency matrix, by default the normalized random-walk 
%           Laplacian is used:
%               - 1: use unnormalized Laplacian
%               - 2: use normalized symmetric Laplacian
%               - 3: use normalized random-walk Laplacian
%               - 4: use normalized random-walk beta Laplacian
    
    clc;
    close all;
    warning off;
    addpath helperFunctions/
    addpath helperFunctions/plotFunctions/
    addpath helperFunctions/computeLaplacians/
    addpath helperFunctions/evaluationFunctions/
    addpath helperFunctions/similarityFunctions/
    addpath helperFunctions/connectivityFunctions/
    
    if nargin < 3, SimComputed = 1; end
    if nargin < 2, laplMat  = 3; end
    if nargin < 1, error('No file specified'); end
    if (laplMat < 1 || laplMat > 4) 
        error('The input given is not applicable');
    end
    
    if SimComputed == 0
        [Pts, label, ~] = Generate_OPENML_datasets(caseName);
        W = computeSimGraph(Pts);
    else
        fileName = strcat(caseName,'_bus.mat');
        M = load(fileName);
        W = M.Problem.A;
        W = abs(W);
        n = size(W,1);
        label = zeros(n,1);
    end
    
    nonzero = nnz(W);
    nrows   = size(W,1);
    fprintf("Adjacency generated : nrows = %d, nnz = %d, nnzr = %d\n",...
            nrows, nonzero, nonzero/nrows);
    
    % Number of Clusters
    % K = 4;     
        
    if laplMat == 1
        [L, ~, ~]       = chooseLapl(W, 1);
        [V,lambda]      = eigs(L, 4, 'SM');
    elseif laplMat == 2
        [L, ~, ~]       = chooseLapl(W, 2);
        [V,lambda]      = eigs(L, 4, 'SM');
    elseif laplMat == 3
        [L, Diag, ~]    = chooseLapl(W, 3);
        [V,lambda]      = eigs(L, Diag, 4, 'SM');
    else
        [L, Diag, beta] = chooseLapl(W, 4);
        [V,lambda]      = eigs(L, Diag^(-beta), 4, 'SM');
        
    end
    rng('default')
    x_spec  = kmeans(V, 4,'Replicates', 10);

    % Evaluate clustering results, by computing confusion matrix, 
    % accuracy and RatioCut, NormalizedCut     
    evaluate_clusters(label, x_spec, W, 1, SimComputed);

    matName = strcat(caseName);
    matName = strcat(matName,'_results.mat');

    if(~strcmp(matName, "NULL"))
        save(matName,'W')
    end
    
    
end

