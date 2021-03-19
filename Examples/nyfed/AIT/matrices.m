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
BBB(eq.MUC,vars.cpast)= -exp(param.gam_nyfed)*param.h;
BBB(eq.MUC,vars.b)   = -(exp(param.gam_nyfed)-param.h)*(exp(param.gam_nyfed)-param.beta*param.h*param.mu);

% Capital stock
AAA(eq.Kstock,vars.kbarpast)= 1;
BBB(eq.Kstock,vars.kbarpast)= 1-param.istar/param.kstar;
BBB(eq.Kstock,vars.i)= param.istar/param.kstar;

% Effective capital
BBB(eq.effK,vars.k)= -1;
BBB(eq.effK,vars.u)= 1;
BBB(eq.effK,vars.kbarpast)= 1;

% Capital utilization
BBB(eq.Kuse,vars.rk)= -param.rkstar;
BBB(eq.Kuse,vars.u)  = param.a2u;

% Optimal investment
AAA(eq.optI,vars.i)  = param.beta;
AAA(eq.optI,vars.qpast)= 1/(param.s2*exp(2*param.gam_nyfed));
BBB(eq.optI,vars.i)  = 1+param.beta;
BBB(eq.optI,vars.ipast)= -1;

% Realized return on capital
BBB(eq.RrK,vars.rk)   = -param.rkstar/(param.rkstar+1-param.delta);
AAA(eq.RrK,vars.qpast)   = (1-param.delta)/(param.rkstar+1-param.delta);
BBB(eq.RrK,vars.Rtilde)  = 1;
BBB(eq.RrK,vars.pi)      = -1;
BBB(eq.RrK,vars.qpast)   = 1;

% expected return on capital
AAA(eq.ErK,vars.Rtilde)  = 1;
BBB(eq.ErK,vars.R)       = 1;
AAA(eq.ErK,vars.qpast)   = -param.zeta_sp_b;
AAA(eq.ErK,vars.kbarpast)= -param.zeta_sp_b;
AAA(eq.ErK,vars.npast)   = param.zeta_sp_b;
BBB(eq.ErK,vars.sigma)   = param.zeta_sp_sigma_omega;

% enterpreneurs net worth
AAA(eq.networth,vars.npast) = 1;
BBB(eq.networth,vars.Rtilde) = param.zeta_n_r_tilde_k;
BBB(eq.networth,vars.Rpast) = -param.zeta_n_r;
BBB(eq.networth,vars.pi) = -(param.zeta_n_r_tilde_k-param.zeta_n_r);
BBB(eq.networth,vars.qpast) = param.zeta_n_q_k;
BBB(eq.networth,vars.kbarpast) = param.zeta_n_q_k;
BBB(eq.networth,vars.npast) = param.zeta_n_n;
BBB(eq.networth,vars.sigmapast) = -param.zeta_n_sigma_omega/param.zeta_sp_sigma_omega*param.zeta_sp_sigma_omega;

% aggregate nominal wage
BBB(eq.aggWage,vars.w)      = -1;
BBB(eq.aggWage,vars.wpast)  = 1;
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
% policy rule
BBB(eq.policy,vars.R)      = -1;
BBB(eq.policy,vars.y)      = param.psi_y;
BBB(eq.policy,vars.pi)     = param.psi_pi + param.psi_ait/20;
BBB(eq.policy,vars.pip1)   = param.psi_ait/20;
BBB(eq.policy,vars.pip2)   = param.psi_ait/20;
BBB(eq.policy,vars.pip3)   = param.psi_ait/20;
BBB(eq.policy,vars.pip4)   = param.psi_ait/20;
BBB(eq.policy,vars.pip5)   = param.psi_ait/20;
BBB(eq.policy,vars.pip6)   = param.psi_ait/20;
BBB(eq.policy,vars.pip7)   = param.psi_ait/20;
BBB(eq.policy,vars.pip8)   = param.psi_ait/20;
BBB(eq.policy,vars.pip9)   = param.psi_ait/20;
BBB(eq.policy,vars.pip10)  = param.psi_ait/20;
BBB(eq.policy,vars.pip11)  = param.psi_ait/20;
BBB(eq.policy,vars.pip12)  = param.psi_ait/20;
BBB(eq.policy,vars.pip13)  = param.psi_ait/20;
BBB(eq.policy,vars.pip14)  = param.psi_ait/20;
BBB(eq.policy,vars.pip15)  = param.psi_ait/20;
BBB(eq.policy,vars.pip16)  = param.psi_ait/20;
BBB(eq.policy,vars.pip17)  = param.psi_ait/20;
BBB(eq.policy,vars.pip18)  = param.psi_ait/20;
BBB(eq.policy,vars.pip19)  = param.psi_ait/20;

