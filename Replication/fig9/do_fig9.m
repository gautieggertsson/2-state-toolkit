%% FIXED LENGTH FORWARD GUIDANCE: 2-STATE MARKOV VS AR(1)
% This code compares the response to a 'fg_target'-period Forward Guidance
% policy under a 2-state Markov process for the exogenous natural interest
% rate to the same policy under AR(1) process. Under both processes, the
% FL-FG tries to replicate commitment. The initial shock is calibrated
% in both processes so that it produces a 7.5% drop in output on impact
% if the central bank followed a Taylor rule (discretion)
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clc;
close all;
clear;
addpath('../../Source')
addpath('../Common')


%% 1.0) 2-STATE MARKOV - CONFIGURE
config.taumax       = 400;  % declare the maximum contingency
config.max_length_2 = 50;  % declare the maximum length of regime 2
config.bound        = 0; % declare the bound for the variable subject to it
config.mono         = 1; % switch for monotone k-vector

%% 1.1) 2-STATE MARKOV - DISCRETION
target_output = -0.075;
parameters_TS
variables_equations_matrices_TS_DISC

[D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
[D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.TS.dis.k] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.TS.dis.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.TS.dis.ResM = ResM;   % store resm
impulseresponse                             % store IRF
R.TS.dis.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i)];

%% 1.2) 2-STATE MARKOV - FLFG
T = 30;
L = nan(T,1);
k = zeros(config.taumax,1)';
for t = 1:T
    tic
    k(2:t) = k(2:t)+ones(t-1,1)';
    
    [D_3,G_3,D_3a]     = regime3(AAA,BBB,param);
    [D_2,G_2]          = regime2(AAA,BBB,D_3a,param,config);
    [~,~, ResM,~,k_TS] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k,'R0_search',0);
    
    ResM_pi = 4*squeeze(ResM(:,vars.pi,:));
    ResM_x  = squeeze(ResM(:,vars.x,:));
    lambda = [param.lagr_pi;param.lagr_x];
    target = zeros(2,1);

    L(t) = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
    toc
end

plot(1:T,L)

% Store optimal FLFG duration (minimal welfare loss)
param.fg_target = find(L == min(L));

% Run optimal FLFG policy
k = zeros(config.taumax,1)';
k(2:param.fg_target) = sort(1:(param.fg_target-1),'descend');

[D_3,G_3,D_3a]                   = regime3(AAA,BBB,param);
[D_2,G_2]                        = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.TS.flfg.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.TS.flfg.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.TS.flfg.ResM = ResM;   % store resm
impulseresponse                             % store IRF
R.TS.flfg.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i)];
 
clearvars -except R config param


%% 1.3) 2-STATE MARKOV - COMM 
variables_equations_matrices_TS_COMM 

[D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
[D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.TS.com.k] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.TS.com.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.TS.com.ResM = ResM;   % store resm
impulseresponse                             % store IRF
R.TS.com.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i)]; 

clearvars -except R config

%% 2.0) AR(1) - CONFIGURE
config.taumax       = 5; % declare the maximum contingency
config.max_length_2 = 150;  % declare the maximum length of regime 2
config.mono         = 0;   % switch for monotone k-vector

%% 2.1) AR(1) - FIND SHOCK SIZE FOR OUTPUT DROP UNDER DISCRETION
target_output = -0.075;
parameters_AR
variables_equations_matrices_AR_DISC

param.rl(1)  = -0.014958071736894;

it = 0;
err = 1;
ResM_x = nan(2,2);
ResM_x(1,2) = target_output;
while err> 0.00000001
    
    param.rl(1)  = param.rl(1)*exp(ResM_x(1,2)-target_output);
    [D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
    [D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
    [~,~,ResM,~,R.AR.dis.k] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

    ResM_x  = squeeze(ResM(:,vars.x,:));
    err = abs(ResM_x(1,2)-target_output)
    it = it+1;
end 

[D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
[D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.AR.dis.k] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.AR.dis.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.AR.dis.ResM = ResM;   % store resm
impulseresponse                             % store IRF
R.AR.dis.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i)];

%% 2.2) AR(1) - FLFG
T = 30;
L = nan(T,1);
k = zeros(config.taumax,1)';
for t = 1:T
    tic
    k(2) = k(2)+1;
    
    [D_3,G_3,D_3a]     = regime3(AAA,BBB,param);
    [D_2,G_2]          = regime2(AAA,BBB,D_3a,param,config);
    [~,~, ResM,~,k_TS] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k,'R0_search',0);
    
    ResM_pi = 4*squeeze(ResM(:,vars.pi,:));
    ResM_x  = squeeze(ResM(:,vars.x,:));
    lambda = [param.lagr_pi;param.lagr_x];
    target = zeros(2,1);

    L(t) = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
    toc
end

plot(1:T,L)

% Store optimal FLFG duration (minimal welfare loss)
param.fg_target = find(L == min(L));

% Run optimal FLFG policy
k = zeros(config.taumax,1)';
k(2:param.fg_target) = sort(1:(param.fg_target-1),'descend');
k = k(1:config.taumax);
[D_3,G_3,D_3a]                   = regime3(AAA,BBB,param);
[D_2,G_2]                        = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.AR.flfg.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.AR.flfg.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.AR.flfg.ResM = ResM;   % store resm
impulseresponse                             % store IRF
R.AR.flfg.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i)];
 
