% Parameters
% Optimised policy rules (see Table A.2. for calibration)

param.NS      = 4;   

param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5; 
param.phi_pi  = 99.997598983681129; 
param.phi_x   = 34.297991159699485; 
param.alpha   = 92.086826423070548;   
param.lagr_x  = 1/16;
param.lagr_pi = 1;   
param.rl      = -0.013875;   
param.rh      = 1/param.beta-1;  
param.ul      = 0.00136375;
param.uh      = 0;

param.sl = [param.rh;param.rl;param.ul]; 
param.sh = [param.rh;param.rh;param.uh]; 