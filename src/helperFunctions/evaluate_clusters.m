function [Confusion, ACC, RCut, NCut, Q] = evaluate_clusters(labels,clusters,W,...
                                printflag, SimComputed)
    if SimComputed == 0                        
        [inferred_labels, ~] = label_data(clusters, labels);
        n = length(labels);

        % CREATE CONFUSION MATRIX
        [Confusion] = confusionmat(labels,inferred_labels);

        % CALCULATE ERRORS
        diff = (labels - inferred_labels);
        hits = length(find(diff==0));
        ACC  = hits/n;
    
    end

    %  Compute Ratio Cut, Normalized Cut, and Modularity
    [RCut, NCut] = computeRCutValue(clusters,W);
    [Q] = QFModul(clusters, W);
    
    if printflag==1
        if SimComputed == 0
            fprintf('---------------------\n');
            fprintf('Confusion Matrix\n'); 
            fmt = [repmat('%4d ', 1, size(Confusion,2)-1), '%4d\n'];
            fprintf(fmt, Confusion.');
            fprintf('---------------------\n');
            fprintf('ACC = %f, RCut = %f, NCut = %f, MOD = %f\n', ACC, RCut, NCut, Q);
        else
            fprintf('# RCut = %f, NCut = %f, MOD = %f #\n', RCut, NCut, Q);
        end
    end

end
