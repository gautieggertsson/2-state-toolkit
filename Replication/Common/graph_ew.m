function graph_ew(IR,var,horizon,col_irf,IRF_labels, cont_data, cont_vars)

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
    IRF_labels = fieldnames(var); %labels are just extracted from struct "var"
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

for i=1:total_figs
    figure(i);
    for j =1:4-mod(4*total_figs,total_vars)*((i*4)>total_vars)
        subplot(4,1,j);
        if exist('cont_vars','var') == 1 %if contingencies were passed to function
            hold on % plot them...
            for q = cont_vars
                plot(cont_data(1:horizon,IRF_vars(((i-1)*4+j)),q),'Color',[0.5 0.5 0.5],'LineWidth',0.2);
            end
        end
        plot(IR(1:horizon,IRF_vars(((i-1)*4+j))),'Color',col_irf,'LineWidth',1.5) %... and then plot the IRF itself
        % using locations in IRF_vars. (i-1)*4+j runs from first to
        % last variable filling consequently frames in figures
        if j == 4
        xlabel('Quarters')
        end
        if string(IRF_labels((i-1)*4+j)) == "pi"
            IRF_labels((i-1)*4+j) = "\pi";
        end
        ylabel(strcat('$$',string(IRF_labels((i-1)*4+j)),'$$'),'interpreter','latex')
        set(get(gca,'YLabel'),'Rotation',0)
        set(findall(gcf,'-property','FontSize'),'FontSize',8)
    end
end

end