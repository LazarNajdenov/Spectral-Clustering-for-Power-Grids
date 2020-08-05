function [Xsol] = Manopt_Stiefel(X,W,p)


k = size(X,2);
n = size(X,1);
St = stiefelfactory(n, k);
problem.M = St;
constraint_first = false;

% Cost function evaluation
problem.cost =  @(V) Manopt_Functional(V,W,p);


% Euclidean gradient evaluation
problem.egrad = @(V) Manopt_Gradient(V,W,p,constraint_first);

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
out = conjugategradient(problem, X.main, options);   
Xsol.main = out;
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
