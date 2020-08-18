% Graph Power Grid Partitioning Benchmark
%% ADD PATHS
IncludePaths;

% TODO: only 1 params file?
clear all;close all;
% Initialize generic params
[paramsGeneric]   = InitializeParamsGeneric();
% fix random seed
load sprev.mat;
rng(sprev);

s = warning('query', 'MATLAB:nearlySingularMatrix');
warning('off', 'MATLAB:nearlySingularMatrix');
diary('roach64_debug.txt');

cases = {
% 'case5';'case14';'case6ww';'case9';'case9Q';'case33bw';'case_ieee30';
% 'case57';'case30';'case30pwl';'case30Q';'case24_ieee_rts';'case39';
% 'case118';'case89pegase';'case_RTS_GMLC';'case300';'case_ACTIVSg200';
% 'case_ACTIVSg500';'case1354pegase';'case1888rte';'case1951rte';'case2383wp';
% 'case2848rte';'case2868rte';'case_ACTIVSg2000';'case2869pegase';'case2737sop';
% 'case2736sp';'case2746wop';'case2746wp';'case3012wp';'case3120sp';
% 'case3375wp';'case6468rte';'case6470rte';'case6495rte';'case6515rte';
% 'case9241pegase';'case13659pegase';'case_ACTIVSg10k';

'case6495rte'
% 'case1354pegase';
};

rho = '1e-2';
fprintf('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n');
fprintf('|                                                    |\n');
fprintf('|        p-Laplacian Graph Partition Refinement      |\n');
fprintf('|                Power Grids Setup                   |\n');
fprintf('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n\n\n');
fprintf('Generic Parameters\n');
fprintf('+++++++++++++++++++++++++\n');
fprintf('Initial Cut by: %8s\n',paramsGeneric.Predictor);
fprintf('Solver        : %8s\n',paramsGeneric.Solver);
fprintf('Objective     : %8s\n',paramsGeneric.Cut_choice);
fprintf('rho           : %8s\n',rho);
fprintf('Video         : %8d\n',paramsGeneric.Video);
fprintf('Verbosity     : %8d\n',paramsGeneric.Verbose);
fprintf('+++++++++++++++++++++++++\n\n\n\n');


nc = length(cases);
maxlen = 0;
for c = 1:nc
    if length(cases{c}) > maxlen
        maxlen = length(cases{c});
    end
end

num_cases = 0;

for c = 1:nc
    fprintf('.');
%     mpc(c) = loadcase(cases{c});
    num_cases = num_cases + 1;
end

fprintf('\n\n Report Cases - %4d %12s %9s\n',num_cases,'Nodes','Edges');
fprintf('------------------------------------------------------\n');
for c = 1:nc
    mpc = loadcase(cases{c});
    spacers = repmat('.', 1, maxlen+3-length(cases{c}));
    [params] = Initialize_problem_PG(mpc);
    fprintf('%s %s %10d %10d\n', cases{c}, spacers,params.numberOfVertices,params.numberOfEdges);
end
fprintf('------------------------------------------------------\n\n');


fprintf('===============================================================================================================================\n');
if strcmp(paramsGeneric.Predictor,'METIS')
    fprintf('%7s   %30s %18s  %44s\n','Results','METIS','+','p-LAP(M)');
    fprintf('===============================================================================================================================\n');
    fprintf('%25s %10s %7s %7s %7s %6s %9s %6s %12s %6s %11s %8s\n','iters','Edgecut','RCcut','imbal','secs','p','Edgecut','%','RCcut','%','imbal','secs');
    fprintf(  '-------%s  -------  ------  -------- -----     --- --------   --------   -------   -----  ---------   -------    \n', repmat(' ', 1, maxlen+5-length('Results')));
elseif strcmp(paramsGeneric.Predictor,'SPECTRAL')
    fprintf('%7s   %30s %18s  %44s\n','Results','SPECTRAL','+','p-LAP(S)');
    fprintf('===============================================================================================================================\n');
    fprintf('%25s %10s %7s %7s %7s %6s %9s %6s %12s %6s %11s %8s\n','iters','Edgecut','RCcut','imbal','secs','p','Edgecut','%','RCcut','%','imbal','secs');
    fprintf(  '-------%s  -------  ------  -------- -----     --- --------   --------   -------   -----  ---------   -------    \n', repmat(' ', 1, maxlen+5-length('Results')));
