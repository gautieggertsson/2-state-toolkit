% Matrices
param.NY = numel(fieldnames(vars));
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);

% consumption Euler equation
AAA(eq.CEE,vars.xi)  = 1;
AAA(eq.CEE,vars.pi)  = -1;
BBB(eq.CEE,vars.R)   = -1;
BBB(eq.CEE,vars.xi)  = 1;

% u'(c)
AAA(eq.MUC,vars.c)   = param.beta*param.h*exp(param.gam_nyfed);
BBB(eq.MUC,vars.xi)  = (exp(param.gam_nyfed)-param.h*param.beta)*(exp(param.gam_nyfed)-param.h);
BBB(eq.MUC,vars.c)   = (exp(2*param.gam_nyfed)+param.h^2*param.beta);
BBB(eq.MUC,vars.c_lag)= -exp(param.gam_nyfed)*param.h;
BBB(eq.MUC,vars.b)   = -(exp(param.gam_nyfed)-param.h)*(exp(param.gam_nyfed)-param.beta*param.h*param.mu);

% Capital stock
AAA(eq.Kstock,vars.kbar_lag)= 1;
BBB(eq.Kstock,vars.kbar_lag)= 1-param.istar/param.kstar;
BBB(eq.Kstock,vars.i)= param.istar/param.kstar;

% Effective capital
BBB(eq.effK,vars.k)= -1;
BBB(eq.effK,vars.u)= 1;
BBB(eq.effK,vars.kbar_lag)= 1;

% Capital utilization
BBB(eq.Kuse,vars.rk)= -param.rkstar;
BBB(eq.Kuse,vars.u)  = param.a2u;

% Optimal investment
AAA(eq.optI,vars.i)  = param.beta;
AAA(eq.optI,vars.q_lag)= 1/(param.s2*exp(2*param.gam_nyfed));
BBB(eq.optI,vars.i)  = 1+param.beta;
BBB(eq.optI,vars.i_lag)= -1;

% Realized return on capital
BBB(eq.RrK,vars.rk)   = -param.rkstar/(param.rkstar+1-param.delta);
AAA(eq.RrK,vars.q_lag)   = (1-param.delta)/(param.rkstar+1-param.delta);
BBB(eq.RrK,vars.Rtilde)  = 1;
BBB(eq.RrK,vars.pi)      = -1;
BBB(eq.RrK,vars.q_lag)   = 1;

% expected return on capital
AAA(eq.ErK,vars.Rtilde)  = 1;
BBB(eq.ErK,vars.R)       = 1;
AAA(eq.ErK,vars.q_lag)   = -param.zeta_sp_b;
AAA(eq.ErK,vars.kbar_lag)= -param.zeta_sp_b;
AAA(eq.ErK,vars.n_lag)   = param.zeta_sp_b;
BBB(eq.ErK,vars.sigma)   = param.zeta_sp_sigma_omega;

% enterpreneurs net worth
AAA(eq.networth,vars.n_lag) = 1;
BBB(eq.networth,vars.Rtilde) = param.zeta_n_r_tilde_k;
BBB(eq.networth,vars.R_lag) = -param.zeta_n_r;
BBB(eq.networth,vars.pi) = -(param.zeta_n_r_tilde_k-param.zeta_n_r);
BBB(eq.networth,vars.q_lag) = param.zeta_n_q_k;
BBB(eq.networth,vars.kbar_lag) = param.zeta_n_q_k;
BBB(eq.networth,vars.n_lag) = param.zeta_n_n;
BBB(eq.networth,vars.sigma_lag) = -param.zeta_n_sigma_omega/param.zeta_sp_sigma_omega*param.zeta_sp_sigma_omega;

% aggregate nominal wage
BBB(eq.aggWage,vars.w)      = -1;
BBB(eq.aggWage,vars.w_lag)  = 1;
BBB(eq.aggWage,vars.pi)     = -1;
BBB(eq.aggWage,vars.wtilde) = (1-param.zeta_omega)/param.zeta_omega;

