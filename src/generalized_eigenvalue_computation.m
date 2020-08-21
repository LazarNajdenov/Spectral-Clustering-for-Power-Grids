function [Xsol, Dsol] = generalized_eigenvalue_computation(A, B, p)
    fprintf('#######################################\n')
    fprintf('# General. eigenvalue Grassman comput.#\n')
    if ~exist('A', 'var') || isempty(A)
        n = 128;
        A = randn(n);
        A = (A+A')/2;
    end
    if ~exist('B', 'var') || isempty(B)
        n = size(A, 1);
        e = ones(n, 1);
        B = spdiags([-e 2*e -e], -1:1, n, n); % Symmetric positive definite
    end

    if ~exist('p', 'var') || isempty(p)
        p = 3;
    end

    % Make sure the input matrix is square and symmetric
    n = size(A, 1);
    assert(isreal(A), 'A must be real.')
    assert(size(A, 2) == n, 'A must be square.');
    assert(norm(A-A', 'fro') < n*eps, 'A must be symmetric.');
    assert(p <= n, 'p must be smaller than n.');

    % Define the cost and its derivatives on the generalized
    % Grassmann manifold, i.e., the column space of all X such that
    % X'*B*X is identity.
    gGr = grassmanngeneralizedfactory(n, p, B);

    problem.M = gGr;
    problem.cost  = @(X) Manopt_Functional(X, A, p);
    problem.egrad = @(X) 2 * ( A * X); % Only Euclidean gradient needed.

    % Execute some checks on the derivatives for early debugging.
    % These things can be commented out of course.
    % checkgradient(problem);

    % Issue a call to a solver. A random initial guess will be chosen and
    % default options are selected except for the ones we specify here.
    options.maxiter     = 5000;
    options.minstepsize = 1e-10;
    options.tolgradnorm = 1e-6;
    options.verbosity = 0;
    options.linesearch = @linesearch;
    [Xsol, ~, ~] = conjugategradient(problem, [], options);

    % To extract the eigenvalues, solve the small p-by-p symmetric
    % eigenvalue problem.
    [Vsol, Dsol] = eig(Xsol' * ( A * Xsol));

    % To extract the eigenvectors, rotate Xsol by the p-by-p orthogonal
    % matrix Vsol.
    Xsol = Xsol * Vsol;

    % This quantity should be small.
    % norm(A*Xsol - B*Xsol*diag(Ssol));
end

