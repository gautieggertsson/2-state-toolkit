%% EXAMPLE 3 - Exclude Regime-0, Specify Exogenous T-tilde
% The example is based on a simple 3-equation New-Keynesian Model featuring
% a Truncated Taylor rule with backward looking component.
% See readme.md for additional details.
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
clc;
close all;

addpath('../Source')
addpath('Common')


%%  0) CONFIGURATION

%   0.1) SPECIFY SOLVER CONFIGURATION
config.taumax       = 400; % declare the maximum contingency
config.max_length_2 = 50;  % declare the maximum length of regime 2
config.bound        = 0;   % declare the bound for the variable subject to it
config.mono         = 1;   % switch for monotone k-vector
config.trh          = -exp(-14); % declare a numerical threshold for which the constraint is thought as binding. i.e. if i < bound +trh, then lower bound counts as being violated

%   0.2) SPECIFY MODEL AND CALIBRATION
variables      % vector of variables [Z_t P_(t-1)]'
equations      % name equations
parameters_ex3 % model parameters
matrices       % model matrices (A, B)


%%  1) RUN WITH NO R0 SEARCH AND NO T_TILDE (DEFAULT T_TILDE =1) 
%   the implied interest rate, by the Taylor rule is positive, but the
%   model imposes the ELB
[D_3,G_3,D_3a]                      = regime3(AAA,BBB,param);
[D_2,G_2]                           = regime2(AAA,BBB,D_3a,param,config); 
[D_1,G_1, ResM, max_k,k,T_tilde]    = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'verbose',1,'R0_search',0);

% Rescale into annualized values
ResM(:,vars.x,:)    = ResM(:,vars.x,:)*100;
ResM(:,vars.pi,:)   = ResM(:,vars.pi,:)*400;
ResM(:,vars.i,:)    = ResM(:,vars.i,:)*400;
ResM(:,vars.i_imp,:)= ResM(:,vars.i_imp,:)*400;

%	1.1) COMPUTE IMPULSE RESPONSES
impulseresponse

%   1.2) PLOT IMPULSE RESPONSES
graphing(IR,vars,25,["pi","x","i","i_imp"],ResM,[])
