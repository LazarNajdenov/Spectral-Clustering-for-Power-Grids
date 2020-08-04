function [x_inferred, inferred_label] = label_data(x,labels)
% Input:
%       x: clustering result
%       labels: true labelling
% Output
%       x_inferred: the interpreted solution according to the labels 
% 


% determine # of clusters
if min(x) == 0
    K = max(x)+1;
else
    K = max(x);
end

% Set to -1 the vector of the inferred_label
inferred_label = -1*ones(K,1);

% Set at the beginning the interpreted solutions according to the
% clustering result
x_inferred     = x;

for k=1:K
    % Find the indices of all values of the clustering results 
    % that are equal to k    
    index             = find(x==k);
    % Take out from the real label, the labels at the given indices    
    cur_labels        = labels(index);
    % Compute the mode of the labels taken out, and the most frequent label 
    % will be the actual one    
    actual_label      = mode(cur_labels);
    % Assign at position k of the inferred_label the actual one computed     
    inferred_label(k) = actual_label;
    % Set at the indices of the interpeted solution the actual label     
    x_inferred(index) = actual_label;
end


end