function [objective] = Manopt_Functional(V,W,K)

objective = 0;
functional_array = zeros(K,1);

% loop oVer k
for k = 1:K
    x = V(:,k);
    % call Functional as per B&H
    temp = x' * W * x;
    objective = objective + temp;
    functional_array(k) = temp;
end


end