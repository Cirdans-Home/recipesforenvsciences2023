%% Parameter fitting
% Problem of data fitting for observed retention and conductivity data of 
% crushed Bandalier tuff

clear; clc; close all;

headwcontent = [-293.9 0.165 
-322.5 0.162 
-409.6 0.147 
-453.2 0.139 
-596.6 0.127 
-641.5 0.125 
-801.5 0.116 
-860.1 0.113 
-949.7 0.109 
-1192.0 0.103 
-1298.0 0.101 
-1445.0 0.0988 
-1594.0 0.0963 
-1760.0 0.0915
-1980.0 0.0875];

wcontenthcond = [0.0859 0.000411
0.0912 0.000457
0.0948 0.000719
0.0982 0.00087
0.102 0.00149
0.108 0.00314
0.114 0.00377
0.125 0.00635
0.140 0.018
0.161 0.0303];

figure(1)
subplot(1,2,1)
loglog(headwcontent(:,1),headwcontent(:,2),'x')
xlabel('Metric head')
ylabel('Water content')
subplot(1,2,2)
loglog(wcontenthcond(:,1),wcontenthcond(:,2),'x')
xlabel('Water content')
ylabel('Hydraulic conductivity')