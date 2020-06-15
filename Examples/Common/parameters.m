% Parameters
% Calibration: Eggertsson and Woodford (2003)

% Number of predetermined variables
param.NS      = 3;

% Structural parameters
param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5; 
param.phi_pi  = 1.5; 
param.phi_x   = 0.5; 
param.phi_i   = 0.8;  

% Shocks
param.rl      = -0.005;
param.rh      = 1/param.beta-1;

param.rl = [param.rh;param.rl];  
param.rh = [param.rh;param.rh];

% Initial conditions
param.init_cond = [0;0;param.rh(1);param.rh(1);0;0;param.rh(1);1;1];