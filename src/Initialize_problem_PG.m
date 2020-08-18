function [paramsGraph] =  Initialize_problem_PG(mpc)
% Initialize a problem from the Sparse Matrix Florida Collection
% Input
% SM_case: the sparse matrix case
% Output
% paramsGraph: struct with the following entries
%       imbal_ratio
%       Adj
%       Inc
%       numberOfEdges
%       numberOfVertices
%       xadj
%       adjncy
%       coords
% pasadd@usi.ch

% coords         = mpc.buslocation;
paramsGraph.EdgeList       = mpc.branch(:, 1:2);
% numberOfPoints = size(coords, 1);
paramsGraph.numberOfEdges  = size(paramsGraph.EdgeList, 1);

Indices          = mpc.bus(:,1);
nb               = max(Indices);
I                = zeros(nb,1);
I(Indices)       = 1:length(Indices);

% create Incidence matrix

n                  = length(Indices);
paramsGraph.Inc         = sparse(paramsGraph.numberOfEdges, n);

for e = 1:paramsGraph.numberOfEdges
    v_e               = paramsGraph.EdgeList(e, :);    
    v_e               = I(v_e);    
    paramsGraph.EdgeList(e, :) = v_e;
    paramsGraph.Inc(e, v_e(1))      = 1; %incidence
    paramsGraph.Inc(e, v_e(2))      = -1;
end

% create Adjacency matrix
A    = paramsGraph.Inc;
paramsGraph.numberOfVertices = size(A,2);
% Laplacian 
% TODO: check normalized laplacian here
paramsGraph.L    = A.' * A;
L = paramsGraph.L;
paramsGraph.Adj  = L;

for i = 1:size(L,1)
    paramsGraph.Adj(i,i) = 0;
end

% Adjacency
paramsGraph.Adj = - paramsGraph.Adj;

% % % % % % % 

% Acceptable imbalance ratio between partitions
paramsGraph.imbal_ratio = 10;
% Incidence
paramsGraph.Inc    = adjacency_to_incidence(paramsGraph.Adj);
% Vertices
paramsGraph.numberOfVertices = size(paramsGraph.Inc,2);


[i,j,~] = find(paramsGraph.Adj);
idx = find(i==j);
i(idx) = [];
j(idx) = [];
if isempty(j)
    paramsGraph.xadj = [];
else
    paramsGraph.xadj = [1;cumsum(accumarray(j, 1))+1];
end
paramsGraph.adjncy = i;

% % coords (if exist)
% if isfield(mpc, 'Problem') && isfield(mpc.Problem, 'aux') && ...
%    isfield(mpc.Problem.aux, 'coord')
%    paramsGraph.coords = mpc.Problem.aux.coord;
% end
    
    
end