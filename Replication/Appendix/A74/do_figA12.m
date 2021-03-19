%% FIGURE A.12, A.13, A.14, A.15. TABLE A.7. COMPARE RULES IN THE 3 EQUATION 
%% NEW-KEYNESIAN MODEL UNDER INCREASED PRICE RIGIDITY
% Parametrization is the standard Eggertsson and Woodford (2003). Shocks
% are set to generate a drop in output on impact of 7.5%, and a drop in
% inflation of 0.5% under a Truncated Taylor Rule (TTR). 
% Utility calculations are based on equal weighting on an annualised base.
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
close all;
clc;

cfg.root = '../../../';
addpath([cfg.root 'Source']);
addpath([cfg.root 'Replication/Common']);
cfg.path = 'Replication/Appendix/A74';


%% SET PARAMETERS
cfg.models  = {'OCP','TTR0','PLT','NGDPT','HDNGDPT','SDTR','TTRP','ATR','SUP','TTRS','TTRm1','AIT','FLFG'};
cfg.V       = {'x','pi','i','p','ngdp','yhd','yhdpi'}; % variables to plot
cfg.taumax  = 400;          % max no. of contingencies
cfg.l2      = 50;           % max length of regime 2
cfg.cont    = 10;           % contingency to select
cfg.horizon = 20;           % time horizon for IRF plots

set(0,'DefaultFigureVisible','on');  % restore figures

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
T = [R.wl R.e_zlb R.v R.i];
T = T./T(1,:);
T(1,:) = [R.wl(1) R.e_zlb(1) R.v(1,:) R.i(1,:)];
cfg.mod_lab  = {'OCP','TTR','PLT','NGDPT','HD-NGDPT','SDTR',...
    'TTRP','ATR','SUP','TTRS-1','TTR-1','AIT','FLFG'};
T = array2table(T,...
    'VariableNames',{'Welfare Loss','E[ZLB]','Vol x','Vol \pi','Vol i','Impact x','Impact \pi'},...
    'RowNames',cfg.mod_lab)


%% RESCALE IMPULSE RESPONSES INTO ANNUAL RATES, PERCENTAGE POINTS
N = {'c','irf'};
for i = 1:2
    eval(strcat('R.',string(N(i)),'(:,1,:) = 100*R.',string(N(i)),'(:,1,:);'))  % output gap
    eval(strcat('R.',string(N(i)),'(:,2,:) = 400*R.',string(N(i)),'(:,2,:);'))  % inflation
    eval(strcat('R.',string(N(i)),'(:,3,:) = 400*R.',string(N(i)),'(:,3,:);'))  % nominal rate
    eval(strcat('R.',string(N(i)),'(:,4,:) = 100*R.',string(N(i)),'(:,4,:);'))  % price level
    eval(strcat('R.',string(N(i)),'(:,5,:) = 100*R.',string(N(i)),'(:,5,:);'))  % nominal GDP
    eval(strcat('R.',string(N(i)),'(:,6,:) = 100*R.',string(N(i)),'(:,6,:);'))  % cum nominal GDP
    eval(strcat('R.',string(N(i)),'(:,7,:) = 100*R.',string(N(i)),'(:,7,:);'))  % cum nominal GDP w/inflation
end
clearvars i


%% SETTINGS FOR FIGURES
var_labA = {'\hat{Y}','\pi','i'};
var_labB = {'\hat{P}','\hat{N}','\hat{\Gamma}','\hat{D}'};

mod_base  = [1 2 5 6 8 9];
col_base  = [1 2 5 7 9 11];
line_base = {'-' '--' ':' '-' '-.' '--'};

mod_extra  = [3 4 7 10:13];
col_extra  = [3 4 6 10 8 12 13];
line_extra = {'-' '-.' ':' '-.' '-.' '--' ':'};


%% ADD STEADY STATE VALUE AS INITIAL ONE (FOR SOME VARIABLES)
n = {'p','ngdp','yhd','yhdpi'}; % variables w/o this correction
nc = zeros(1,length(n));
for i = 1:length(n)
    nc(i) = find(strcmp(cfg.V,n(i))); % find their position
end

for i = 1:2
    eval(strcat('R.',string(N(i)),' = cat(1,R.',string(N(i)),'(end,:,:),R.',string(N(i)),');'))
    eval(strcat('R.',string(N(i)),'(1,nc,:) = 0;'))
end
clearvars i


%% PLOT THE 'cont' CONTINGENCY IN EACH MODEL

%-- Group Baseline Rules
PanelA = R.c(:,1:3,mod_base);
PanelB = R.c(:,4:7,mod_base);

% Baseline table, first 3 vars (Panel A)
graph_models(PanelA,cfg.horizon,var_labA,cfg.mod_lab(mod_base),col_base,line_base);

% Baseline table, last 4 vars (Panel B)
graph_models(PanelB,cfg.horizon,var_labB,cfg.mod_lab(mod_base),col_base,line_base);


%-- Group Other Rules (for appendix)
PanelA = R.c(:,1:3,mod_extra);
PanelB = R.c(:,4:7,mod_extra);

% Other rules table, first 4 vars (Panel A)
graph_models(PanelA,cfg.horizon,var_labA,cfg.mod_lab(mod_extra),col_extra,line_extra);

% Other rules table, last 4 vars (Panel B)
graph_models(PanelB,cfg.horizon,var_labB,cfg.mod_lab(mod_extra),col_extra,line_extra);
clear PanelA PanelB


%% PLOT THE AVERAGE IMPULSE RESPONSE IN EACH MODEL (APPENDIX)

%-- Group Baseline Rules
PanelA = R.irf(:,1:3,mod_base);
PanelB = R.irf(:,4:7,mod_base);

% Baseline table, first 4 vars (Panel A)
graph_models(PanelA,cfg.horizon,var_labA,cfg.mod_lab(mod_base),col_base,line_base);

% Baseline table, last 4 vars (Panel B)
graph_models(PanelB,cfg.horizon,var_labB,cfg.mod_lab(mod_base),col_base,line_base);

%-- Group Other Rules
PanelA = R.irf(:,1:3,mod_extra);
PanelB = R.irf(:,4:7,mod_extra);

% Other rules table, first 4 vars (Panel A)
graph_models(PanelA,cfg.horizon,var_labA,cfg.mod_lab(mod_extra),col_extra,line_extra);

% Other rules table, last 4 vars (Panel B)
graph_models(PanelB,cfg.horizon,var_labB,cfg.mod_lab(mod_extra),col_extra,line_extra);
clearvars -except R cfg