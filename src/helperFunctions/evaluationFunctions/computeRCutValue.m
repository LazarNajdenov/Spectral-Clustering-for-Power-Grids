function [RCut, NCut] = computeRCutValue(clusters,W)
% Computes the components in the Ratio/Normalized Cut expression.
%
% Usage: [RCut] = computeCutValue(clusters,W,normalized)

    K     = max(clusters);
    RCut  = 0;
    NCut  = 0;

    for k = 1:K

        W2  = W(clusters==k,clusters~=k);
        cut = full(sum(sum(W2)));
        
        % RatioCut        
        cardinalityA = sum(clusters==k);
        cutpart      = cut/cardinalityA;
        RCut         = RCut  + cutpart;
        
        % NormalizedCut
        degreeA  = sum(W(:,clusters==k));
        volA     = sum(degreeA);
        ncutpart = cut/volA;
        NCut     = NCut  + ncutpart;
    end

end