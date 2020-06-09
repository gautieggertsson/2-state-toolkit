% Parameters
% Calibration: EW (2003)

param.NS      = 1;                           % comment

param.theta   = 7.87;                        % comment
param.kappa   = 0.02;                        % comment
param.mu      = 0.9;                         % comment
param.beta    = 0.99;                        % comment
param.sigma   = 0.5;                         % comment
param.phi_pi  = 100;                         % comment
param.phi_x   = param.phi_pi;                % comment


param.lagr_x  = param.kappa/param.theta;     % comment
param.lagr_pi = 1;                           % comment

param.rl      = -0.005;                      % comment
param.rh      = 1/param.beta-1;              % comment

param.rl = [param.rh;param.rl];              % comment
param.rh = [param.rh;param.rh];              % comment