% consumption extra
AAA(eq.ex1,vars.cpast)  = 1;
BBB(eq.ex1,vars.c)  = 1;
% wage extra
AAA(eq.ex2,vars.wpast)  = 1;
BBB(eq.ex2,vars.w)  = 1;
% investments extra  
AAA(eq.ex3,vars.ipast)  = 1;
BBB(eq.ex3,vars.i)  = 1;
% nominal interest extra  
AAA(eq.ex4,vars.Rpast)  = 1;
BBB(eq.ex4,vars.R)  = 1;
% pi extra 1
AAA(eq.ex5,vars.pip1) = 1;
BBB(eq.ex5,vars.pi) = 1;
% pi extra 2
AAA(eq.ex6,vars.pip2) = 1;
BBB(eq.ex6,vars.pip1)   = 1;
% pi extra 3
AAA(eq.ex7,vars.pip3) = 1;
BBB(eq.ex7,vars.pip2) = 1;
% pi extra 4
AAA(eq.ex8,vars.pip4) = 1;
BBB(eq.ex8,vars.pip3) = 1;
% pi extra 5
AAA(eq.ex9,vars.pip5) = 1;
BBB(eq.ex9,vars.pip4)   = 1;
% pi extra 6
AAA(eq.ex10,vars.pip6) = 1;
BBB(eq.ex10,vars.pip5) = 1;
% pi extra 7
AAA(eq.ex11,vars.pip7) = 1;
BBB(eq.ex11,vars.pip6) = 1;
% pi extra 8
AAA(eq.ex12,vars.pip8) = 1;
BBB(eq.ex12,vars.pip7)   = 1;
% pi extra 9
AAA(eq.ex13,vars.pip9) = 1;
BBB(eq.ex13,vars.pip8) = 1;
% pi extra 10
AAA(eq.ex14,vars.pip10) = 1;
BBB(eq.ex14,vars.pip9) = 1;
% pi extra 11
AAA(eq.ex15,vars.pip11) = 1;
BBB(eq.ex15,vars.pip10)   = 1;
% pi extra 12
AAA(eq.ex16,vars.pip12) = 1;
BBB(eq.ex16,vars.pip11) = 1;
% pi extra 13
AAA(eq.ex17,vars.pip13) = 1;
BBB(eq.ex17,vars.pip12) = 1;
% pi extra 14
AAA(eq.ex18,vars.pip14) = 1;
BBB(eq.ex18,vars.pip13)   = 1;
% pi extra 15
AAA(eq.ex19,vars.pip15) = 1;
BBB(eq.ex19,vars.pip14) = 1;
% pi extra 16
AAA(eq.ex20,vars.pip16) = 1;
BBB(eq.ex20,vars.pip15) = 1;
% pi extra 17
AAA(eq.ex21,vars.pip17) = 1;
BBB(eq.ex21,vars.pip16) = 1;
% pi extra 18
AAA(eq.ex22,vars.pip18) = 1;
BBB(eq.ex22,vars.pip17)   = 1;
% pi extra 19
AAA(eq.ex23,vars.pip19) = 1;
BBB(eq.ex23,vars.pip18) = 1;

% sigma extra
AAA(eq.ex24,vars.sigmapast)  = 1;
BBB(eq.ex24,vars.sigma)  = 1;

% shocks
%%%% preference shock
AAA(eq.pfs,vars.b)=1;
BBB(eq.pfs,vars.b)=1;

%spread shock
AAA(eq.sigma,vars.sigma)   = 1;
BBB(eq.sigma,vars.sigma)   = 1;

%cost-push shock
AAA(eq.cps,vars.u_s) = 1;
BBB(eq.cps,vars.u_s) = 1;