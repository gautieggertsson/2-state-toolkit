%% FRBNY DSGE Model (Del Negro et al, 2013)
%  Some more text

clc;
close all;
addpath('../../../Source')

%% SPECIFY MODEL AND CALIBRATION
variables_40   % vector of variables [Z_t P_(t-1)]'
equations_40   % name equations
parameters_40  % model parameters 
matrices_40    % model matrices (A, B)

%% SPECIFY SOLVER CONFIGURATION
config.taumax       = 200;               % declare the maximum contingency
config.max_length_2 = 10;                % declare the maximum length of regime 2
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
    for t=1:size(ResM,1)
        ResM(t,vars.checkR,tau) = param.psi_pi*ResM(t,vars.pi,tau) + param.psi_y*ResM(t,vars.y,tau)...
            + param.psi_ait*(ResM(t,vars.pi,tau)+ResM(t,vars.pip1,tau)+ResM(t,vars.pip2,tau)...
            +ResM(t,vars.pip3,tau)+ResM(t,vars.pip4,tau)+ResM(t,vars.pip5,tau)+ResM(t,vars.pip6,tau)...
            +ResM(t,vars.pip7,tau)+ResM(t,vars.pip8,tau)+ResM(t,vars.pip9,tau)+ResM(t,vars.pip10,tau)...
            +ResM(t,vars.pip11,tau)+ResM(t,vars.pip12,tau)+ResM(t,vars.pip13,tau)+ResM(t,vars.pip14,tau)...
            +ResM(t,vars.pip15,tau)+ResM(t,vars.pip16,tau)+ResM(t,vars.pip17,tau)+ResM(t,vars.pip18,tau)...
            +ResM(t,vars.pip19,tau)+ResM(t,vars.pip20,tau)+ResM(t,vars.pip21,tau)+ResM(t,vars.pip22,tau)...
            +ResM(t,vars.pip23,tau)+ResM(t,vars.pip24,tau)+ResM(t,vars.pip25,tau)+ResM(t,vars.pip26,tau)...
            +ResM(t,vars.pip27,tau)+ResM(t,vars.pip28,tau)+ResM(t,vars.pip29,tau)+ResM(t,vars.pip30,tau)...
            +ResM(t,vars.pip31,tau)+ResM(t,vars.pip32,tau)+ResM(t,vars.pip33,tau)+ResM(t,vars.pip34,tau)...
            +ResM(t,vars.pip35,tau)+ResM(t,vars.pip36,tau)+ResM(t,vars.pip37,tau)+ResM(t,vars.pip38,tau)...
            +ResM(t,vars.pip39,tau))/40;
    end
end

% average inflation over last 5 years
vars.api40 = size(ResM,2)+1;        %to check if ZLB also implied by model
ResM(:,vars.api40,:) = 0;
for tau=1:config.taumax
    for t=1:size(ResM,1)
        ResM(t,vars.api40,tau) = (ResM(t,vars.pi,tau)+ResM(t,vars.pip1,tau)+ResM(t,vars.pip2,tau)...
            +ResM(t,vars.pip3,tau)+ResM(t,vars.pip4,tau)+ResM(t,vars.pip5,tau)+ResM(t,vars.pip6,tau)...
            +ResM(t,vars.pip7,tau)+ResM(t,vars.pip8,tau)+ResM(t,vars.pip9,tau)+ResM(t,vars.pip10,tau)...
            +ResM(t,vars.pip11,tau)+ResM(t,vars.pip12,tau)+ResM(t,vars.pip13,tau)+ResM(t,vars.pip14,tau)...
            +ResM(t,vars.pip15,tau)+ResM(t,vars.pip16,tau)+ResM(t,vars.pip17,tau)+ResM(t,vars.pip18,tau)...
            +ResM(t,vars.pip19,tau)+ResM(t,vars.pip20,tau)+ResM(t,vars.pip21,tau)+ResM(t,vars.pip22,tau)...
            +ResM(t,vars.pip23,tau)+ResM(t,vars.pip24,tau)+ResM(t,vars.pip25,tau)+ResM(t,vars.pip26,tau)...
            +ResM(t,vars.pip27,tau)+ResM(t,vars.pip28,tau)+ResM(t,vars.pip29,tau)+ResM(t,vars.pip30,tau)...
            +ResM(t,vars.pip31,tau)+ResM(t,vars.pip32,tau)+ResM(t,vars.pip33,tau)+ResM(t,vars.pip34,tau)...
            +ResM(t,vars.pip35,tau)+ResM(t,vars.pip36,tau)+ResM(t,vars.pip37,tau)+ResM(t,vars.pip38,tau)...
            +ResM(t,vars.pip39,tau))/40;
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
graphing(IR,vars,60,["xi","pi","c","i","y","R","checkR","dcheckR","wtilde","w","Rtilde","L","u","mc","rk","k","ipast","kbarpast","qpast","npast","Rpast","cpast","wpast","pip39","api40","sigmapast","b","sigma"],ResM,[2:1:60])
