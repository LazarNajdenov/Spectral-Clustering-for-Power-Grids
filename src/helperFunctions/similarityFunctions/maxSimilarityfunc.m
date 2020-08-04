function [S] = maxSimilarityfunc(Pts,kNN)
% Create the similarity matrix S 

n = length(Pts(:,1));

% kNN = max(10,2*ceil(log(n)));
% K = .5*ceil(log(n));

Sigma = zeros(n,1);

fprintf('--------------------------------\n');
fprintf('Max Gaussian similarity function\n');
fprintf('--------------------------------\n');
S = squareform(pdist(Pts));

for i = 1:n
     [~,index] = sort(S(:,i));
     Sigma(i) = S(index(kNN),i);
end
Sigma_mat = repmat(Sigma,1,n);
Sigma_mat = max(Sigma_mat, Sigma_mat');
S = exp(-4*S.^2 ./ (2*Sigma_mat.^2));

end