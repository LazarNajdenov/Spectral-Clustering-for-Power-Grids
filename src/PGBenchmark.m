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

RatioU = zeros(nc, 2);
NCutU  = zeros(nc, 2);
QU     = zeros(nc, 2);

RatioS = zeros(nc, 2);
NCutS  = zeros(nc, 2);
QS     = zeros(nc, 2);


RatioR = zeros(nc, 2);
NCutR  = zeros(nc, 2);
QR     = zeros(nc, 2);


for i = 1:nc
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
    
    % Compute unnormalized Laplacian
    [L1, ~] = chooseLapl(W_TOP, 1);
    % Compute symmetric normalized Laplacian
    [L_symm1, ~] = chooseLapl(W_TOP, 2);
    % Compute normalized Random-walk Laplacian (beta = 1)
    [~, Diag1] = chooseLapl(W_TOP, 3);
    
    % Compute unnormalized Laplacian
    [L2, ~] = chooseLapl(W_APF, 1);
    % Compute symmetric normalized Laplacian
    [L_symm2, ~] = chooseLapl(W_APF, 2);
    % Compute normalized Random-walk Laplacian (beta = 1)
    [~, Diag2] = chooseLapl(W_APF, 3);
    
    [RatioUT, NCutUT, QUT] = metricsLapl(L1, W_TOP, Diag1, 1);
    [RatioST, NCutST, QST] = metricsLapl(L_symm1, W_TOP, Diag1, 2);
    [RatioRT, NCutRT, QRT] = metricsLapl(L1, W_TOP, Diag1, 3);
    
    [RatioUA, NCutUA, QUA] = metricsLapl(L2, W_APF, Diag2, 1);
    [RatioSA, NCutSA, QSA] = metricsLapl(L_symm2, W_APF, Diag2, 2);
    [RatioRA, NCutRA, QRA] = metricsLapl(L2, W_APF, Diag2, 3);
    
    RatioU(i, 1) = RatioUT;
    RatioU(i, 2) = RatioUA;
    NCutU(i, 1)  = NCutUT;
    NCutU(i, 2)  = NCutUA;
    QU(i, 1)     = QUT;
    QU(i, 2)     = QUA;
    
    RatioS(i, 1) = RatioST;
    RatioS(i, 2) = RatioSA;
    NCutS(i, 1)  = NCutST;
    NCutS(i, 2)  = NCutSA;
    QS(i, 1)     = QST;
    QS(i, 2)     = QSA;
    
    RatioR(i, 1) = RatioRT;
    RatioR(i, 2) = RatioRA;
    NCutR(i, 1)  = NCutRT;
    NCutR(i, 2)  = NCutRA;
    QR(i, 1)     = QRT;
    QR(i, 2)     = QRA;
    
end

for i = 1: nc
    fprintf('\n######################################################################\n');
    fprintf("# %s test case best results:                                 #\n", cases{i});
    fprintf('# Clusters evaluation with unnormalized Laplacian on topology                #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RatioU(i, 1), NCutU(i, 1), QU(i, 1));
    fprintf('# ------------------------------------------------------------------ #\n');
    fprintf('# Clusters evaluation with unnormalized Laplacian on APF                     #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RatioU(i, 2), NCutU(i, 2), QU(i, 2));
    fprintf('######################################################################\n\n');
    
    fprintf('\n######################################################################\n');
    fprintf("# %s test case best results :                                #\n", cases{i});
    fprintf('# Clusters evaluation with symmetric Laplacian on topology                #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RatioS(i, 1), NCutS(i, 1), QS(i, 1));
    fprintf('# ------------------------------------------------------------------ #\n');
    fprintf('# Clusters evaluation with symmetric Laplacian on APF                     #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RatioS(i, 2), NCutS(i, 2), QS(i, 2));
    fprintf('######################################################################\n\n');
    
    fprintf('\n######################################################################\n');
    fprintf("# %s test case best results:                                 #\n", cases{i});
    fprintf('# Clusters evaluation with random walk Laplacian on topology              #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RatioR(i, 1), NCutR(i, 1), QR(i, 1));
    fprintf('# ------------------------------------------------------------------ #\n');
    fprintf('# Clusters evaluation with random walk Laplacian on APF                   #\n');
    fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RatioR(i, 2), NCutR(i, 2), QR(i, 2));
    fprintf('######################################################################\n\n');
end

% Beta Laplacian computation
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

