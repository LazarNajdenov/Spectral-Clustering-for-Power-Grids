function [V, lambda] = symmLapl(W,K)
%SYMMLAPL Compute normalized symmetric Laplacian and K smallest eigenvectors
    fprintf('--------------------------------\n');
    fprintf('Normalized symmetric Laplacian\n');
    fprintf('--------------------------------\n');
    % Degree matrix
    Diag = zeros(size(W,1));
    for i = 1:size(W,1)
       Diag(i,i) = sum(W(:,i)); 
    end
    
    % Construct the unnormalized Laplacian
    L = Diag - W;
    
    % Construct Symmetric normalized Laplacian     
    d        = diag(1./sqrt(Diag));
    DiagHalf = Diag + diag(d - diag(Diag));
    L_sym    = DiagHalf * L * DiagHalf;
    L_sym    = (L_sym + L_sym')./2;
    [V,lambda]    = eigs(L_sym, K, 'SM');
end

