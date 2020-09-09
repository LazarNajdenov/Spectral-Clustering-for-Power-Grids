function [paramsGraph] =  Initialize_problem_PG(mpc)
% Initialize a problem from the Sparse Matrix Florida Collection
% Input
% SM_case: the sparse matrix case
% Output
% paramsGraph: struct with the following entries
%       imbal_ratio
%       AdjTOP
%       AdjAPF
%       AdjADM
%       Inc
%       numberOfEdges
%       numberOfVertices
%       xadj
%       adjncy
%       coords
% pasadd@usi.ch

% coords         = mpc.buslocation;

% Retrieve edges list
paramsGraph.EdgeList       = mpc.branch(:, 1:2);

% Retrieve nodes list 
paramsGraph.NodeList       = mpc.bus(:, 1);

% Retrieve Pf and Pt from case
paramsGraph.PfAndPt        = mpc.branch(:, [14 16]);

% numberOfPoints = size(coords, 1);
paramsGraph.numberOfEdges  = size(paramsGraph.EdgeList, 1);

Indices          = mpc.bus(:,1); 
nb               = max(Indices);
I                = zeros(nb,1);
I(Indices)       = 1:length(Indices);

% create Incidence matrix

n                  = length(Indices);
paramsGraph.Inc    = sparse(paramsGraph.numberOfEdges, n);


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

% Adjacency using topology
paramsGraph.AdjTOP = - paramsGraph.Adj;

% Adjacency using average power flow
paramsGraph.AdjAPF = sparse(zeros(size(L)));

for k = 1: paramsGraph.numberOfEdges
    e1 = paramsGraph.EdgeList(k, 1);
    e2 = paramsGraph.EdgeList(k, 2);
    Pf = paramsGraph.PfAndPt(k, 1);
    Pt = paramsGraph.PfAndPt(k, 2);
    result = (abs(Pf) + abs(Pt)) / 2;
    paramsGraph.AdjAPF(e1, e2) = result;
    paramsGraph.AdjAPF(e2, e1) = result;
end

% TODO: Adjacency using admittance

% % % % % % % 

% Acceptable imbalance ratio between partitions
paramsGraph.imbal_ratio = 10;
% Incidence
paramsGraph.Inc    = adjacency_to_incidence(paramsGraph.AdjTOP);
% Vertices
paramsGraph.numberOfVertices = size(paramsGraph.Inc,2);


% [i,j,~] = find(paramsGraph.AdjTOP);
% idx = find(i==j);
% i(idx) = [];
% j(idx) = [];
% if isempty(j)
%     paramsGraph.xadj = [];
% else
%     paramsGraph.xadj = [1;cumsum(accumarray(j, 1))+1];
% end
% paramsGraph.adjncy = i;

% % coords (if exist)
% if isfield(mpc, 'Problem') && isfield(mpc.Problem, 'aux') && ...
%    isfield(mpc.Problem.aux, 'coord')
%    paramsGraph.coords = mpc.Problem.aux.coord;
% end
    
    
end