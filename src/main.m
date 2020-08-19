function [V, lambda, Xsol, Dsol, Xsol2, Dsol2, L] = main(caseName, laplMat, SimComputed)
% MAIN main function which clusters real-world datasets using different types of
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
    
    rng('default');
    
    fprintf('This tool clusters real-world datasets using different types\n');
    fprintf('of spectral clustering techniques and evaluates the results.\n\n');
    
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
    
    %     nonzero = nnz(W);
    %     nrows   = size(W,1);
    %     fprintf("Adjacency generated : nrows = %d, nnz = %d, nnzr = %d\n",...
    %             nrows, nonzero, nonzero/nrows);
    
    % Number of Clusters
    % K = 4;
    I = eye(size(W));
    fprintf('LAPLACIAN COMPUTATION:\n\n')
    fprintf('##########################\n')
    if laplMat == 1
        % Unnormalized Laplacian         
        [L, ~, ~]       = chooseLapl(W, 1);
        
        
        % Manifold computations        
        
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        [Xsol, ~, Dsol] = Manopt_Grassmann(L, 4);
        [Xsol2, Dsol2]  = generalized_eigenvalue_computation(L, I, 4);
        
        % Eigs computation
        fprintf('# ----------------------------------- #\n')
        fprintf('# Eigs computation                    #\n')
        [V,lambda]      = eigs(L, 4, 'SM');
    elseif laplMat == 2
        % Normalized Laplacian
        [L, ~, ~]       = chooseLapl(W, 2);
        
        
        % Manifold computations        
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        [Xsol, ~, Dsol] = Manopt_Grassmann(L, 4);
        [Xsol2, Dsol2]  = generalized_eigenvalue_computation(L, I, 4);
        
        % Eigs computation         
        fprintf('# ----------------------------------- #\n')
        fprintf('# Eigs computation                    #\n')
        [V,lambda]      = eigs(L, 4, 'SM');
    elseif laplMat == 3
        % Random Walk Laplacian         
        [L, Diag, ~]    = chooseLapl(W, 3);
        
        
        % Manifold computations
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        [Xsol, ~, Dsol] = Manopt_Grassmann(L, 4);
        [Xsol2, Dsol2]  = generalized_eigenvalue_computation(L, Diag, 4);
        
        % Eigs computation
        fprintf('# ----------------------------------- #\n')
        fprintf('# Eigs computation                    #\n')
        [V,lambda]      = eigs(L, Diag, 4, 'SM');
    else
        % Random Walk Beta Laplacian         
        [L, Diag, beta] = chooseLapl(W, 4);
        
        
        % Manifold computations
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        [Xsol, ~, Dsol] = Manopt_Grassmann(L, 4);
        [Xsol2, Dsol2]  = generalized_eigenvalue_computation(L, Diag^(beta), 4);
        
        % Eigs computation
        fprintf('# ----------------------------------- #\n')
        fprintf('# Eigs computation                    #\n')
        [V,lambda]      = eigs(L, Diag^(beta), 4, 'SM');
        
        
    end
    
    
    fprintf('#######################################\n\n\n')
    % Compute clustering on eigenvectors     
    x_spec  = kmeans(V, 4,'Replicates', 10);
    x_spec2 = kmeans(Xsol, 4, 'Replicates', 10);
    x_spec3 = kmeans(Xsol2, 4, 'Replicates', 10);

    % Evaluate clustering results, by computing confusion matrix, 
    % accuracy and RatioCut, NormalizedCut
    fprintf('CLUSTERS EVALUATIONS:\n\n')
    fprintf('######################################################\n')
    fprintf('# Clusters evaluation with eigs                      #\n');
    evaluate_clusters(label, x_spec, W, 0, SimComputed);
    fprintf('# -------------------------------------------------- #\n')
    fprintf('# Clusters evaluation with manopt grassman           #\n');
    evaluate_clusters(label, x_spec2, W, 0, SimComputed);
    fprintf('# -------------------------------------------------- #\n')
    fprintf('# Clusters evaluation with gener. manopt grassman    #\n');
    evaluate_clusters(label, x_spec3, W, 0, SimComputed);
    fprintf('######################################################\n')
    
    
%     matName = strcat(caseName);
%     matName = strcat(matName,'_results.mat');
% 
%     if(~strcmp(matName, "NULL"))
%         save(matName,'W')
%     end
    
    
end

