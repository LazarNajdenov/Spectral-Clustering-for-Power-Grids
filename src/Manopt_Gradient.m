function [out, V] = Manopt_Gradient(V,W)

N = size(V,1);
K = size(V,2);
gradient = zeros(N,K);



% loop over k
for k = 1:K
    x = V(:,k);
    gradient(:, k) = W * x;
    % call Functional as per B&H
%     objective     = Manopt_Functional(x,W);
%     if(k~=1)
%         gradient(:,k) = Gradient(x,W,p,false,0,objective);
%     end
end

% if(constraint_first)
%     gradient(:,1) = V  * gradient' * V(:,1);
% end

out = gradient;

end