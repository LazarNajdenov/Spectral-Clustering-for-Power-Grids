function [lambdas, Xsol, Dsol, L, K, releigengaps, W] = main(fileName, adj)
% MAIN main function which clusters power-grids datasets using different 
% types of spectral clustering techniques, by creating 3 types of adjacency 
% matrices based on respectively:
% 1) Topology
% 2) Admittance - TODO
% 3) Average power flow
% It also estimates the number of clusters a-priori, plots the 
% eigenvalue distributions, the relative eigengaps, 
% and evaluates the results.
% 
% Input
% fileName: name of the dataset, i.e. 'case9_solved' for the case9_solved.m dataset
% adj: numeric value which tells the tool which adjacency to compute

    
    clc;
    close all;
    warning off;
    addpath helperFunctions/
    addpath manopt/
    addpath(genpath(pwd))
    addpath helperFunctions/plotFunctions/
    addpath helperFunctions/computeLaplacians/
    addpath helperFunctions/evaluationFunctions/
    addpath helperFunctions/similarityFunctions/
    addpath helperFunctions/connectivityFunctions/
    
    fprintf('This tool clusters power-grids datasets using different types\n');
    fprintf('of adjacency matrices and evaluates the results.\n\n');
    
    if nargin < 2, adj = 1; end
    if nargin < 1, error('No file specified'); end
    if (adj < 1 || adj > 3)
        error('The input given is not applicable');
    end
    
    fprintf('ADJACENCY CREATION \n\n')
    
    paramGraphs = Initialize_problem_PG(fileName);
    [W, adjType] = chooseAdj(adj, paramGraphs);

    fprintf('LAPLACIAN COMPUTATION\n\n')
    fprintf('##########################\n')
     
    % Random Walk Beta Laplacian
    [L, Diag] = chooseLapl(W, 4);

    fprintf('BETA SELECTION and EVALUATION:\n\n');
    
    % Find best beta based on highest modularity     
    [Xsol, Dsol, Ratio, NCut, Q, beta] = computeMetricsBetaPG(L, Diag, W, 10);

    % Eigs computation
    fprintf('\n# ----------------------------------- #\n')
    fprintf('# 10 biggest eigenvalues computation  #\n')
    fprintf('# ----------------------------------- #\n\n')
    [~,lambdas] = eigs(L, 10);
    
    % Search for the biggest eigengap and the index is gives the number of 
    % clusters a priori     
    [K, releigengaps, eigengaps] = findIndexBigEigengap(Dsol);
    
    % Normalize eigenvalues     
    lambdas = diag(lambdas);
    lambdas = (lambdas) / max(lambdas);
    
    % Plot first 10 biggest eigenvalues distributions
    % and eigengaps distribution     
    plots(lambdas, releigengaps, eigengaps);
    
    fprintf('RESULTS:\n\n');
    fprintf('# Clusters evaluation with beta = %f and adjacency based on %s \n', beta, adjType);
    fprintf('# RCut = %f, NCut = %f, MOD = %f                       \n', Ratio, NCut, Q);
    fprintf('# ----------------------------------------------------------- #\n\n');
    
end

