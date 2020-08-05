function [objective] = Manopt_Functional(V,W,p)

N = size(V ,1);
K = size(V ,2);
objective = 0;
functional_array = zeros(K,1);

% loop oVer k
for k = 1:K
    x = V(:,k);
    % call Functional as per B&H
    temp = Functional(x,W,p,false,0);
    objective = objective + temp;
    functional_array(k) = temp;
end


end