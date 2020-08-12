function [g] = mygrad(V, L)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    K = size(V, 2);
    
    for k = 1: K
        x = V(:, k);
        
%         if ~isfield(store, 'Lx')
%             store.Lx = L * x;       % The store memory is associated to a specific x
%         end
%         
%         Lx = store.Lx;
        g(:, k) = - L * x;
    end
    
end

