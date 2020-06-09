% Parameters
% Calibration: EW (2003) with drop in output = 7.5% and drop in inf = 0.5%

param.NS      = 1;                           % comment

param.theta   = 7.87;                        % comment
param.kappa   = 0.02;                        % comment
param.mu      = 0.9;                         % comment
param.beta    = 0.99;                        % comment
param.sigma   = 0.5;                         % comment
param.phi_pi  = 100;                         % comment
param.phi_x   = param.phi_pi;                % comment

param.lagr_x  = 1/16;                        % comment
param.lagr_pi = 1;                           % comment

param.rl      = -0.013875;                   % comment
param.rh      = 1/param.beta-1;              % comment

param.ul      = 0.00136375;                  % cost push shock active
param.uh      = 0;                           % cost push shock inactive

param.rl = [param.rh;param.rl;param.ul];     % comment
param.rh = [param.rh;param.rh;param.uh];     % comment