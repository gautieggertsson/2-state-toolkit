function graph_models(data_cube,T,var_labels,model_labels,col,lstyles,varargin)

% Input handler
p = inputParser;

addParameter(p,'nyfed',0,@(x) isnumeric(x));
addParameter(p,'startstring','07-03');  %note: startstring has to be 'yy-qq'
addParameter(p,'add_data',0,@(x) isnumeric(x));
addParameter(p,'data_select',[1:7]); %choose which data to plot from array observations

parse(p,varargin{:});
nyfed       = p.Results.nyfed;
startstring = p.Results.startstring;
add_data    = p.Results.add_data;
data_select = p.Results.data_select;
n_var       = size(data_cube,2);
n_mod       = size(data_cube,3);
clear p varargin;

if nyfed == 0
    
    time = 0:T;
    
    figure()
    for v = 1:n_var
        subplot(n_var,1,v)
        hold on;
        c = 1;
        for m = 1:n_mod
            current_line = plot(time, data_cube(1:T+1,v,m),...
                'Color',colours(col(c)),...
                'LineStyle',string(lstyles(c)));
            current_line(1).LineWidth = 1;
            c = c + 1;
        end
        ylabel(strcat('$$',string(var_labels(v)),'$$'),'interpreter','latex')
        set(get(gca,'YLabel'),'Rotation',0)
        
    end
    xlabel('Quarters');
    legend(model_labels, 'Location', 'best','Orientation','horizontal');
    legend boxoff
    
elseif nyfed == 1
    
    %following lines determine appropriate enddate according to T input
    sub1 = startstring(1:2); %extract start year from string input; this step requires string input to be of certain format
    sub2 = startstring(4:5); %extract start month from string input; this step requires string input to be of certain format
    
    sub1 = str2double(sub1); %turn into numeric
    sub2 = str2double(sub2);
    
    yrd  = floor(T/4); %determine how many years to add
    qrd  = T-yrd*4;   %determine how many quarters to add
    
    sub1 = sub1 + yrd;   %add years
    sub2 = sub2 + qrd;   %add quarters
    
    if sub2 > 4              %adjust years again if quarters larger 4
        yrd  = floor((sub2-1)/4);
        qrd  = sub2 - yrd*4;
        
        sub1 = sub1 + yrd;
        sub2 = qrd;
    end
    
    if sub1  < 10
        endstring = [' 0' num2str(sub1) '-0' num2str(sub2) ' '];
    else
        if sub1 > 99
            disp('error date change century')
            return
        end
        endstring = [' ' num2str(sub1) '-0' num2str(sub2) ' '];
    end
    
    startdate = datenum(startstring,'yy-qq');
    enddate   = datenum(endstring,'yy-qq');
    time      = linspace(startdate,enddate,T+1);
    
    % get data
    if add_data == 1
        load('GDP_data.mat')
        load('inflation_data.mat')
        load('interest_data.mat')
        load('ngdp_data');
        load('plevel_data');
        load('ngdpi_data');
        load('gamma_data');
        load('D_data');
        %load('investment_data.mat') var name: investment
        observations      = zeros(49,8);
        startidx          = 11;
        observations(:,1) = GDP_deviations(startidx:end); %start from Q1 2008; Q3 2019
        observations(:,2) = inflation(startidx:end);
        observations(:,3) = interest(startidx:end);
        observations(:,4) = price_level(startidx:end)-price_level(startidx);
        observations(:,5) = ngdp_implied(startidx:end)-ngdp_implied(startidx);
        observations(:,6) = gamma_index(startidx:end)-gamma_index(startidx);
        observations(:,7) = D_index(startidx:end)-D_index(startidx);
    end
    
    figure()
    for v = 1:n_var
        subplot(n_var,1,v)
        hold on;
        c = 1;
        for m = 1:n_mod
            current_line = plot(time, data_cube(1:T+1,v,m),...
                'Color',colours(col(c)),...
                'LineStyle',string(lstyles(c)));
            current_line(1).LineWidth = 1;
            c = c + 1;
        end
        
        if add_data == 1
            if n_var == 4
            current_line = plot(time(1:size(observations,1)),observations(:,data_select(v+3)),'r:');
            current_line(1).LineWidth = 1.5;
            else
            current_line = plot(time(1:size(observations,1)),observations(:,data_select(v)),'r:');
            current_line(1).LineWidth = 1.5;
            end    
        end
        
        ylabel(strcat('$$',string(var_labels(v)),'$$'),'interpreter','latex')
        set(get(gca,'YLabel'),'Rotation',0)
        
        datetick('x',17)
        xlim([startdate enddate])      
    end
    if add_data == 0
        legend(model_labels, 'Location', 'best','Orientation','horizontal');
    else
        ghelper = model_labels;
        gind = size(ghelper,2) +1;
        ghelper{gind} = 'data';
        legend(ghelper, 'Location', 'best','Orientation','horizontal');
    end
    legend boxoff
    
end
end