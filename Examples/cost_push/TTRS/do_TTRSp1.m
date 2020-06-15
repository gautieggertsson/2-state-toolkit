%% TRUNCATED TAYLOR RULE (TTRS). SMOOTHED FUTURE INFLATION AND OUTPUT GAP
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clc;
close all;
addpath('../../../Source')

%% SPECIFY MODEL AND CALIBRATION
variables   % vector of variables [Z_t P_(t-1)]'
equations   % name equations
parameters  % model parameters
matrices_p1 % model matrices (A, B)

%% SPECIFY SOLVER CONFIGURATION
config.taumax       = 400; % declare the maximum contingency
config.max_length_2 = 50;  % declare the maximum length of regime 2
config.bound        = 0;   % declare the bound for the variable subject to it
config.mono         = 1;   % switch for monotone k-vector

%% SOLVE
[D_3,G_3,D_3a]           = regime3(AAA,BBB,param);
[D_2,G_2]                = regime2(AAA,BBB,D_3a,param,config);
[D_1,G_1, ResM, max_k,k,T_tilde] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config);

%% COMPUTE ADDITIONAL VARIABLES
vars.p      = param.NY + 1; % price level
vars.ngdp   = param.NY + 2; % nominal GDP
vars.yhd    = param.NY + 3; % yhd (cumulative Y with P and x)
vars.yhdpi  = param.NY + 4; % yhd (cumulative Y with P and pi)
vars.rr     = param.NY + 5; % real rate


for it = 1:size(ResM,1)  
    ResM(it,vars.p,:) = sum(ResM(1:it,vars.pi,:),1);
end
clearvars it
 
ResM(:,vars.ngdp,:) = ResM(:,vars.x,:)+ResM(:,vars.p,:);

for it = 1:size(ResM,1)  
    ResM(it,vars.yhd,:) = sum(ResM(1:it,vars.p,:),1)+sum(ResM(1:it,vars.x,:),1);
end
clearvars it

for it = 1:size(ResM,1)  
    ResM(it,vars.yhdpi,:) = 4*sum(ResM(1:it,vars.pi,:),1)+sum(ResM(1:it,vars.x,:),1);
end
clearvars it

tic
matrixind = [1:size(ResM,1)]'>= [1:size(ResM,3)];
auxPI1 = [squeeze(ResM(2:end,vars.pi,:)); squeeze(ResM(end,vars.pi,:))'];
auxPI2 = [repmat([diag(squeeze(ResM(2:end,vars.pi,2:end))) ; ResM(end,vars.pi,end)],1,size(ResM,3));ones(size(ResM,1)-size(ResM,3),size(ResM,3))*ResM(end,vars.pi,end) ];
auxPI3 = [repmat([diag(squeeze(ResM(2:end,vars.pi,2:end)),1) ; ResM(end,vars.pi,end); ResM(end,vars.pi,end)],1,size(ResM,3));ones(size(ResM,1)-size(ResM,3),size(ResM,3))*ResM(end,vars.pi,end)]; 
X2 = squeeze(ResM(:,vars.i,:))-matrixind.*auxPI1-(1-matrixind).*((1-param.mu)*auxPI2+param.mu*auxPI3);

ResM(:,vars.rr,:) = X2;
toc
clearvars matrixind auxPI1 auxPI2 auxPI3 

param.NY = numel(fieldnames(vars));

%% COMPUTE IMPULSE RESPONSES
impulseresponse

%% PLOT IMPULSE RESPONSES
graphing(IR,vars,25,["i","pi","x"],ResM,1:1:20)