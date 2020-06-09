% Matrices
param.NY = numel(fieldnames(vars));
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);
    
% Output equation
AAA(eq.is,vars.x)         = 1;
AAA(eq.is,vars.pi)        = param.sigma;
BBB(eq.is,vars.x)         = 1;
BBB(eq.is,vars.i)         = param.sigma;
BBB(eq.is,vars.r)         = -param.sigma;

% Inflation equation
AAA(eq.pc,vars.pi)        = param.beta;
BBB(eq.pc,vars.pi)        = 1;
BBB(eq.pc,vars.x)         = -param.kappa;
BBB(eq.pc,vars.u_s)       = -1;

% pi extra 1
AAA(eq.pi_lag1,vars.pi_lag1)= 1;
BBB(eq.pi_lag1,vars.pi)     = 1;

% pi extra 2-19
for i = 2:19
    eval(strcat('AAA(eq.pi_lag',string(i),',vars.pi_lag',string(i),') = 1;'));
    eval(strcat('BBB(eq.pi_lag',string(i),',vars.pi_lag',string(i-1),') = 1;'));
end
clear i

% Natural-r target
AAA(eq.rstar,vars.rstar)   = 1;
BBB(eq.rstar,vars.rstar)   = 1;

% Natural-r constant
AAA(eq.r,vars.r)           = 1;
BBB(eq.r,vars.r)           = 1;

% Cost push shock
AAA(eq.cps,vars.u_s)       = 1;
BBB(eq.cps,vars.u_s)       = 1;

% Nominal interest rate
BBB(eq.rule,vars.i)        = -1;
BBB(eq.rule,vars.x)        = param.phi_x;
BBB(eq.rule,vars.rstar)    = 1;
BBB(eq.rule,vars.pi)       = param.phi_pi + param.psi_ait/20;
BBB(eq.rule,vars.pi_lag1)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag2)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag3)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag4)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag5)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag6)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag7)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag8)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag9)  = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag10) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag11) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag12) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag13) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag14) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag15) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag16) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag17) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag18) = param.psi_ait/20;
BBB(eq.rule,vars.pi_lag19) = param.psi_ait/20;

