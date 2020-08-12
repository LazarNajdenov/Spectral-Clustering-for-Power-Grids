function [f] = mycost(V, L)

%     N = size(L ,1);
    K = size(V, 2);
%     X = rand(N, K);
    
    for k = 1: K
        x = V(:, k);
%         if ~isfield(store, 'Lx')
%             store.Lx = L * x;       % The store memory is associated to a specific x
%         end
%     
%         Lx = store.Lx;

        f(:, k) = - 0.5 * x'* L * x;               % No need to cache f: cost values are cached 'under the hood'
    end
    
    
end

