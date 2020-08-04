% Script for selecting the best Laplacian matrix among the following three:
% 1) Unnormalized Laplacian
% 2) Normalized Symmetric Laplacian
% 3) Normalized Random-Walk Laplacian
% For one dataset with increasing size and for each Laplacian, it selects 
% the average accuracies after each run (each run means different dataset 
% size), and put them in a vector size 10, and for safe 
% comparison/reproducibility we fix a rng seed. Then plot with box plot. 
% We expect fewer outliers in the case of Random-Walk Laplacian

clc;
clear;
close all;

warning off
addpath ../
addpath ../../
addpath ../../generatedArtificialDatasets/
addpath ../../kNNMaxResults/
addpath ../../helperFunctions/
addpath ../../helperFunctions/wgPlot/
addpath ../../helperFunctions/plotFunctions/
addpath ../../helperFunctions/computeLaplacians/
addpath ../../helperFunctions/evaluationFunctions/
addpath ../../helperFunctions/similarityFunctions/
addpath ../../helperFunctions/connectivityFunctions/

betas = 1.1:0.1:1.9;
%% Artificial Datasets Evaluation
warning off
% For reproducibility, set rng seed
rng('default');

load artificialWandLabels.mat

% Aggregation7 dataset kNN = 40
[AggrAcc, AggrRatio, AggrNCut, AggrQ, betaAggr] = computeAccCutLapl(WAggr, lAggr, betas);
% Compound6 dataset kNN = 20
[CompAcc, CompRatio, CompNCut, CompQ, betaComp] = computeAccCutLapl(WComp, lComp, betas);
% Flame2 dataset kNN = 8
[FlamAcc, FlamRatio, FlamNCut, FlamQ, betaFlam] = computeAccCutLapl(WFlam, lFlam, betas);
% Jain2 dataset kNN = 20
[JainAcc, JainRatio, JainNCut, JainQ, betaJain] = computeAccCutLapl(WJain, lJain, betas);
% Pathbased3 dataset kNN = 20
[PathAcc, PathRatio, PathNCut, PathQ, betaPath] = computeAccCutLapl(WPath, lPath, betas);
% R15 dataset kNN = 40
[R15Acc, R15Ratio, R15NCut, R15Q, betaR15]      = computeAccCutLapl(WR15, lR15, betas);
% Spiral3 dataset kNN = 20
[SpirAcc, SpirRatio, SpirNCut, SpirQ, betaSpir] = computeAccCutLapl(WSpir, lSpir, betas);

%% OpenML Datasets Evaluation 
warning off
rng('default');

load openmlWandLabels.mat

% Normal Size Datasets

% Iris dataset kNN = 30, size = 150
[IrisAcc, IrisRatio, IrisNCut, IrisQ, betaIris]      = computeAccCutLapl(WIris, lIris, betas);

% Glass dataset kNN = 10, size = 214
[GlassAcc, GlassRatio, GlassNCut, GlassQ, betaGlass] = computeAccCutLapl(WGlas, lGlas, betas);

% Ecoli dataset kNN = 10, size = 336
[EcolAcc, EcolRatio, EcolNCut, EcolQ, betaEcol]      = computeAccCutLapl(WEcol, lEcol, betas);

% Olivetti dataset kNN = 10, size = 400
[OlivAcc, OlivRatio, OlivNCut, OlivQ, betaOliv]      = computeAccCutLapl(WOliv, lOliv, betas);

% Spectro dataset kNN = 10, size = 531
[SpectAcc, SpectRatio, SpectNCut, SpectQ, betaSpect] = computeAccCutLapl(WSpect, lSpect, betas);

% Umist dataset kNN = 10, size = 575
[UmisAcc, UmisRatio, UmisNCut, UmisQ, betaUmis]      = computeAccCutLapl(WUmis, lUmis, betas);

% Vehicle dataset kNN = 10, size = 846
[VehiAcc, VehiRatio, VehiNCut, VehiQ, betaVehi]      = computeAccCutLapl(WVehi, lVehi, betas);

% Mice dataset kNN = 10, size = 1077
[MiceAcc, MiceRatio, MiceNCut, MiceQ, betaMice]      = computeAccCutLapl(WMice, lMice, betas);

% Binaryalphadigs dataset kNN = 10, size = 1404
[BinaAcc, BinaRatio, BinaNCut, BinaQ, betaBina]      = computeAccCutLapl(WBina, lBina, betas);

% Yeast dataset kNN = 30, size = 1484
[YeasAcc, YeasRatio, YeasNCut, YeasQ, betaYeas]      = computeAccCutLapl(WYeas, lYeas, betas);

% Plants dataset kNN = 10, size = 1600
[PlantAcc, PlantRatio, PlantNCut, PlantQ, betaPlant] = computeAccCutLapl(WPlant, lPlant, betas);

% High Moon dataset kNN = ?, size = 2000

%% Big datasets
warning off
rng('default');

load openmlWandLabels.mat

% Fashion MNIST dataset kNN = 10, size = 10000
[FashAcc, FashRatio, FashNCut, FashQ, betaFash] = computeAccCutLapl(WFash, lFash, betas);

% Kmnist dataset kNN = 10, size = 10000
[KmniAcc, KmniRatio, KmniNCut, KmniQ, betaKmni] = computeAccCutLapl(WKmni, lKmni, betas);

% Mnist dataset kNN = 10, size = 10000
[MnisAcc, MnisRatio, MnisNCut, MnisQ, betaMnis] = computeAccCutLapl(WMnis, lMnis, betas);

% Pendigits dataset kNN = 20, size = 10992
[PendAcc, PendRatio, PendNCut, PendQ, betaPend] = computeAccCutLapl(WPend, lPend, betas);

% USPS BNH dataset kNN = 10, size = 11000
[UspsAcc, UspsRatio, UspsNCut, UspsQ, betaUsps] = computeAccCutLapl(WUsps, lUsps, betas);