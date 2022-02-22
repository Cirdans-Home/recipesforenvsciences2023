%% Parameter fitting

clear; clc; close all;

%% Rumford of Bavaria

data = [ 4 126 % Time (min) and Temperature (°F)
  5 125
  7 123
  12 120
  14 119
  16 118
  20 116
  24 115
  28 114
  31 113
  34 112
  37.5 111
  41 110
];

fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0],...
               'Upper',[Inf],...
               'StartPoint',[1]);
ft = fittype('60 + 70*exp(-a*x)','options',fo);
[curve,gof] = fit(data(:,1),data(:,2),ft);

figure(1)
plot(curve,data(:,1),data(:,2))
xlabel('Time (m)');
ylabel('Temperature (°F)');

%% Chlorine example

data = csvread('chlorine.csv',1,0);

figure(1)
plot(data(:,1),data(:,2),'o')
xlabel('Time (s)');
ylabel('Concentration %');

fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0],...
               'Upper',[Inf,Inf,Inf],...
               'StartPoint',[1 1 1]);
ft = fittype('a*(1-b*exp(-c*x))','options',fo);

[curve,gof] = fit(data(:,1),data(:,2),ft);
ci = confint(curve,0.95);

figure(1)
plot(curve)