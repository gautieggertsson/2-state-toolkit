% Parameters
% Calibration: Eggertsson and Woodford (2003)

% Number of state variables
param.NS      = 5;

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
param.low     = -0.005;
param.high    = 1/param.beta-1;
param.const   = param.high;

param.sl = [param.const;param.low];  
param.sh = [param.const;param.high];

% Initial conditions
param.init_cond = zeros(length(fieldnames(vars)),1);
param.init_cond(vars.i_lag) = param.const;