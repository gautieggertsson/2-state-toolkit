% Parameters
% Calibration: Eggertsson and Woodford (2003) with drop in output = 7.5%
% and drop in inflation = 0.5% under a Truncated Taylor Rule (TTR)

param.NS      = 4;   

param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5; 
param.phi_p   = 1.5; 

param.phi_x   = 0.0; 

param.lagr_x  = 1/16;
param.lagr_pi = 1;   

param.rl      = -0.013875;   
param.rh      = 1/param.beta-1;  

param.ul      = 0.00136375;  % cost push shock active
param.uh      = 0;   % cost push shock inactive

param.sl = [param.rh;param.rl;param.ul]; 
param.sh = [param.rh;param.rh;param.uh]; 