% Parameters
% Calibration: Eggertsson and Woodford (2003) with drop in output = 7.5% and drop in inf = 0.5%

param.NS      = 1;   

param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5; 
param.phi_pi  = 100; 
param.phi_x   = param.phi_pi;

param.lagr_x  = 1/16;
param.lagr_pi = 1;   

param.rl      = -0.0105;   
param.rh      = 1/param.beta-1;  

param.ul      = 0.000955;  % cost push shock active
param.uh      = 0;   % cost push shock inactive

param.rl = [param.rh;param.rl;param.ul]; 
param.rh = [param.rh;param.rh;param.uh]; 