% Matrices
param.NY = numel(fieldnames(vars));
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);

% Output equation
AAA(eq.is,vars.x)        = 1;
AAA(eq.is,vars.pi)       = param.sigma;
BBB(eq.is,vars.x)        = 1;
BBB(eq.is,vars.i)        = param.sigma;
BBB(eq.is,vars.r)        = -param.sigma;

% Inflation equation
AAA(eq.pc,vars.pi)       = param.beta;
BBB(eq.pc,vars.pi)       = 1;
BBB(eq.pc,vars.x)        = -param.kappa;
BBB(eq.pc,vars.u_s)      = -1;

% i_tr equation
BBB(eq.i_tr,vars.i_tr)   = -1;
BBB(eq.i_tr,vars.rstar)  = 1;
BBB(eq.i_tr,vars.pi)     = param.phi_pi;
BBB(eq.i_tr,vars.x)      = param.phi_x;

% Z equation
AAA(eq.z,vars.z)         = 1;
BBB(eq.z,vars.z)         = 1;
BBB(eq.z,vars.i_tr)      = -1;
BBB(eq.z,vars.i)         = 1;

% Natural-r target
AAA(eq.rstar,vars.rstar) = 1;
BBB(eq.rstar,vars.rstar) = 1;

% Natural-r constant
AAA(eq.r,vars.r)         = 1;
BBB(eq.r,vars.r)         = 1;

% instrument rule
BBB(eq.rule,vars.i)      = -1;
BBB(eq.rule,vars.i_tr)   = 1;
AAA(eq.rule,vars.z)      = param.alpha;

% Cost push shock
AAA(eq.cps,vars.u_s)     = 1;
BBB(eq.cps,vars.u_s)     = 1;