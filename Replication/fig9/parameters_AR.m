% Parameters
param.NS      = 0;  

param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0;   
param.beta    = 0.99;
param.sigma   = 0.5;  

param.phi_pi  = 1.5;   

param.rho     = 0.95;

param.lagr_x  = param.kappa/param.theta;
param.lagr_pi = 1;  
 
param.rl  = [0 1/param.beta-1]';
param.rh  = [0 1/param.beta-1]'; 
 
param.init_cond = [0;0;1/param.beta-1;-(1-param.rho)/param.rho*(1/param.beta-1);0;1/param.beta-1];
 