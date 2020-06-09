% Parameters
param.NS      = 0;                           % comment

param.theta   = 7.87;                        % comment
param.kappa   = 0.02;                        % comment
param.mu      = 0.9;                         % comment
param.beta    = 0.99;                        % comment
param.sigma   = 0.5;  

param.phi_pi  = 1.5;                         % comment

param.lagr_x  = param.kappa/param.theta;     % comment
param.lagr_pi = 1;                           % comment
 
param.rl  = (1-param.mu-param.sigma*param.mu*param.kappa/(1-param.beta*param.mu))/param.sigma*target_output;
param.rh      = 1/param.beta-1;              % comment
 