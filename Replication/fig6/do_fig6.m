%% FIGURE 6. FIXED LENGTH FORWARD GUIDANCE: 2-STATE MARKOV VS DETERMINISTIC 2-STATE
% This code compares the response to a 'fg_target'-period Forward Guidance
% policy under a 2-state Markov process for the exogenous natural interest
% rate to the same policy under a deterministic 2-state. Under both processes,
% the FLFG tries to replicate commitment (same period of liftoff). The initial
% shock is calibrated in both processes so that it produces a 7.5% drop in
% output on impact if the central bank followed a Taylor rule (TTR)
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clc;
close all;
clear;
addpath('../../Source')
addpath('../Common')


%% 1.0) 2-STATE MARKOV - CONFIGURE
config.taumax       = 400;  % declare the maximum contingency
config.max_length_2 = 50;   % declare the maximum length of regime 2
config.bound        = 0;    % declare the bound for the variable subject to it
config.mono         = 1;    % switch for monotone k-vector


%% 1.1) 2-STATE MARKOV - DISCRETION
target_output = -0.075;
parameters_TS
variables_equations_matrices_DISC

[D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
[D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.TS.dis.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda  = [param.lagr_pi;param.lagr_x]; 
target  = zeros(2,1);
    
R.TS.dis.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.TS.dis.ResM  = ResM; % store resm
impulseresponse        % store IRF
R.TS.dis.IRF   = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i) IR(:,vars.r)];


%% 1.2) 2-STATE MARKOV - FLFG
T = 30;
L = nan(T,1);
k = zeros(config.taumax,1)';
for t = 1:T
    k(2:t) = k(2:t)+ones(t-1,1)';
    
    [D_3,G_3,D_3a]     = regime3(AAA,BBB,param);
    [D_2,G_2]          = regime2(AAA,BBB,D_3a,param,config);
    [~,~, ResM,~,k_TS] = ...
        regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k,'R0_search',0);
    
    ResM_pi = 4*squeeze(ResM(:,vars.pi,:));
    ResM_x  = squeeze(ResM(:,vars.x,:));
    lambda  = [param.lagr_pi;param.lagr_x];
    target  = zeros(2,1);

    L(t) = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
end

% Store optimal FLFG duration (minimal welfare loss)
param.fg_target = find(L == min(L));

% Run optimal FLFG policy
k = zeros(config.taumax,1)';
k(2:param.fg_target) = sort(1:(param.fg_target-1),'descend');

[D_3,G_3,D_3a] = regime3(AAA,BBB,param);
[D_2,G_2]      = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.TS.flfg.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda  = [param.lagr_pi;param.lagr_x]; 
target  = zeros(2,1);
    
R.TS.flfg.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.TS.flfg.ResM  = ResM; % store resm
impulseresponse         % store IRF
R.TS.flfg.IRF   = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i) IR(:,vars.r)];
 
clearvars -except R config param


%% 1.3) 2-STATE MARKOV - COMM 
variables_equations_matrices_COMM 

[D_3,G_3,D_3a]          = regime3(AAA,BBB,param);
[D_2,G_2]               = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.TS.com.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:)); % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda  = [param.lagr_pi;param.lagr_x]; 
target  = zeros(2,1);
    
R.TS.com.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.TS.com.ResM  = ResM; % store resm
impulseresponse        % store IRF
R.TS.com.IRF   = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i) IR(:,vars.r)]; 

clearvars -except R config


%% 2.0) DETERMINISTIC 2-STATE - CONFIGURE
config.taumax       = 10;  % declare the maximum contingency
config.max_length_2 = 50;  % declare the maximum length of regime 2
config.mono         = 0;   % switch for monotone k-vector


%% 2.1) DETERMINISTIC 2-STATE - FIND SHOCK SIZE FOR OUTPUT DROP UNDER DISCRETION
target_output = -0.075;
N = 100;

parameters_DET
variables_equations_matrices_DISC

grid_r = linspace(-0.01,-0.015,N);

E = zeros(N,1);

for i = 1:N
    param.sl = grid_r(i);
    
    [D_3,G_3,D_3a] = regime3(AAA,BBB,param);
    [D_2,G_2]      = regime2(AAA,BBB,D_3a,param,config);
    [~,~,ResM,~,R.DET.dis.k] = ...
        regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);
    
    ResM_x  = squeeze(ResM(:,vars.x,:));    
    E(i) = abs(ResM_x(1,2)-target_output);
