function [V, lambda, Xsol, Dsol, L, K, W] = main(fileName, laplMat, powerGrid, adj, tr)
% MAIN main function which clusters power-grids datasets using different 
% types of spectral clustering techniques, by creating 3 types of adjacency 
% matrices based on respectively:
% 1) Topology
% 2) Admittance - TODO
% 3) Average power flow
% It also estimates the number of clusters a-priori, 
% and evaluates the results.
% 
% Input
% caseName: name of the dataset, i.e. 'case9' for the case9_solved.mat dataset
% laplMat: input value deciding the type of Laplacian matrix to generate 
%           from the adjacency matrix, by default the normalized
%           random-walk beta Laplacian is used:
%               - 1: use unnormalized Laplacian
%               - 2: use normalized symmetric Laplacian
%               - 3: use normalized random-walk Laplacian
%               - 4: use normalized random-walk beta Laplacian
% powerGrid: boolean value that tells if the dataset is a powerGrid or not
% tr: boolean value that tells the tool to use the trace for the
%             generalized_eigenvalue_computation or not
    
    clc;
    close all;
    warning off;
    addpath helperFunctions/
    addpath manopt/
    addpath helperFunctions/plotFunctions/
    addpath helperFunctions/computeLaplacians/
    addpath helperFunctions/evaluationFunctions/
    addpath helperFunctions/similarityFunctions/
    addpath helperFunctions/connectivityFunctions/
    
    rng('default');
    
    fprintf('This tool clusters power-grids datasets using different types\n');
    fprintf('of spectral clustering techniques and evaluates the results.\n\n');
    
    if nargin < 5, tr = 0; end
    if nargin < 4, adj = 1; end
    if nargin < 3, powerGrid = 1; end
    if nargin < 2, laplMat  = 4; end
    if nargin < 1, error('No file specified'); end
    if (laplMat < 1 || laplMat > 4) 
        error('The input given is not applicable');
    end
    if (adj < 1 || adj > 3)
        error('The input given is not applicable');
    end
    
    if powerGrid == 0
        [Pts, label, ~] = Generate_OPENML_datasets(caseName);
        W = computeSimGraph(Pts);
    else
%       fileName = strcat(caseName,'_solved');
        paramGraphs = Initialize_problem_PG(fileName);
        if adj == 1
            W = paramGraphs.AdjTOP;
        elseif adj == 2
%           TODO:
%           W = paramGraphs.AdjADM;
            fprintf('TODO\n');
        else
            W = paramGraphs.AdjAPF;
            maxValue = max(max(W));
            W = W/maxValue;
        end
%       M = load(fileName);
%       W = M.Problem.A;
%       W = abs(W);
%       W
        n = size(W,1);
        label = zeros(n,1);
    end
    
    %     nonzero = nnz(W);
    %     nrows   = size(W,1);
    %     fprintf("Adjacency generated : nrows = %d, nnz = %d, nnzr = %d\n",...
    %             nrows, nonzero, nonzero/nrows);
    
    I = eye(size(W));
    fprintf('LAPLACIAN COMPUTATION:\n\n')
    fprintf('##########################\n')
    if laplMat == 1
        % Unnormalized Laplacian         
        [L, ~, ~]       = chooseLapl(W, 1);
        
        
        % Manifold computation        
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        issymmetric(L)
        [Xsol, Dsol]  = generalized_eigenvalue_computation(L, I, 9, tr);
        
    elseif laplMat == 2
        % Normalized Laplacian
        [L, ~, ~]       = chooseLapl(W, 2);
        
        
        % Manifold computation       
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        
        [Xsol, Dsol]  = generalized_eigenvalue_computation(L, I, 10, tr);

    elseif laplMat == 3
        % Random Walk Laplacian         
        [L, Diag, ~]    = chooseLapl(W, 3);
        
        
        % Manifold computation
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        [Xsol, Dsol]  = generalized_eigenvalue_computation(L, Diag, 10, tr);
        
%         % Eigs computation
%         fprintf('# ----------------------------------- #\n')
%         fprintf('# Eigs computation                    #\n')
%         [V,lambda]      = eigs(L, Diag, 10, 'SM');
    else
        % Random Walk Beta Laplacian
        [L, Diag, beta] = chooseLapl(W, 4);
        
        % Manifold computation
        fprintf('SMALLEST K EIGENVALUES COMPUTATIONS:\n\n')
        if n < 10
            [Xsol, Dsol]  = generalized_eigenvalue_computation(L, Diag^(beta), 4, tr);
            % Eigs computation
            fprintf('# ----------------------------------- #\n')
            fprintf('# Eigs computation                    #\n')
            [V,lambda]    = eigs(L, Diag^(beta), 4, 'SM');
        else
            [Xsol, Dsol]  = generalized_eigenvalue_computation(L, Diag^(beta), 10, tr);
            % Eigs computation
            fprintf('# ----------------------------------- #\n')
            fprintf('# Eigs computation                    #\n')
            [V,lambda]    = eigs(L, Diag^(beta), 10, 'SM');
        end
        
        Dsol = diag(Dsol);
        K = findIndexBigEigengap(Dsol);
        
    end
    
    
    fprintf('#######################################\n\n\n')
    % Compute clustering on eigenvectors     
    x_spec  = kmeans(V, K,'Replicates', 10);
    x_spec2 = kmeans(Xsol, K, 'Replicates', 10);
    

    % Evaluate clustering results, by computing confusion matrix, 
    % accuracy and RatioCut, NormalizedCut
    fprintf('CLUSTERS EVALUATIONS:\n\n')
    fprintf('######################################################\n')
    fprintf('# Clusters evaluation with eigs                      #\n');
    evaluate_clusters(label, x_spec, W, 0, powerGrid);
    fprintf('# -------------------------------------------------- #\n')
    fprintf('# Clusters evaluation with general. manopt grassman  #\n');
    evaluate_clusters(label, x_spec2, W, 0, powerGrid);
    fprintf('######################################################\n')
    
    
%     matName = strcat(caseName);
%     matName = strcat(matName,'_results.mat');
% 
%     if(~strcmp(matName, "NULL"))
%         save(matName,'W')
%     end
    
    
end

