% Script for selecting the best Laplacian matrix among the following four:
% 1) Unnormalized Laplacian
% 2) Normalized Symmetric Laplacian
% 3) Normalized Random-Walk Laplacian
% 4) Normalized Random-Walk Beta Laplacian
% For safe comparison/reproducibility we fix a rng seed.
% We expect fewer outliers in the case of Random-Walk Laplacian.

clc;
clear;
close all;

warning off
addpath ../
addpath ../../
addpath ../../helperFunctions/
addpath ../../helperFunctions/computeLaplacians/
addpath ../../helperFunctions/evaluationFunctions/
addpath ../../helperFunctions/similarityFunctions/
addpath ../../helperFunctions/connectivityFunctions/

betas = 1.1:0.1:1.9;

% Power Grids Datasets Evaluation

% Admittance cases:
load cases_admittance.mat

warning off
% For reproducibility, set rng seed
rng('default');

[B494_Ratio, B494_NCut, B494_Q, beta_B494] = computeMetricsLaplPG(W_B494, betas, 4);

[B662_Ratio, B662_NCut, B662_Q, beta_B662] = computeMetricsLaplPG(W_B662, betas, 4);

[B685_Ratio, B685_NCut, B685_Q, beta_B685] = computeMetricsLaplPG(W_B685, betas, 4);

[B1138_Ratio, B1138_NCut, B1138_Q, beta_B1138] = computeMetricsLaplPG(W_B1138, betas, 4);

%% Topology cases
load cases_topology.mat

warning off
% For reproducibility, set rng seed
rng('default');

[bcspwr03_Ratio, bcspwr03_NCut, bcspwr03_Q, beta_bcspwr03] = computeMetricsLaplPG(W_bcspwr03, betas, 4);

[bcspwr04_Ratio, bcspwr04_NCut, bcspwr04_Q, beta_bcspwr04] = computeMetricsLaplPG(W_bcspwr04, betas, 4);

[bcspwr05_Ratio, bcspwr05_NCut, bcspwr05_Q, beta_bcspwr05] = computeMetricsLaplPG(W_bcspwr05, betas, 4);

[bcspwr06_Ratio, bcspwr06_NCut, bcspwr06_Q, beta_bcspwr06] = computeMetricsLaplPG(W_bcspwr06, betas, 4);

[bcspwr07_Ratio, bcspwr07_NCut, bcspwr07_Q, beta_bcspwr07] = computeMetricsLaplPG(W_bcspwr07, betas, 4);

[bcspwr08_Ratio, bcspwr08_NCut, bcspwr08_Q, beta_bcspwr08] = computeMetricsLaplPG(W_bcspwr08, betas, 4);

[bcspwr09_Ratio, bcspwr09_NCut, bcspwr09_Q, beta_bcspwr09] = computeMetricsLaplPG(W_bcspwr09, betas, 4);

[bcspwr10_Ratio, bcspwr10_NCut, bcspwr10_Q, beta_bcspwr10] = computeMetricsLaplPG(W_bcspwr10, betas, 4);

[pwrNewman_Ratio, pwrNewman_NCut, pwrNewman_Q, beta_pwrNewman] = computeMetricsLaplPG(W_powerNewman, betas, 4);
