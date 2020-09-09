function [Inc] = adjacency_to_incidence(Adj)

A   = Adj;
% Sanitize: fit zeros on the diagonal
for i = 1:size(A,1)    
    A(i,i) = 0;    
end

Inc = adj_2_inc(A);

% Inc = Inc';
end

function Ic = adj_2_inc(A)

% adjacency2incidence - convert an adjacency matrix to an incidence matrix
%
%   Ic = adjacency2incidence(A);
%
%   A(i,j) = 1 iff (i,j) is an edge of the graph.
%   For each edge number k of the graph linking (i,j)
%       Ic(i,k)=1 and Ic(j,k)=-1 
%
%   Ic is a sparse matrix.
%   Ic is also known as the graph gradient.


%% compute list of edges
[i,j,p] = find(sparse(A));
I = find(i<=j);
i = i(I);
j = j(I);
% p = p(I);
% number of edges
nedges = length(i);
% number of vertices
nverts = size(A,1);

%% build sparse matrix
s  = [ones(nedges,1); -ones(nedges,1)];
% tau = [p;-p];
is = [(1:nedges)'; (1:nedges)'];
js = [i(:); j(:)];
Ic = sparse(is,js,s,nedges,nverts);
% Ic = sparse(is,js,tau,nedges,nverts);


% fix self-linking problem (0)
a = find(i==j);
if not(isempty(a))
    for t=a'
        Ic(i(t),t) = 1;
    end
end

end