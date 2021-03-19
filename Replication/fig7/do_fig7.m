%% FIGURE 7. COMPARE ODYSSIAN AND DELPHIC FIX-LENGTH FORWARD GUIDANCE
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
close all;
clc;

cfg.root = '../../';
addpath([cfg.root 'Source']);
addpath([cfg.root 'Replication/Common']);


%% SET PARAMETERS   
cfg.models  = {'TTR','ODY','DELPH'};
cfg.V       = {'x','pi','i','r'}; % variables to plot
cfg.taumax  = 400; % max no. of contingencies
cfg.l2      = 50;  % max length of regime 2
cfg.cont    = 10;  % contingency to select
cfg.horizon = 12;  % time horizon for IRF plots

set(0,'DefaultFigureVisible','off'); % suppress figures


%% INIT CONTAINERS 
cfg.n_mod   = length(cfg.models); % number of models
cfg.n_var   = length(cfg.V);  % number of vars to plot

R.wl    = zeros(cfg.n_mod,1);
R.e_zlb = zeros(cfg.n_mod,1);
R.c     = zeros(floor((cfg.taumax+cfg.l2)*1.1),cfg.n_var,cfg.n_mod);
R.v     = zeros(cfg.n_mod,3);
R.i     = zeros(cfg.n_mod,2);
R.irf   = zeros(floor((cfg.taumax+cfg.l2)*1.1),cfg.n_var,cfg.n_mod);


%% RUN ALL MODELS AND STACK RESULTS
for m = 1:cfg.n_mod
    run(strcat('./',string(cfg.models(m)),'/do_',string(cfg.models(m)),'.m'));
     
    [R.wl(m),R.e_zlb(m),R.c(:,:,m),R.v(m,:),R.i(m,:),R.irf(:,:,m)] = ...
        out(ResM,IR,k,T_tilde,vars,param,cfg.V,cfg.cont,'eqnk');
    clearvars -except R cfg
end


%% RESCALE IMPULSE RESPONSES INTO ANNUAL RATES, PERCENTAGE POINTS
N = {'c','irf'};
for i = 1:2
    eval(strcat('R.',string(N(i)),'(:,1,:) = 100*R.',string(N(i)),'(:,1,:);'))  % output gap
    eval(strcat('R.',string(N(i)),'(:,2,:) = 400*R.',string(N(i)),'(:,2,:);'))  % inflation
    eval(strcat('R.',string(N(i)),'(:,3,:) = 400*R.',string(N(i)),'(:,3,:);'))  % nominal rate
    eval(strcat('R.',string(N(i)),'(:,4,:) = 400*R.',string(N(i)),'(:,4,:);'))  % natural rate
end
clearvars i

for i = 1:2
    eval(strcat('R.',string(N(i)),' = cat(1,R.',string(N(i)),'(end,:,:),R.',string(N(i)),');'))
end
clearvars i


%% SETTINGS FOR FIGURES

set(0,'DefaultFigureVisible','on') 
var_lab = {'\hat{Y}','\pi','i','r^n'};
cfg.mod_lab  = {'TTR','Odyssean','Delphic'};

mod_base  = [1 2 3];
col_base  = [2 7 12];
line_base = {'--' '-' ':'};


%% PLOT THE 'cont' CONTINGENCY IN EACH MODEL
graph_models(R.c,cfg.horizon,var_lab,cfg.mod_lab,col_base,line_base);
clearvars -except R cfg