end

[~,pos] = min(E);
param.sl = grid_r(pos);
clear grid_r E i pos ResM_x N

[D_3,G_3,D_3a] = regime3(AAA,BBB,param);
[D_2,G_2]      = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.DET.dis.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda  = [param.lagr_pi;param.lagr_x]; 
target  = zeros(2,1);
    
R.DET.dis.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.DET.dis.ResM  = ResM;   % store resm
impulseresponse           % store IRF
R.DET.dis.IRF   = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i) IR(:,vars.r)];


%% 2.2) DETERMINISTIC 2-STATE - OPTIMAL FLFG
T = 30;
L = nan(T,1);
k = zeros(config.taumax,1)';
for t = 1:T
    k(config.taumax) = k(config.taumax)+1;
    
    [D_3,G_3,D_3a]     = regime3(AAA,BBB,param);
    [D_2,G_2]          = regime2(AAA,BBB,D_3a,param,config);
    [~,~, ResM,~,k_TS] = ...
        regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k,'R0_search',0);
    
    ResM_pi = 4*squeeze(ResM(:,vars.pi,:));
    ResM_x  = squeeze(ResM(:,vars.x,:));
    lambda = [param.lagr_pi;param.lagr_x];
    target = zeros(2,1);

    L(t) = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
end

% Store optimal FLFG duration (minimal welfare loss)
param.fg_target = find(L == min(L));

% Run optimal FLFG policy
k = zeros(config.taumax,1)';
k(config.taumax) = param.fg_target;
[D_3,G_3,D_3a] = regime3(AAA,BBB,param);
[D_2,G_2]      = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.DET.flfg.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'k_input',k,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.DET.flfg.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.DET.flfg.ResM = ResM;   % store resm
impulseresponse          % store IRF
R.DET.flfg.IRF = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i) IR(:,vars.r)];
 
clearvars -except R config param


%% 2.3) DETERMINISTIC 2-STATE - COMM
variables_equations_matrices_COMM

[D_3,G_3,D_3a] = regime3(AAA,BBB,param);
[D_2,G_2]      = regime2(AAA,BBB,D_3a,param,config);
[~,~,ResM,~,R.DET.com.k] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,'R0_search',0);

ResM_pi = 4*squeeze(ResM(:,vars.pi,:));   % calculate welfare loss
ResM_x  = squeeze(ResM(:,vars.x,:));
lambda = [param.lagr_pi;param.lagr_x]; 
target = zeros(2,1);
    
R.DET.com.wloss = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
R.DET.com.ResM  = ResM;   % store resm
impulseresponse         % store IRF
R.DET.com.IRF   = [IR(:,vars.x) IR(:,vars.pi) IR(:,vars.i) IR(:,vars.r)]; 

clearvars -except R config 


%% 3.0) OUT - FIGURES - PLOT IMPULSE RESPONSES

% Add steady-state in 1st period
R.TS.dis.IRF    = [R.TS.dis.IRF(end,:); R.TS.dis.IRF];
R.TS.com.IRF    = [R.TS.com.IRF(end,:); R.TS.com.IRF];
R.TS.flfg.IRF   = [R.TS.flfg.IRF(end,:); R.TS.flfg.IRF];
R.DET.dis.IRF   = [R.DET.dis.IRF(end,:); R.DET.dis.IRF];
R.DET.com.IRF   = [R.DET.com.IRF(end,:); R.DET.com.IRF];
R.DET.flfg.IRF  = [R.DET.flfg.IRF(end,:); R.DET.flfg.IRF];
R.TS.dis.ResM   = cat(1,R.TS.dis.ResM(end,:,:),R.TS.dis.ResM);
R.TS.com.ResM   = cat(1,R.TS.com.ResM(end,:,:),R.TS.com.ResM);
R.TS.flfg.ResM  = cat(1,R.TS.flfg.ResM(end,:,:),R.TS.flfg.ResM);
R.DET.dis.ResM  = cat(1,R.DET.dis.ResM(end,:,:),R.DET.dis.ResM);
R.DET.com.ResM  = cat(1,R.DET.com.ResM(end,:,:),R.DET.com.ResM);
R.DET.flfg.ResM = cat(1,R.DET.flfg.ResM(end,:,:),R.DET.flfg.ResM);

