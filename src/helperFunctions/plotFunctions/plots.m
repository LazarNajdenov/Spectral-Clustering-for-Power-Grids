function plots(lambdas,eigengaps)
% PLOTS helper function that plots the eigenvalue and the eigengaps
% distribution
    figure;
    plot(1:10, lambdas, 'Marker', 'o', 'MarkerFaceColor', [0 .6 0], 'MarkerSize', 8 )
    xlabel('Number');
    ylabel('Eigenvalue');
    title('Eigenvalues distribution')
    
    set(gca,'fontsize',15);
    % Plot eigengaps distributions     
    figure;
    plot(eigengaps, 'LineWidth',2,'Color', [0 .6 0]);
    xlabel('Eigenvalue');
    ylabel('Relative Eigengap');
    title('Eigengaps distribution')
    set(gca,'fontsize',15);
end

