% Parameters
param.NS = 13;

param.target_natreal = 0;
param.gam_nyfed      = 1.687/400;
param.a2u            = 0.294;
param.h              = 0.704;
helper_bet           = -param.target_natreal + 400*param.gam_nyfed;
param.beta           = exp(helper_bet/400); 
param.s2             = 3.121;
param.gamma_e        = 0.99;
param.gammstar       = param.gamma_e; 
param.delta          = 0.025;
param.zeta_sp_b      = 0.070;
param.nu_l           = 1.273;
param.lambda_w       = 0.3;
param.alpha          = 0.350;
param.gstar          = 0.195;
param.psi_pi         = 2.016 ;
param.psi_y          = 0.273 ;
param.pistar         = exp(2.0/400);
param.sigma_r        = 0.152;
param.lambda_f       = 0.15;
param.sprd           = (1+1.163/100)^(1/4); 
param.Lstar          = 1; 
param.Bigphi         = 0; 
param.chi            = 0.1;
param.nu_m           = 2;
param.Fom            = 1-(1-0.15)^(1/4); 
param.zeta_omega     = 0.904; 
param.zeta_p         = 0.879;
param.sho_r          = 0.762; 
param.lagr_pi        = 1;  		
param.lagr_x         = 1/16;
param.mu             = 0.73626;
param.mono           = 0; 
param.sl             = -0.10512; 
param.spsl           = 0;
param.ul             = 0.001556;

param.sl = [param.sl;param.spsl;param.ul];
param.sh = zeros(3,1);

% Additional transformations
addpath('../Commons')
NYFEDpara