clearvars -except R config param


clearvars -except R config param

%% 2.3) AR(1) - COMM 
variables_equations_matrices_AR_COMM 
param.init_cond = [0;0;1/param.beta-1;0;0;-(1-param.rho)/param.rho*(1/param.beta-1);0;1/param.beta-1];
 
[D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
[D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.AR.com.k] = regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.AR.com.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.AR.com.ResM = ResM;   % store resm
impulseresponse                             % store IRF
R.AR.com.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i)]; 

clearvars -except R config 


%% 3.0) OUT - COMPUTE RELATIVE WELFARE LOSSES
R.TS.rel_loss.flfg = R.TS.flfg.wloss/R.TS.com.wloss;
R.TS.rel_loss.dis = R.TS.dis.wloss/R.TS.com.wloss;
R.AR.rel_loss.flfg = R.AR.flfg.wloss/R.AR.com.wloss;
R.AR.rel_loss.dis = R.AR.dis.wloss/R.AR.com.wloss;

%% 3.1) OUT - FIGURES - PLOT IMPULSE RESPONSES

R.TS.dis.IRF    = [R.TS.dis.IRF(end,:); R.TS.dis.IRF];
R.TS.com.IRF    = [R.TS.com.IRF(end,:); R.TS.com.IRF];
R.TS.flfg.IRF   = [R.TS.flfg.IRF(end,:); R.TS.flfg.IRF];
R.AR.dis.IRF    = [R.AR.dis.IRF(end,:); R.AR.dis.IRF];
R.AR.com.IRF    = [R.AR.com.IRF(end,:); R.AR.com.IRF];
R.AR.flfg.IRF   = [R.AR.flfg.IRF(end,:); R.AR.flfg.IRF];
R.TS.dis.ResM   = cat(1,R.TS.dis.ResM(end,:,:),R.TS.dis.ResM);
R.TS.com.ResM   = cat(1,R.TS.com.ResM(end,:,:),R.TS.com.ResM);
R.TS.flfg.ResM  = cat(1,R.TS.flfg.ResM(end,:,:),R.TS.flfg.ResM);
R.AR.dis.ResM   = cat(1,R.AR.dis.ResM(end,:,:),R.AR.dis.ResM);
R.AR.com.ResM   = cat(1,R.AR.com.ResM(end,:,:),R.AR.com.ResM);
R.AR.flfg.ResM  = cat(1,R.AR.flfg.ResM(end,:,:),R.AR.flfg.ResM);

T_AR = 50; time_AR = 0:T_AR;
T_TS = 50; time_com = 0:T_TS;

set(0, 'DefaultLineLineWidth', 1.1);

figure()
% Output
subplot(3,2,1); hold on;
plot(time_com,100*R.TS.dis.IRF(time_com+1,1),'color',colours(2),'LineStyle','--')
plot(time_com,100*R.TS.com.IRF(time_com+1,1),'color',colours(1))
plot(time_com,100*R.TS.flfg.IRF(time_com+1,1),'color',colours(12))
ylabel('$$\hat{Y}$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
subplot(3,2,2); hold on;

plot(time_AR,100*R.AR.dis.IRF(time_AR+1,1),'color',colours(2),'LineStyle','--')
plot(time_AR,100*R.AR.com.IRF(time_AR+1,1),'color',colours(1))
plot(time_AR,100*R.AR.flfg.IRF(time_AR+1,1),'color',colours(12))
ylabel('$$\hat{Y}$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)

% Inflation
subplot(3,2,3); hold on;
plot(time_com,400*R.TS.dis.IRF(time_com+1,2),'color',colours(2),'LineStyle','--')
plot(time_com,400*R.TS.com.IRF(time_com+1,2),'color',colours(1))
plot(time_com,400*R.TS.flfg.IRF(time_com+1,2),'color',colours(12))
ylabel('$$\pi$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
subplot(3,2,4); hold on;

plot(time_AR,400*R.AR.dis.IRF(time_AR+1,2),'color',colours(2),'LineStyle','--')
plot(time_AR,400*R.AR.com.IRF(time_AR+1,2),'color',colours(1))
plot(time_AR,400*R.AR.flfg.IRF(time_AR+1,2),'color',colours(12))
ylabel('$$\pi$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)

% Interest rate
subplot(3,2,5); hold on;
plot(time_com,400*R.TS.dis.IRF(time_com+1,3),'color',colours(2),'LineStyle','--')
plot(time_com,400*R.TS.com.IRF(time_com+1,3),'color',colours(1))
plot(time_com,400*R.TS.flfg.IRF(time_com+1,3),'color',colours(12))
ylabel('$$i$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
legend('Discretion','Commitment','FLFG','Orientation','horizontal')
legend boxoff

subplot(3,2,6); hold on;
plot(time_AR,400*R.AR.dis.IRF(time_AR+1,3),'color',colours(2),'LineStyle','--')
plot(time_AR,400*R.AR.com.IRF(time_AR+1,3),'color',colours(1))
plot(time_AR,400*R.AR.flfg.IRF(time_AR+1,3),'color',colours(12))
ylabel('$$i$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
legend('Discretion','Commitment','FLFG','Orientation','horizontal')
legend boxoff
clearvars -except R config