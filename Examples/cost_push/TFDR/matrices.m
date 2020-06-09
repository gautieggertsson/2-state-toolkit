% Matrices
param.NY = numel(fieldnames(vars));
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);

% Output equation
AAA(eq.is,vars.x)       = 1;
AAA(eq.is,vars.pi)      = param.sigma;
BBB(eq.is,vars.x)       = 1;
BBB(eq.is,vars.i)       = param.sigma;
BBB(eq.is,vars.r)       = -param.sigma;

% Inflation equation
AAA(eq.pc,vars.pi)      = param.beta;
BBB(eq.pc,vars.x)       = -param.kappa;
BBB(eq.pc,vars.pi)      = 1;
BBB(eq.pc,vars.u_s)     = -1;

% Nominal interest rate
AAA(eq.i,vars.i_lag)    = 1;
BBB(eq.i,vars.i)        = 1;

% Natural-r constant
AAA(eq.r,vars.r)        = 1;
BBB(eq.r,vars.r)        = 1;

% Cost push shock
AAA(eq.cps,vars.u_s)     = 1;
BBB(eq.cps,vars.u_s)     = 1;

% Truncated Taylor rule (first difference)
BBB(eq.rule,vars.i)     = 1;
BBB(eq.rule,vars.x)     = -param.phi_x;
BBB(eq.rule,vars.pi)    = -param.phi_pi;
BBB(eq.rule,vars.i_lag) = -1;


