%% TABLE A3. COMPARE RULES IN THE 3 EQUATION NEW-KEYNESIAN MODEL UNDER A 
%% COST PUSH SHOCK WITHOUT IMPOSING AN EFFECTIVE LOWER BOUND.
% Parametrization taken from Eggertsson and Woodford (2003).
% Utility calculations are based on equal weighting on an annualised base.
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
close all;
clc;

cfg.root = '../../../';
addpath([cfg.root 'Source']);
addpath([cfg.root 'Replication/Common']);
cfg.path = 'Replication/Appendix/A61';


%% SET PARAMETERS
cfg.models  = {'OCP','TTR0','PLT','NGDPT','HDNGDPT','SDTR','TTRP','ATR','SUP','TTRS','TTRm1','AIT'};
cfg.V       = {'x','pi','i','p','ngdp','yhd','yhdpi'}; % variables to plot
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
    fprintf(strcat(string(cfg.models(m)),' done\n')); pause(0.1);
    clearvars -except R cfg
end


%% PRINT SUMMARY TABLE
T = [R.wl R.v R.i];
T = T./T(1,:);
T(1,:) = [R.wl(1) R.v(1,:) R.i(1,:)];
mod_lab  = {'OCP','TTR','PLT','NGDPT','HD-NGDPT','SDTR',...
    'TTRP','ATR','SUP','TTRS-1','TTR-1','AIT'};
T = array2table(T,...
    'VariableNames',{'Welfare Loss','Vol x','Vol \pi','Vol i','Impact x','Impact \pi'},...
    'RowNames',mod_lab)