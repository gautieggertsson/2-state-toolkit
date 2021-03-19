%% TABLE A4. COMPARE RULES IN THE FRBNY DSGE MODEL UNDER A COST PUSH SHOCK 
%% WITHOUT IMPOSING AN EFFECTIVE LOWER BOUND.
% Parametrization is taken from parameters.m files in Examples/nyfed
% Utility calculations are based on equal weighting on an annualised base.
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
close all;
clc;

cfg.root = '../../../';
addpath([cfg.root 'Source']);
addpath([cfg.root 'Replication/Common']);
cfg.path = 'Replication/Appendix/A62';


%% SET PARAMETERS
cfg.models = {'TTR0','TTRP','ATR','SUP','NGDPT','HDNGDPT','TTRS','TTRm1'...
    ,'TTRp1','AIT','NYFEDrule','SDTR','PLT'};

cfg.V       = {'y','pi','R','hat_P','hat_N','yhd','yhdpi'}; % variables to plot
cfg.n_mod   = length(cfg.models); % number of models
cfg.n_var   = length(cfg.V);  % number of vars to plot
cfg.taumax  = 200; % max no. of contingencies
cfg.l2      = 21; % max length of regime 2
cfg.cont    = 32; % contingency to select
cfg.horizon = 55; % time horizon for IRF plots

set(0,'DefaultFigureVisible','off');  % suppress figures


%% INIT CONTAINERS 
R.wl    = zeros(cfg.n_mod,1);
R.e_zlb = zeros(cfg.n_mod,1);
R.c     = zeros(floor((cfg.taumax+cfg.l2)*1.1),cfg.n_var,cfg.n_mod);
R.v     = zeros(cfg.n_mod,3);
R.i     = zeros(cfg.n_mod,2);
R.irf   = zeros(floor((cfg.taumax+cfg.l2)*1.1),cfg.n_var,cfg.n_mod);


for m = 1:length(cfg.models)
    if strcmp(string(cfg.models(m)),'TTR0') || strcmp(string(cfg.models(m)),'TTRm1') || strcmp(string(cfg.models(m)),'TTRp1')
        run(strcat(cfg.root,cfg.path,'/TTR/do_',string(cfg.models(m)),'.m'));
    else
        run(strcat(cfg.root,cfg.path,'/',string(cfg.models(m)),'/do_',string(cfg.models(m)),'.m'));
    end
    
    [R.wl(m), R.e_zlb(m), R.c(:,:,m), R.v(m,:), R.i(m,:), R.irf(:,:,m)] = ...
        out(ResM,IR,k,T_tilde,vars,param,cfg.V,cfg.cont,'nyfed');
    fprintf(strcat(string(cfg.models(m)),' done\n')); pause(0.1);
    clearvars -except R cfg
end


%% PRINT SUMMARY TABLE
T = [R.wl R.v R.i];
T = T./T(11,:);
T(11,:) = [R.wl(11) R.v(11,:) R.i(11,:)];
cfg.mod_lab = {'TTR','TTRP','ATR','SUP','NGDPT','HD-NGDPT','TTRS-1','TTR-1',...
    'TTR+1','AIT','FRBNY Rule','SDTR','PLT'};
T = array2table(T,...
    'VariableNames',{'Welfare Loss','Vol y','Vol \pi','Vol R','Impact y','Impact \pi'},...
    'RowNames',cfg.mod_lab)

clearvars -except R cfg