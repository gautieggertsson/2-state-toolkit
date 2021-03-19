%% FIGURE 8a. U.S. NOMINAL GDP (IN LOGS)
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

clear;
close all;
clc;

url = 'https://fred.stlouisfed.org/';
c = fred(url);
startdate = '01/01/2000';
enddate = '01/01/2020';
series = 'GDP';
d = fetch(c,series,startdate,enddate);
close(c);

data = num2cell(d.Data);
data(:,3) = cellstr(datestr(d.Data(:,1)));

reg_date_lim = datenum('01-Jul-2007'); % end of pre-crisis period

y = log(d.Data(d.Data(:,1)<reg_date_lim,2));
x = [ones(size(y,1),1), transpose(1:size(y,1))];
b = regress(y, x); % estimate coeff of linear trend on the logs

t = transpose(1:size(d.Data,1));
fitted = b(1) + b(2) * t; % fit the trend

%% PLOT
figure()
hold on
y = log(d.Data(:,2));
dates = d.Data(:,1);
plot(dates,y,'color','k')
plot(dates,(fitted(1:length(y))),'linestyle','--','color','k')
hold off
datetick('x', 'yyyy')


%% FIGURE 8b. U.S. CORE PCE EX-FOOD, ENERGY (IN LOGS)

clear;

url = 'https://fred.stlouisfed.org/';
c = fred(url);
startdate = '01/01/2000';
enddate = '01/01/2020';
series = 'PCEPILFE';
d = fetch(c,series,startdate,enddate);
close(c);

data = num2cell(d.Data);
data(:,3) = cellstr(datestr(d.Data(:,1)));

reg_date_lim = datenum('01-Jul-2007'); % end of pre-crisis period

y = log(d.Data(d.Data(:,1)<reg_date_lim,2));
x = [ones(size(y,1),1), transpose(1:size(y,1))];
b = regress(y, x); % estimate coeff of linear trend on the logs

t = transpose(1:size(d.Data,1));
fitted = b(1) + b(2) * t; % fit the trend

%% PLOT
figure()
hold on
y = log(d.Data(:,2));
dates = d.Data(:,1);
plot(dates,y,'color','k')
plot(dates,(fitted(1:length(y))),'linestyle','--','color','k')
hold off
datetick('x', 'yyyy')