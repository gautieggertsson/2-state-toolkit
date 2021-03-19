%% FIGURE 4. COMPARE RULES IN THE 3 EQUATION NEW-KEYNESIAN MODEL UNDER A COST PUSH SHOCK
% Parametrization taken from Eggertsson and Woodford (2003).
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
close all;
clc;

cfg.root = '../';
addpath([cfg.root 'Source']);
addpath([cfg.root 'Replication/Common']);
cfg.path = 'Examples/cost_push';


%% SET PARAMETERS     
cfg.models  = {'OCP','TTR0','HDNGDPT','SDTR'};
cfg.V       = {'x','pi','i','ngdp'}; % variables to plot
cfg.taumax  = 400;          % max no. of contingencies
cfg.l2      = 50;           % max length of regime 2
cfg.cont    = 10;           % contingency to select
cfg.horizon = 20;           % time horizon for IRF plots

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
    if strcmp(string(cfg.models(m)),'TTR0') || strcmp(string(cfg.models(m)),'TTRm1')
        run(strcat(cfg.root,cfg.path,'/TTR/do_',string(cfg.models(m)),'.m'));
    else
        run(strcat(cfg.root,cfg.path,'/',string(cfg.models(m)),'/do_',string(cfg.models(m)),'.m'));
    end
    
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
    eval(strcat('R.',string(N(i)),'(:,4,:) = 100*R.',string(N(i)),'(:,4,:);'))  % nominal GDP
end
clearvars i


%% SETTINGS FOR FIGURES
set(0,'DefaultFigureVisible','on') 
var_lab   = {'\hat{Y}','\pi','i','\hat{N}'};
mod_lab   = {'OCP','TTR','HD-NGDPT','SDTR'};
mod_base  = [1 2 3 4];
col_base  = [1 2 5 7];
line_base = {'-' '--' ':' '-'};


%% ADD STEADY STATE VALUE AS INITIAL ONE (FOR SOME VARIABLES)
nc = find(strcmp(cfg.V,'ngdp')); 
R.c = cat(1,R.c(end,:,:),R.c);
R.c(1,nc,:) = 0;


%% PLOT THE 'cont' CONTINGENCY IN EACH MODEL
graph_models(R.c,cfg.horizon,var_lab,mod_lab,col_base,line_base);
clearvars -except R cfg