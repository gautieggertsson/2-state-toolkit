% Matrices
param.NY = numel(fieldnames(vars));
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);

% Output equation
AAA(eq.is,vars.x)          = 1;
AAA(eq.is,vars.pi)         = param.sigma;
AAA(eq.is,vars.r)          = param.sigma;
BBB(eq.is,vars.x)          = 1;
BBB(eq.is,vars.i)          = param.sigma;

% Inflation equation
AAA(eq.pc,vars.pi)         = param.beta;
BBB(eq.pc,vars.pi)         = 1;
BBB(eq.pc,vars.x)          = -param.kappa;

% Natural-r target
AAA(eq.rstar,vars.rstar)   = 1;
BBB(eq.rstar,vars.rstar)   = 1;

% Exogenous shock
AAA(eq.exo,vars.exo)       = 1;
BBB(eq.exo,vars.exo)       = 1;

% Natural-r AR(1)
AAA(eq.r,vars.r)           = 1;
BBB(eq.r,vars.r)           = param.rho;
BBB(eq.r,vars.rstar)       = 1-param.rho;
BBB(eq.r,vars.exo)         = 1;

% Past interest rate
AAA(eq.i_lag,vars.i_lag)   = 1;
BBB(eq.i_lag,vars.i)       = 1;

% Past output gap
AAA(eq.x_lag,vars.x_lag)   = 1;
BBB(eq.x_lag,vars.x)       = 1;

% Past inflation
AAA(eq.pi_lag,vars.pi_lag) = 1;
BBB(eq.pi_lag,vars.pi)     = 1;

% Truncated Taylor rule (past inflation and output, smoothed)
BBB(eq.rule,vars.i)        = -1;
BBB(eq.rule,vars.rstar)    = 1-param.phi_i;
BBB(eq.rule,vars.pi_lag)   = (1-param.phi_i)*param.phi_pi;
BBB(eq.rule,vars.i_lag)    = param.phi_i;
BBB(eq.rule,vars.x_lag)    = (1-param.phi_i)*param.phi_x; 

% Implied Taylor rule  
BBB(eq.i_imp,vars.i_imp)   = -1;
BBB(eq.i_imp,vars.rstar)   = 1-param.phi_i;
BBB(eq.i_imp,vars.pi_lag)  = (1-param.phi_i)*param.phi_pi;
BBB(eq.i_imp,vars.i_lag)   = param.phi_i;
BBB(eq.i_imp,vars.x_lag)   = (1-param.phi_i)*param.phi_x; 
