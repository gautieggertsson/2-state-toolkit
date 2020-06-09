% Parameters
param.NS      = 0;                              % comment

param.theta   = 7.87;                        % comment
param.kappa   = 0.02;                        % comment
param.mu      = 0;                           % comment
param.beta    = 0.99;                        % comment
param.sigma   = 0.5;  

param.phi_pi  = 1.5;                               % comment

param.rho     = 0.95;

param.lagr_x  = param.kappa/param.theta;        % comment
param.lagr_pi = 1;                              % comment
 
param.rl  = [0 1/param.beta-1]';
param.rh  = [0 1/param.beta-1]';                 % comment
 
param.init_cond = [0;0;1/param.beta-1;-(1-param.rho)/param.rho*(1/param.beta-1);0;1/param.beta-1];
 