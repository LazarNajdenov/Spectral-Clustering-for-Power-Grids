function [paramsGraph] =  Initialize_problem_PG(fileName)
% Initialize a problem from the Sparse Matrix Florida Collection
% Input
% SM_case: the sparse matrix case
% Output
% paramsGraph: struct with the following entries
%       imbal_ratio
%       AdjTOP
%       AdjADM
%       AdjAPF
%       Inc
%       numberOfEdges
%       numberOfVertices
%       xadj
%       adjncy
%       coords
% pasadd@usi.ch

% coords         = mpc.buslocation;

% Load file
mpc = loadcase(fileName);

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

% Compute adjacency using topology
paramsGraph.AdjTOP = - paramsGraph.Adj;

% Compute adjacency using average power flow
paramsGraph.AdjAPF = sparse(zeros(size(L)));

% Compute averages of power flows
results = zeros(paramsGraph.numberOfEdges,1);
for k = 1: paramsGraph.numberOfEdges
    Pf = paramsGraph.PfAndPt(k, 1);
    Pt = paramsGraph.PfAndPt(k, 2);
    results(k) = (abs(Pf) + abs(Pt)) / 2;
end

% Take out the minimum of the power flows and divide it by 2 
m = (min(results(results > 0))) / 2;

for k = 1: paramsGraph.numberOfEdges
    % Take out indices     
    e1 = paramsGraph.EdgeList(k, 1);
    e2 = paramsGraph.EdgeList(k, 2);

    % If the average power flow is 0, put the machine error in order to not
    % influence the final result     
    if results(k) == 0
        paramsGraph.AdjAPF(e1, e2) = m;
        paramsGraph.AdjAPF(e2, e1) = m;
    else 
        paramsGraph.AdjAPF(e1, e2) = results(k);
        paramsGraph.AdjAPF(e2, e1) = results(k);
    end
    
end

% TODO: Adjacency using admittance

% % % % % % % 

% Acceptable imbalance ratio between partitions
paramsGraph.imbal_ratio = 10;
% Incidence
paramsGraph.Inc         = adjacency_to_incidence(paramsGraph.AdjTOP);
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