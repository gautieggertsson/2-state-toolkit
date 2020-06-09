% Parameters
param.NS = 12;

param.target_natreal      = 0; %user input: target natural rate of interest in percent (annualized); source for 0: % Source for f* https://www.federalreserve.gov/monetarypolicy/fomcprojtabl20191211.htm
param.gam_nyfed           = 1.687/400; %'/400' since gamma in annualized terms and they also do it
param.a2u                 = 0.294;
param.h                   = 0.704;
helper_bet                = -param.target_natreal + 400*param.gam_nyfed;
param.beta                = exp(helper_bet/400); 
param.s2                  = 3.121;
param.gamma_e             = 0.99;
param.gammstar            = param.gamma_e; %no idea what else gammstar should be!!!!! they also use 0.99 for gammstar
param.delta               = 0.025;
param.zeta_sp_b           = 0.070;
param.nu_l                = 1.273;
param.lambda_w            = 0.3;
param.alpha               = 0.350;
param.gstar               = 0.195;
param.psi_p               = 1 ;
param.psi_y               = param.psi_p;
param.pistar              = exp(2.0/400);
param.sigma_r             = 0.152;
param.lambda_f            = 0.15;
param.sprd                = (1+1.163/100)^(1/4); %exp(para(21)/400);    %% st st spread from annual perc to quarterly number ; like they do it
param.Lstar               = 1; %taken from their matlab file. they fix it at 1
param.Bigphi              = 0; %taken from them. they fix it at 0
param.chi                 = 0.1;
param.nu_m                = 2;
param.Fom                 = 1-(1-0.15)^(1/4); %0.0075 ; %F(omegabar)
%
param.zeta_omega          = 0.904; %0.904 prob of not being able to change wage; 0.81 for output in draft
%
param.zeta_p              = 0.879; %0.879%prob of not being able to change price ; 0.75 for output in draft
%
param.rho_r               = 0.762; %0.762

param.lagr_pi             = 1;  		%weight on pi in welfare loss function
param.lagr_x              = 1/16; 		%weight on pi in welfare loss function

param.mu                  = 0.73626; %0.28   prob to switch back to good state %0.395 for output in draft
param.gamdelphic          = 0.2238;
param.mono                = 0   ; % 0 for not imposing monotonicity in egg
param.rl                  = -0.10512; %-0.08
param.spsl                = 0.0; %2  %2.25 for output in draft; try to hit double decline of consumption. Less than in data, but doesn't recover so fast in model as in data (no need to match exactly)
param.ul                  = 0.001556;

% Add fake shocks for the code to compute the number of shocks
param.rl = [param.rl;param.spsl;log(param.pistar);param.ul];                %[-0.097;3] double i to c;[-0.100;2.2] equal c and i resp
param.rh = [0.0000000;0.0000000;log(param.pistar);0];

% Additional transformations
addpath('../Commons')
NYFEDpara