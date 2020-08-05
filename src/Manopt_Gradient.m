function [out, V] = Manopt_Gradient(V,W,p,constraint_first)

N = size(V,1);
K = size(V,2);
gradient = zeros(N,K);



% loop over k
for k = 1:K
    x = V(:,k);
    % call Functional as per B&H
    objective     = Manopt_Functional(x,W,p);
    if(k~=1 || ~constraint_first)
        gradient(:,k) = Gradient(x,W,p,false,0,objective);
    end
end

if(constraint_first)
    gradient(:,1) = V  * gradient' * V(:,1);
end

out = gradient;

end