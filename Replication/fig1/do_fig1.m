%% OPTIMAL COMMITMENT POLICY (RAMSEY PLAN)
%  Some more text

clear;
clc;
close all;

config.root = '../../';
addpath([config.root '/Source']);
addpath('../Common')

%% SPECIFY MODEL AND CALIBRATION
variables   % vector of variables [Z_t P_(t-1)]'
equations   % name equations
parameters  % model parameters
matrices    % model matrices (A, B)

%% SPECIFY SOLVER CONFIGURATION
config.taumax       = 400; % declare the maximum contingency
config.max_length_2 = 50;  % declare the maximum length of regime 2
config.bound        = 0;   % declare the bound for the variable subject to it
config.mono         = 1;   % switch for monotone k-vector

%% SOLVE
[D_3,G_3,D_3a]           = regime3(AAA,BBB,param);
[D_2,G_2]                = regime2(AAA,BBB,D_3a,param,config);
[D_1,G_1, ResM, max_k,k] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config);

%% COMPUTE IMPULSE RESPONSES
impulseresponse

ResM(:,1,:) = 100*ResM(:,1,:); % output gap
ResM(:,2,:) = 400*ResM(:,2,:); % inflation
ResM(:,3,:) = 400*ResM(:,3,:); % nominal rate
ResM(:,6,:) = 400*ResM(:,6,:); % real rate

IR(:,1) = 100*IR(:,1); % output gap
IR(:,2) = 400*IR(:,2); % inflation
IR(:,3) = 400*IR(:,3); % nominal rate
IR(:,6) = 400*IR(:,6); % real rate

%% PLOT IMPULSE RESPONSES
graph_ew(IR,vars,25,colours(1),["x","pi","i","r"],ResM,2:15)
saveas(gcf,'EW_base.pdf');  

