function [L_unorm, Diag] = randwalkLapl(W)
%RANDWALKLAPL Compute random-walk Laplacian and K smallest eigenvectors
    fprintf('# Random Walk Laplacian  #\n');
    % Degree matrix
    Diag = zeros(size(W,1));
    for i = 1:size(W,1)
       Diag(i,i) = sum(W(:,i)); 
    end
    
    % Construct Random-walk Laplacian     
    %     n      = size(W,1);
    %     I      = speye(n);
    %     P      = Diag \ W;
    %     L_rw   = I - P;
    % %     L_rw2 = L_rw / norm(full(L_rw));
    %     [V,lambda]  = eigs(L_rw2, Diag, K, 'SM');
    L_unorm = Diag - W;
%     [V,lambda] = eigs(L_unorm,Diag,K,'SM');
end

