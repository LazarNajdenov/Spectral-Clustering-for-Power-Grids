function [Xsol, costXsol, Dsol] = Manopt_Grassmann(L, k)

    fprintf('Manopt Grassman computation\n');
    % k = size(X,2);
    n = size(L,1);
    Gr = grassmannfactory(n, k);

    problem.M = Gr;
    % constraint_first = false;

    % Cost function evaluation
    % problem.cost =  @(V) Manopt_Functional(V,W);
    % problem.cost = @(V) mycost(V, L);
    % problem.cost =  @(V) 0.5 * (V' * W * V);
    problem.cost = @(V) trace(V' * L * V);


    % Euclidean gradient evaluation
    % problem.egrad = @(V) Manopt_Gradient(V,W);
    % problem.egrad = @(V) mygrad(V, L);
    % problem.egrad = @(V) W * V;
    problem.egrad = @(V) 2 * (L * V);

    % problem.ehess = @(X,eta) ROPTLib_Hessian(X,eta,W,p);

    % Check whether gradient and Hessian computations are correct.
    % checkgradient(problem);
    % pause;

    options.maxiter     = 5000;
    options.minstepsize = 1e-10;
    options.tolgradnorm = 1e-6;
    options.verbosity = 0;
    options.linesearch = @linesearch;

    %options.statsfun = @(problem,x,stats) Second_P_Eigenvalue(x,W,p);
    %% CG Manopt
    %    options.beta_type = 'H-Z';
    [out, costXsol, ~] = conjugategradient(problem, [], options);   
    Xsol= out;

    % To extract the eigenvalues, solve the small p-by-p symmetric
    % eigenvalue problem.
    [Vsol, Dsol] = eig(Xsol' * (L * Xsol));
    % Ssol = diag(Dsol);

    % To extract the eigenvectors, rotate Xsol by the p-by-p orthogonal
    % matrix Vsol.
    Xsol = Xsol * Vsol;
    %% Trust Region Manopt   

    % Xsol = trustregions(problem, X, options);

    %% LBFGS Manopt
    % Xsol = rlbfgs(problem, X,options);

    %% SD Manopt
    % Xsol = steepestdescent(problem, X);

    %% BB descent

    % Xsol = barzilaiborwein(problem, X, options);

    %% Steepestdescent

    % Xsol = steepestdescent(problem, X, options);

end
