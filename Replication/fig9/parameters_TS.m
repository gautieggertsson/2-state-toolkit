% Parameters
param.NS      = 0;   

param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5;  

param.phi_pi  = 1.5; 

param.lagr_x  = param.kappa/param.theta; 
param.lagr_pi = 1;   
 
param.rl  = (1-param.mu-param.sigma*param.mu*param.kappa/(1-param.beta*param.mu))/param.sigma*target_output;
param.rh      = 1/param.beta-1;  
 