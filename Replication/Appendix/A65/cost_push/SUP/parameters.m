% Parameters
% Optimised policy rules (see Table A.2. for calibration)

param.NS      = 3;   

param.theta   = 7.87;
param.kappa   = 0.02;
param.mu      = 0.9; 
param.beta    = 0.99;
param.sigma   = 0.5; 
param.phi_pi  = 1.150772996618662;   
param.phi_x   = 1.228515405414182; 
param.phi_i   = 1.484151797948699;

param.lagr_x  = 1/16;
param.lagr_pi = 1;   

param.rl      = -0.013875;   
param.rh      = 1/param.beta-1;  

param.ul      = 0.00136375;  % cost push shock active
param.uh      = 0;  % cost push shock inactive

param.rl = [param.rl;param.rl;param.ul]; 
param.rh = [param.rh;param.rh;param.uh]; 

param.init_cond = [0;0;param.rh(1);0;0;param.rh(1);1;1;param.uh];