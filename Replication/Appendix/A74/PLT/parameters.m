% Parameters
% Calibration: Eggertsson and Woodford (2003) with drop in output = 7.5% and drop in inf = 0.5%
% Higher price rigidity (lower param.kappa)

param.NS      = 3;   

param.theta   = 7.87;
param.kappa   = 0.0018166;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5; 
param.phi_pi  = 1.5; 
param.phi_x   = 0.5; 
param.lagr_x  = 1/16;
param.lagr_pi = 1;   
param.rl      = -0.013875;   
param.rh      = 1/param.beta-1;  
param.ul      = 0;
param.uh      = 0;

param.sl = [param.rl;param.ul]; 
param.sh = [param.rh;param.uh]; 