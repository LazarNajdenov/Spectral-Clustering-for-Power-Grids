function [objective] = Manopt_Functional(V,W)

N = size(V ,1);
K = size(V ,2);
V = rand(N, K);
objective = 0;
functional_array = zeros(K,1);

% loop oVer k
for k = 1:K
    x = V(:,k);
    % call Functional as per B&H
    temp = 0.5 * x' * W * x;
    objective = objective + temp;
    functional_array(k) = temp;
end


end