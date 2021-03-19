 %% AVERAGE INFLATION TARGETING
% FRBNY DSGE Model (Del Negro et al, 2013)
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clc;
close all;


%% SPECIFY MODEL AND CALIBRATION
variables   % vector of variables [Z_t P_(t-1)]'
equations   % name equations
parameters  % model parameters 
matrices    % model matrices (A, B)


%% SPECIFY SOLVER CONFIGURATION
config.taumax       = 200;    % declare the maximum contingency
config.max_length_2 = 21;     % declare the maximum length of regime 2
config.bound        = -100000;% declare the bound for the variable subject to it
config.mono         = 0;      % switch for monotone k-vector (Josef says how is should be)


%% SOLVE
[D_3,G_3,D_3a] = regime3(AAA,BBB,param);
[D_2,G_2]      = regime2(AAA,BBB,D_3a,param,config);
[D_1,G_1, ResM, max_k,k,T_tilde] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'T_tilde_input',config.taumax,'R0_search',0);
 

%% COMPUTE ADDITIONAL VARIABLES

% plevel gap
vars.hat_P = size(ResM,2)+1;
ResM(:,vars.hat_P,:) = 0;
for t=1:size(ResM,1)
    if t ==1
        ResM(t,vars.hat_P,:) = ResM(t,vars.pi,:);
    else
        ResM(t,vars.hat_P,:) = ResM(t,vars.pi,:) + ResM(t-1,vars.hat_P,:);
    end
end

% NGDP gap
vars.hat_N = size(ResM,2)+1;
ResM(:,vars.hat_N,:) = 0;
for t=1:size(ResM,1)
    ResM(t,vars.hat_N,:) = ResM(t,vars.y,:) + ResM(t,vars.hat_P,:);
end

% Cumulative Nominal GDP, yhd
vars.yhd = size(ResM,2)+1;
ResM(:,vars.yhd,:) = 0;
for tau=2:config.taumax
    for t=1:size(ResM,1)-1
        if t==1
            ResM(t,vars.yhd,tau) = ResM(t,vars.hat_P,tau)+ResM(t,vars.y,tau);
        else
            ResM(t,vars.yhd,tau) = ResM(t,vars.hat_P,tau)+ResM(t,vars.y,tau) + ResM(t-1,vars.yhd,tau);
        end
    end
end

% Dual Mandate Index, yhdpi
vars.yhdpi = size(ResM,2)+1;
ResM(:,vars.yhdpi,:) = 0;
for tau=2:config.taumax
    for t=1:size(ResM,1)-1
        if t==1
            ResM(t,vars.yhdpi,tau) = 4*ResM(t,vars.pi,tau)+ResM(t,vars.y,tau);
        else
            ResM(t,vars.yhdpi,tau) = 4*ResM(t,vars.pi,tau)+ResM(t,vars.y,tau) + ResM(t-1,vars.yhdpi,tau);
        end
    end
end

param.NY = numel(fieldnames(vars));


%% COMPUTE IMPULSE RESPONSES
impulseresponse


%% PLOT IMPULSE RESPONSES
graphing(IR,vars,30,'cont_data',ResM,'cont_num',2:1:30)