elseif strcmp(paramsGeneric.Predictor,'RANDOM')
    fprintf('%7s   %30s %18s  %44s\n','Results','RANDOM','+','p-LAP(R)');
    fprintf('===============================================================================================================================\n');
    fprintf('%25s %10s %7s %7s %7s %6s %9s %6s %12s %6s %11s %8s\n','iters','Edgecut','RCcut','imbal','secs','p','Edgecut','%','RCcut','%','imbal','secs');
    fprintf('-------------------------------------------------------------------------------------------------------------------------------\n');
end


for c = 1:nc
    spacers = repmat('.', 1, maxlen+3-length(cases{c}));
    fprintf('%s %s', cases{c}, spacers);
    sparse_matrix = loadcase(cases{c});
    
    % Initialize the Graph problem
    [paramsGraph] = Initialize_problem_PG(sparse_matrix);
    
    % Take predictors cut
    [paramsMetis,paramsSpectral,paramsRandom] = predictors_Metis_spectral(paramsGraph,paramsGeneric);
    
    if strcmp(paramsGeneric.Predictor,'METIS')
        [paramsPlap,p_levels,report_solver,paramsSolver,Report] = kernel_pLaplacian(paramsGraph,paramsMetis,paramsGeneric);        
        % IMPROVEMENTS
        [EcutMetisImprove, RCcutMetisImprove] = compute_improvements(paramsMetis,paramsPlap);        
        iters = sum(report_solver.iter_count);
        fprintf('%8d %10d   %5.3f   %5.1f   %5.3f', iters, paramsMetis.edge_cut, ...
            paramsMetis.RCcut,paramsMetis.imbal,paramsMetis.tMetis);
        fprintf('%9.2f   %5d   %7.3f   %8.3f   %6.2f   %4.1f   %8.3f\n',paramsPlap.p,...
            paramsPlap.edge_cut,EcutMetisImprove, ...
            paramsPlap.RCcut,RCcutMetisImprove,paramsPlap.imbal,paramsPlap.tPlap);
    elseif strcmp(paramsGeneric.Predictor,'SPECTRAL')
        paramsGeneric.Solver = 'FISTA';paramsGeneric.Cut_choice = 'RCCut';
        paramsGeneric.regularization = 0;
        [paramsPlap,p_levels,report_solver,paramsSolver,Report] = kernel_pLaplacian(paramsGraph,paramsSpectral,paramsGeneric);
        iters = sum(report_solver.iter_count);
        % IMPROVEMENTS
        [EcutSpectralImprove, RCcutSpectralImprove] = compute_improvements(paramsSpectral,paramsPlap);
        fprintf('%8d %10d   %5.3f   %5.1f   %5.3f',iters,paramsSpectral.edge_cut, ...
            paramsSpectral.RCcut,paramsSpectral.imbal,paramsSpectral.tSpec);
        fprintf('%9.2f   %5d   %7.3f   %8.3f   %6.2f   %4.1f   %8.3f\n',paramsPlap.p,...
            paramsPlap.edge_cut,EcutSpectralImprove, ...
            paramsPlap.RCcut,RCcutSpectralImprove,paramsPlap.imbal,paramsPlap.tPlap);
    elseif strcmp(paramsGeneric.Predictor,'RANDOM')
        [paramsPlap,p_levels,report_solver,paramsSolver,Report] = kernel_pLaplacian(paramsGraph,paramsRandom,paramsGeneric);
        % IMPROVEMENTS
        [EcutRandomImprove, RCcutRandomImprove] = compute_improvements(paramsRandom,paramsPlap);
        iters = sum(report_solver.iter_count);
        fprintf('%8d %10d   %5.3f   %5.1f   %5.3f', iters,paramsRandom.edge_cut, ...
            paramsRandom.RCcut,paramsRandom.imbal,paramsRandom.tRand);
        fprintf('%9.2f   %5d   %7.3f   %8.3f   %6.2f   %4.1f   %8.3f\n',paramsPlap.p,...
            paramsPlap.edge_cut,EcutRandomImprove, ...
            paramsPlap.RCcut,RCcutRandomImprove,paramsPlap.imbal,paramsPlap.tPlap);
    end
    
end
















