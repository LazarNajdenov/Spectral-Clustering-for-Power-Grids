% Benchmarking function which clusters power-grids datasets using different 
% types of eigenvalues computations, by creating 3 types of adjacency 
% matrices based on respectively:
% 1) Topology
% 2) Admittance - TODO
% 3) Average power flow
% It also estimates the number of clusters a-priori, 
% and evaluates the results.

clc;
clear;
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


cases = {'case30_solved'; 'case1354pegase_solved'; ... 
    'case1888rte_solved'; 'case2869pegase_solved'};

nc    = length(cases);

Ratio = zeros(nc, 2);
NCut  = zeros(nc, 2);
Q     = zeros(nc, 2);
bts   = zeros(nc, 2);


for i = 1: nc
    fprintf('%s test case computation:\n\n', cases{i});     
    % Generate the different adjacency matrices
    paramGraphs = Initialize_problem_PG(cases{i});
    
    % Adjacency using topology   
    W_TOP = paramGraphs.AdjTOP;
    
    % Adjacency using admittance
    % W_ADM = paramGraphs.AdjADM;
    
    % Adjacency using average power flow
    W_APF = paramGraphs.AdjAPF;
    % Normalize the APF
    maxValue = max(max(W_APF));
    W_APF = W_APF/maxValue;
    
    % Compute Laplacians
    [L_TOP, Diag_TOP] = chooseLapl(W_TOP, 4);
    % [L_ADM, Diag_ADM] = chooseLapl(W_ADM, 4);
    [L_APF, Diag_APF] = chooseLapl(W_APF, 4);
    
    % Compute the metrices
    fprintf('Evaluation on topology:\n\n');   
    [~, ~, RatioTOP, NCutTOP, QTOP, betaTOP] = computeMetricsBetaPG(L_TOP, Diag_TOP, W_TOP, 10);
    % fprintf('Evaluation on admittance:\n\n');     
    % [RatioADM, NCutADM, QADM, betaADM] = computeMetricsBetaPG(L_ADM, Diag_ADM, W_ADM, 10, betas);
    fprintf('\nEvaluation on average power flow:\n\n');
    [~, ~, RatioAPF, NCutAPF, QAPF, betaAPF] = computeMetricsBetaPG(L_APF, Diag_APF, W_APF, 10);
    
    % Save results in      
    Ratio(i, 1) = RatioTOP;
    Ratio(i, 2) = RatioAPF;
    NCut(i, 1)  = NCutTOP;
    NCut(i, 2)  = NCutAPF;
    Q(i, 1)     = QTOP;
    Q(i, 2)     = QAPF;
    bts(i, 1)   = betaTOP;
    bts(i, 2)   = betaAPF;
    
end

for i = 1: nc
    fprintf('\n######################################################################\n');
    fprintf("# %s test case best results:                              #\n", cases{i});
    fprintf('# Clusters evaluation with beta Laplacian on topology                #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f , beta = %f #\n', Ratio(i, 1), NCut(i, 1), Q(i, 1), bts(i, 1));
    fprintf('# ------------------------------------------------------------------ #\n');
    fprintf('# Clusters evaluation with beta Laplacian on APF                     #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f , beta = %f #\n', Ratio(i, 2), NCut(i, 2), Q(i, 2), bts(i, 2));
    fprintf('######################################################################\n\n');
end

