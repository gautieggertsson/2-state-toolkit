%% FRBNY DSGE Model (Del Negro et al, 2013)
%  Some more text

clc;
close all;
addpath('../../../Source')

%% SPECIFY MODEL AND CALIBRATION
variables  % vector of variables [Z_t P_(t-1)]'
equations  % name equations
parameters % model parameters 
matrices_0 % model matrices (A, B)

%% SPECIFY SOLVER CONFIGURATION
config.taumax       = 200;               % declare the maximum contingency
config.max_length_2 = 15;                % declare the maximum length of regime 2
config.bound        = -log(param.Rstarn); % declare the bound for the variable subject to it
config.mono         = 0;                 % switch for monotone k-vector (Josef says how is should be)

%% SOLVE
tic
[D_3,G_3,D_3a]           = regime3(AAA,BBB,param);
[D_2,G_2]                = regime2(AAA,BBB,D_3a,param,config);
[D_1,G_1, ResM, max_k,k,T_tilde] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config);
toc 

%% COMPUTE ADDITIONAL VARIABLES
% CheckR
vars.checkR = size(ResM,2)+1;        %to check if ZLB also implied by model
ResM(:,vars.checkR,:) = 0;
for tau=1:config.taumax
    for t=1:size(ResM,1)-1
        ResM(t,vars.checkR,tau) = param.rho_r*ResM(t,vars.R_lag,tau) + (1-param.rho_r)*(param.psi_pi*ResM(t,vars.pi,tau) + param.psi_y*ResM(t,vars.y,tau));
    end
end

% DCheckR
vars.dcheckR = size(ResM,2)+1;
ResM(:,vars.dcheckR,:) = 0;
ResM(1:end,vars.dcheckR,:) = ResM(1:end,vars.R,:)-ResM(1:end,vars.checkR,:); 

param.NY = numel(fieldnames(vars));

%% COMPUTE IMPULSE RESPONSES
impulseresponse

%% PLOT IMPULSE RESPONSES
graphing(IR,vars,50,["y","R","pi","checkR","dcheckR","c","i","k","b","sigma"],ResM,[2:5:50])
