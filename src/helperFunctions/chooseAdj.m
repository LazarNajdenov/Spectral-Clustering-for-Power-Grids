function [W, adjType] = chooseAdj(adj, paramGraphs)
% CHOOSEADJ function that depending on the input given generates an
% adjacency matrix which can be based on:
% - topology
% - admittance
% - average power flow
% and return the given adjacency.
    if adj == 1
        W = paramGraphs.AdjTOP;
        adjType = 'topology';
    elseif adj == 2
        % TODO:
        % W = paramGraphs.AdjADM;
        adjType = 'admittance';
        fprintf('TODO\n');
    else
        W = paramGraphs.AdjAPF;
        maxValue = max(max(W));
        W = W/maxValue;
        adjType = 'average power flow';
    end
end

