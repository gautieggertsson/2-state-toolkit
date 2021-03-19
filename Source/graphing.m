%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% GRAPHING FUNCTION

% This function provides a simple routine to plot the impulse responses
% associated with each contingency, as well as the average impulse response
% function. It presents three required arguments:
%  1. IR - The IRF data generated by impulseresponse.m
%  2. var - The vars structure used by the toolkit
%  3. horizon - The time period represented on the x-axis.
% 
% Additionally, the user can pass three optional arguments:
%  4. variables - A cell array with the names (as assigned in param.vars) of
%     the variables to plot. If absent, the function will plot IRFs for all
%     variables in the model.
%  5. cont_data - A matrix containing the impulse response in each contingency,
%     as generated by regime1.m
%  6. cont_num - A scalar or vector specifying the contingencies to plot
% Note that both cont_data and cont_num are required to plot the IRF for
% specific contingencies. If either of the two is missing the code does not
% break, but no contingencies are drawn.
%
% Examples of use:
% (a) graphing(IR,var,30)
% (b) graphing(IR,var,30,'variables',{'pi','y','i','r'})
% (c) graphing(IR,var,30,'cont_data',ResM,'cont_num',1:5:30)
% (d) graphing(IR,var,30,'variables',{'pi','y','i','r'},'cont_data',ResM,'cont_num',1:5:30)

function graphing(IR, var, horizon, varargin)

%% INPUT PARSER
p = inputParser;

addParameter(p,'variables',fieldnames(var),@(x) iscell(x));
addParameter(p,'cont_data',[],@(x) isnumeric(x));
addParameter(p,'cont_num',0,@(x) isnumeric(x));

parse(p,varargin{:});
labels    = p.Results.variables;
cont_data = p.Results.cont_data;
cont_var  = p.Results.cont_num;
clear p;

horizon = min(horizon,size(IR,1));


%% IRF VARS
IRF_vars = zeros(length(labels),1);
for i = 1:length(labels)
    IRF_vars(i) = eval(strcat('var.',labels{i}));
end
clear i

%% GET THE NUMBER OF FIGURES
total_vars = max(size(labels));
total_figs = floor(total_vars/4);
if mod(total_vars,4) ~= 0
    total_figs = total_figs + 1;
end

%% PLOTTING
% Find ident of last figure plot
ex_fig = groot;
ex_fig = size(ex_fig.Children,1);

% If 4 or more subplots
if total_vars >=4
    for i=1:total_figs
        f = i+ex_fig;
        figure(f);
        for j =1:4-mod(4*total_figs,total_vars)*((i*4)>total_vars)
            subplot(2,2,j);
            if and(cont_var > 0, isempty(cont_data) == 0)
                hold on 
                for q = cont_var
                    plot(cont_data(1:horizon,IRF_vars(((i-1)*4+j)),q),'Color',[0.5 0.5 0.5]);
                end
            end
            plot(IR(1:horizon,IRF_vars(((i-1)*4+j))),'Color','r')
            xlabel('time','FontSize',12)
            ylabel(labels((i-1)*4+j),'interpreter','none')
            set(get(gca,'YLabel'),'Rotation',0)
            set(findall(gcf,'-property','FontSize'),'FontSize',8)
            hold off
        end
    end
else
    % If 3 or fewer subplots
    figure()
    for j =1:size(IRF_vars,1) 
        subplot(size(IRF_vars,1),1,j);
        if and(cont_var > 0, isempty(cont_data) == 0)
            hold on
            for q = cont_var
                plot(cont_data(1:horizon,IRF_vars(j),q),'Color',[0.5 0.5 0.5]);
            end
        end
        plot(IR(1:horizon,IRF_vars(j)),'Color','r')
        xlabel('time','FontSize',12)
        ylabel(labels(j),'interpreter','none')
        set(get(gca,'YLabel'),'Rotation',0)
        set(findall(gcf,'-property','FontSize'),'FontSize',8)
        hold off
    end
end
end