% optimal reset wage
AAA(eq.optWage,vars.wtilde)= param.zeta_omega*param.beta*(1+param.nu_l*(1+param.lambda_w)/param.lambda_w) ;
AAA(eq.optWage,vars.w)  = param.zeta_omega*param.beta*(1+param.nu_l*(1+param.lambda_w)/param.lambda_w);
AAA(eq.optWage,vars.pi) = param.zeta_omega*param.beta*(1+param.nu_l*(1+param.lambda_w)/param.lambda_w);
BBB(eq.optWage,vars.wtilde)= (1+param.nu_l*(1+param.lambda_w)/param.lambda_w);
BBB(eq.optWage,vars.w)  = 1+param.zeta_omega*param.beta*param.nu_l*(1+param.lambda_w)/param.lambda_w;
BBB(eq.optWage,vars.L)  = -(1-param.zeta_omega*param.beta)*param.nu_l;
BBB(eq.optWage,vars.xi) = 1-param.zeta_omega*param.beta;
BBB(eq.optWage,vars.b)  = -(1-param.zeta_omega*param.beta)*(exp(2*param.gam_nyfed)+param.h^2*param.beta)*exp(-param.gam_nyfed)/(exp(param.gam_nyfed)-param.h);

% Phillips curve
AAA(eq.PhilC,vars.pi)       = param.beta;
BBB(eq.PhilC,vars.mc)       = -(1-param.zeta_p)*(1-param.zeta_p*param.beta)/(param.zeta_p);
BBB(eq.PhilC,vars.pi)       = 1;
BBB(eq.PhilC,vars.u_s)      = -1;

% marginal cost
BBB(eq.mc,vars.mc)      = -1;
BBB(eq.mc,vars.w)       = 1-param.alpha;
BBB(eq.mc,vars.rk)      = param.alpha;

% production function
BBB(eq.prod,vars.y)       = -1;
BBB(eq.prod,vars.k)       = param.alpha;
BBB(eq.prod,vars.L)       = 1-param.alpha;
% K/L ratio
BBB(eq.KLratio,vars.k) = -1;
BBB(eq.KLratio,vars.rk)= -1;
BBB(eq.KLratio,vars.L) = 1;
BBB(eq.KLratio,vars.w) = 1;
% resource constraint
BBB(eq.resconst,vars.y) = -1;
BBB(eq.resconst,vars.c) = param.cstar/(param.cstar+param.istar);
BBB(eq.resconst,vars.i) = param.istar/(param.cstar+param.istar);
BBB(eq.resconst,vars.u) = param.rkstar*param.kstar/(param.cstar+param.istar);

% Price level equation
AAA(eq.pl,vars.p_lag)  = 1;
BBB(eq.pl,vars.pi)     = 1;
BBB(eq.pl,vars.pistar) = 1;
BBB(eq.pl,vars.p_lag)  = 1;
% Price level target
AAA(eq.pstar,vars.pstar)  = 1;
BBB(eq.pstar,vars.pistar) = 1;
BBB(eq.pstar,vars.pstar)  = 1;

% Truncated Taylor rule (future inflation and output)
AAA(eq.rule,vars.pi)       = -param.psi_pi;
AAA(eq.rule,vars.y)        = -param.psi_y;
BBB(eq.rule,vars.R)        = -1;
BBB(eq.rule,vars.pi_lag)   = 0;
BBB(eq.rule,vars.R_lag)    = 0;
BBB(eq.rule,vars.y_lag)    = 0; 
BBB(eq.rule,vars.pi)       = 0;
BBB(eq.rule,vars.y)        = 0;

% lagged consumption
AAA(eq.ex1,vars.c_lag)  = 1;
BBB(eq.ex1,vars.c)  = 1;
% lagged wage
AAA(eq.ex2,vars.w_lag)  = 1;
BBB(eq.ex2,vars.w)  = 1;
% lagged investments  
AAA(eq.ex3,vars.i_lag)  = 1;
BBB(eq.ex3,vars.i)  = 1;
% lagged nominal interest  
AAA(eq.ex4,vars.R_lag)  = 1;
BBB(eq.ex4,vars.R)  = 1;
% lagged output
AAA(eq.ex5,vars.y_lag)  = 1;
BBB(eq.ex5,vars.y)  = 1;
% lagged sigma
AAA(eq.ex12,vars.sigma_lag)  = 1;
BBB(eq.ex12,vars.sigma)  = 1;
% lagged inflation
AAA(eq.pi_lag,vars.pi_lag)  = 1;
BBB(eq.pi_lag,vars.pi)  = 1;

% shocks
%%%% preference shock
AAA(eq.pfs,vars.b)=1;
BBB(eq.pfs,vars.b)=1;

%spread shock
AAA(eq.sigma,vars.sigma)   = 1;
BBB(eq.sigma,vars.sigma)   = 1;

% pistar constant
AAA(eq.pistar,vars.pistar) = 1;
BBB(eq.pistar,vars.pistar) = 1;


%cost-push shock
AAA(eq.cps,vars.u_s) = 1;
BBB(eq.cps,vars.u_s) = 1;