T_DET = 50; time = 0:T_DET;
T_TS = 50;  time = 0:T_TS;

set(0, 'DefaultLineLineWidth', 1.1);


%% 3.1) OUT - FIGURES - PLOT 3 CONTINGENCIES SUCH THAT OCP AND FLFG REVERT AT THE SAME TIME
figure()
time   = 0:30;
n_cont = 3;
cont   = [10 16 22];

color_com = 1;
color_dis = 2;
color_flfg = 12;

ResM_com  = squeeze(R.TS.com.ResM(:,3,:));
ResM_flfg = squeeze(R.TS.flfg.ResM(:,3,:));

ResM_com(1,:)  = zeros(1,size(ResM_com,2));
ResM_flfg(1,:) = zeros(1,size(ResM_flfg,2));

% Output

subplot(4,2,1); hold on;
for c = 1:n_cont
    plot(time,100*R.TS.dis.ResM(time+1,1,cont(c)),'color',colours(color_dis),'LineStyle','--')
    plot(time,100*R.TS.com.ResM(time+1,1,cont(c)),'color',colours(color_com))
    plot(time,100*R.TS.flfg.ResM(time+1,1,cont(c)),'color',colours(color_flfg),'LineStyle','-.')
end
ylabel('$$\hat{Y}$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0); 

subplot(4,2,2); hold on;
plot(time,100*R.DET.dis.IRF(time+1,1),'color',colours(color_dis),'LineStyle','--')
plot(time,100*R.DET.com.IRF(time+1,1),'color',colours(color_com))
plot(time,100*R.DET.flfg.IRF(time+1,1),'color',colours(color_flfg),'LineStyle','-.')
ylabel('$$\hat{Y}$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0); 

% Inflation
subplot(4,2,3); hold on;
for c = 1:n_cont
    plot(time,400*R.TS.dis.ResM(time+1,2,cont(c)),'color',colours(color_dis),'LineStyle','--')
    plot(time,400*R.TS.com.ResM(time+1,2,cont(c)),'color',colours(color_com))
    plot(time,400*R.TS.flfg.ResM(time+1,2,cont(c)),'color',colours(color_flfg),'LineStyle','-.')
end
ylabel('$$\pi$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0); 

subplot(4,2,4); hold on;
plot(time,400*R.DET.dis.IRF(time+1,2),'color',colours(color_dis),'LineStyle','--')
plot(time,400*R.DET.com.IRF(time+1,2),'color',colours(color_com))
plot(time,400*R.DET.flfg.IRF(time+1,2),'color',colours(color_flfg),'LineStyle','-.')
ylabel('$$\pi$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0);

% Interest rate
subplot(4,2,5); hold on;
for c = 1:n_cont
    plot(time,400*R.TS.dis.ResM(time+1,3,cont(c)),'color',colours(color_dis),'LineStyle','--')
    plot(time,400*R.TS.com.ResM(time+1,3,cont(c)),'color',colours(color_com))
    plot(time,400*R.TS.flfg.ResM(time+1,3,cont(c)),'color',colours(color_flfg),'LineStyle','-.')

end
ylabel('$$i$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
legend('TTR','OCP','FLFG','Orientation','horizontal')
legend boxoff; 

subplot(4,2,6); hold on;
plot(time,400*R.DET.dis.IRF(time+1,3),'color',colours(color_dis),'LineStyle','--')
plot(time,400*R.DET.com.IRF(time+1,3),'color',colours(color_com))
plot(time,400*R.DET.flfg.IRF(time+1,3),'color',colours(color_flfg),'LineStyle','-.')
ylabel('$$i$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
legend('TTR','OCP','FLFG','Orientation','horizontal')
legend boxoff; 

% Natural r - Committment
subplot(4,2,7); hold on;
for c = 1:n_cont
    plot(time, 400*R.TS.com.ResM(time+1,6,cont(c)),'color',colours(13))
end
ylabel('$$r^n$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0); 

subplot(4,2,8); hold on;
plot(time,400*R.DET.com.IRF(time+1,4),'color',colours(13))
ylabel('$$r^n$$','interpreter','latex')
set(get(gca,'YLabel'),'Rotation',0)
clearvars -except R config;