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
%% Artificial Datasets Evaluation
warning off
% For reproducibility, set rng seed
rng('default');

load cases_thesis.mat

% Aggregation7 dataset kNN = 40
[AggrAcc, AggrRatio, AggrNCut, AggrQ, betaAggr] = computeMetricsLapl(WAggr, labelAggr, betas);

% Compound6 dataset kNN = 20
[CompAcc, CompRatio, CompNCut, CompQ, betaComp] = computeMetricsLapl(WComp, labelComp, betas);

% R15 dataset kNN = 40
[R15Acc, R15Ratio, R15NCut, R15Q, betaR15]      = computeMetricsLapl(WR15, labelR15, betas);

% Spiral3 dataset kNN = 20
[SpirAcc, SpirRatio, SpirNCut, SpirQ, betaSpir] = computeMetricsLapl(WSpir, labelSpiral, betas);
%% Ecoli dataset evaluation
% Ecoli dataset kNN = 10, size = 336
% [EcolAcc, EcolRatio, EcolNCut, EcolQ, betaEcol] = computeMetricsLapl(WEcol, labelEcol, betas);
%% OpenML datasets evaluation
% Glass dataset kNN = 10, size = 214
[GlassAcc, GlassRatio, GlassNCut, GlassQ, betaGlass] = computeMetricsLapl(WGlas, labelGlas, betas);

% Mice dataset kNN = 10, size = 1077
[MiceAcc, MiceRatio, MiceNCut, MiceQ, betaMice] = computeMetricsLapl(WMice, labelMice, betas);

% Olivetti dataset kNN = 10, size = 400
[OlivAcc, OlivRatio, OlivNCut, OlivQ, betaOliv] = computeMetricsLapl(WOliv, labelOliv, betas);

% Umist dataset kNN = 10, size = 575
[UmisAcc, UmisRatio, UmisNCut, UmisQ, betaUmis] = computeMetricsLapl(WUmist, labelUmist, betas);

%% Power Grids Datasets Evaluation
load cases_powergrids.mat

warning off
% For reproducibility, set rng seed
rng('default');

[B494_Ratio, B494_NCut, B494_Q, beta_B494] = computeMetricsLaplPG(W_B494, betas, 4);

% Compound6 dataset kNN = 20
[B662_Ratio, B662_NCut, B662_Q, beta_B662] = computeMetricsLaplPG(W_B662, betas, 4);

% R15 dataset kNN = 40
[B1138_Ratio, B1138_NCut, B1138_Q, beta_B1138] = computeMetricsLaplPG(W_B1138, betas, 4);

%% Binary alpha digits dataset Evaluation
% Binaryalphadigs dataset kNN = 10, size = 1404
[BinaAcc, BinaRatio, BinaNCut, BinaQ, betaBina] = computeMetricsLapl(WBina, labelBina, betas);