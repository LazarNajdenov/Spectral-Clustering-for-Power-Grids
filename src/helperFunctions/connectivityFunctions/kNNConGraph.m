function [G] = kNNConGraph(Pts,kNN)    
% Construct a k-nearest neighbors connectivity graph
% Input
% k      : # of neighbors
% Pts    : coordinate list of the sample 
% 
% Output
% G      : the kNN similarity matrix

f = waitbar(0,'1','Name','kNN graph - maxima enim, patientia virtus',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

n  = length(Pts(:,1));
G = zeros(n);
fprintf('kNN similarity graph\n');
    for i = 1:n
        
        % Repeat the i-th point n-row-times         
        s = repmat(Pts(i,:),n,1);
        d = Pts - s;
        % e = diag(d*d');
        
        % Compute the distance between the i-th point and the others        
        e = sum(d.^2,2);
        
        % Sort the distances and for each distance there is the
        % corresponding index
        [~,ind] = sort(e);
        
        
        % Remove the ith-point for which we are searching the kNN         
        [index_remove] = find(ind == i);
        ind(index_remove) = [];
        
        
        % Take the first kNN of the i-th point
        nbrs = ind(1:kNN);
        % Assign the kNN of the i-th point based on the indices
        % reciprocally
        G(i,nbrs) = 1;
        G(nbrs,i) = 1;
        
        waitbar(i/n,f,sprintf('%5.2f',100*i/n))
    end
    
    delete(f)
end