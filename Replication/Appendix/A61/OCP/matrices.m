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

% FOC output gap
AAA(eq.foc_x,vars.phi1)  = -1;
AAA(eq.foc_x,vars.phi2)  = param.kappa;
BBB(eq.foc_x,vars.x)     = param.lagr_x;
BBB(eq.foc_x,vars.phi1)  = -param.beta^(-1);

% FOC inflation
AAA(eq.foc_pi,vars.phi2) = -1;
BBB(eq.foc_pi,vars.phi1) = -param.beta^(-1)*param.sigma;
BBB(eq.foc_pi,vars.phi2) = -1;
BBB(eq.foc_pi,vars.pi)   = 1;

% Natural-r constant
AAA(eq.r,vars.r)         = 1;
BBB(eq.r,vars.r)         = 1;

% Cost push shock
AAA(eq.cps,vars.u_s)     = 1;
BBB(eq.cps,vars.u_s)     = 1;

%real rate
AAA(eq.real,vars.pi)     = 1;
BBB(eq.real,vars.real)   = -1;
BBB(eq.real,vars.i)      = 1;

% Nominal interest rate
AAA(eq.i,vars.phi1)      = 1; 