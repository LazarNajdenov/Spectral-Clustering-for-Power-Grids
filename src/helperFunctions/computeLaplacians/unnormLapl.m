function [L] = unnormLapl(W)
%UNNORMLAPL Compute unnormalized Laplacian and K smallest eigenvectors

    fprintf('# Unnormalized Laplacian #\n');
    % Degree matrix
    Diag = zeros(size(W,1));
    for i = 1:size(W,1)
       Diag(i,i) = sum(W(:,i)); 
    end
    
    % Construct the unnormalized Laplacian
    L = Diag - W;
%     L_2 = L/ norm(full(L));
%     [V,lambda] = eigs(L, K, 'SM'); 
    
end

