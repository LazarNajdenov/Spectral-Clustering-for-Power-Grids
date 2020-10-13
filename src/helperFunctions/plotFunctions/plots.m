function plots(lambdas,releigengaps, eigengaps)
% PLOTS helper function that plots the eigenvalue and the eigengaps
% distribution
    figure;
    plot(1:10, lambdas, 'Marker', 'o', 'MarkerFaceColor', [0 .6 0], 'MarkerSize', 8 )
    xlabel('Number');
    ylabel('Eigenvalue');
    title('Eigenvalues distribution')
    
    set(gca,'fontsize', 20);
    % Plot eigengaps distributions     
    figure;
    plot(releigengaps, 'LineWidth',4,'Color', 'cyan','Marker','o',...
    'MarkerFaceColor','cyan','MarkerSize',8);
    xlabel('Eigenvalue');
    ylabel('Relative Eigengap');
    title('Relative Eigengaps distribution')
    set(gca,'fontsize',23);
    
    figure;
    plot(eigengaps, 'LineWidth',4,'Color', 'cyan', 'Marker','o',...
    'MarkerFaceColor','cyan','MarkerSize',8);
    xlabel('Eigenvalue');
    ylabel('Eigengap');
    title('Eigengaps distribution')
    set(gca,'fontsize',23);
end

