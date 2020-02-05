%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% GRAPHING FUNCTION

% This function requires three arguments: IRF data, var struct (that contains
% var names and, hence, locations) and horizon (e.g. how many periods to plot).
% With these 3 function will plot all variables with correct labels at the 
% prespecified horizon. Additionally, the user can pass:
% (1) a particular variables that one wants to plot
% (2)  a bundle of "contingencies data + what contingencies I need" to plot
% them too.

% The function assumes, that the data presents time on the rows and variables
% in columns.

% Examples of usage:
% (1) graphing(IR,var,30)
% (2) graphing(IR,var,30,["pi","y","i","r"])
% (3) graphing(IR,var,30,ResM,[1:5:30])
% (4) graphing(IR,var,30,["pi","y","i","r"],ResM,[1:5:30])

function graphing(IR, var, horizon, IRF_labels, cont_data, cont_vars)

%% GET THE NUMBERS OF VARIABLES
if exist('IRF_labels','var') == 1 & isa(IRF_labels, 'string') == 0 %this condition catches situation when you do
    % want to pass contingencies to function but do not pass the list of
    % particular variables (e.g. example (3))
    cont_vars = cont_data;
    cont_data = IRF_labels;
    clear IRF_labels;
end

if exist('IRF_labels','var') == 0 %if particular variables were not passed to function
    total_vars = size(IR,2); %then total number of variables = all variables
    IRF_vars = 1:total_vars; %locations are just columns of each variable
    IRF_labels = fieldnames(var);%labels are just extracted from struct "var"
else
    total_vars = size(IRF_labels,2); %particular variables were passed to function
    IRF_vars = ones(1,total_vars); %total number of variables is inferred
    for i = 1:total_vars %and location of each variable is found using the passed names of vars
        IRF_vars(i) = eval(strcat('var.',IRF_labels(i)));
    end
end

%% GET THE NUMBER OF FIGURES
total_figs = floor(total_vars/4);
if mod(total_vars,4) ~= 0
    total_figs = total_figs + 1;
end

%% PLOTTING
if total_vars >=4 %% if >=4 charts to plot
    for i=1:total_figs
        figure(i);
        for j =1:4-mod(4*total_figs,total_vars)*((i*4)>total_vars) %j runs from 1 to 4 except
            % for the last figure when it runs from 1 to the number of
            % remaining charts
            subplot(2,2,j);
            if exist('cont_vars','var') == 1 %if contingencies were passed to function
                hold on % plot them...
                for q = cont_vars
                    plot(cont_data(1:horizon,IRF_vars(((i-1)*4+j)),q),'Color',[0.5 0.5 0.5]);
                end
            end
            plot(IR(1:horizon,IRF_vars(((i-1)*4+j))),'Color','r') %... and then plot the IRF itself
            % using locations in IRF_vars. (i-1)*4+j runs from first to
            % last variable filling consequently frames in figures
            xlabel('time','FontSize',12)
            ylabel(IRF_labels((i-1)*4+j))
            set(findall(gcf,'-property','FontSize'),'FontSize',8)
        end
    end
    
else % if <4 charts to plot
    
    for j =1:size(IRF_vars,2)
        
        subplot(size(IRF_vars,2),1,j); % adjust num of frames to 1,2 or 3
        
        if exist('cont_vars','var') == 1
            hold on
            for q = cont_vars
                plot(cont_data(1:horizon,IRF_vars(j),q),'Color',[0.5 0.5 0.5]);
            end
        end
        plot(IR(1:horizon,IRF_vars(j)),'Color','r')
        xlabel('time','FontSize',12)
        ylabel(IRF_labels(j))
        set(findall(gcf,'-property','FontSize'),'FontSize',8)
    end
    
end
end