clear all
clc
close all 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samples = 10000;
data = randn(1,samples);
size(data)
M = mean(data);
S = std(data);

figure
hold on 
title('Dot Plot of Randn function')
plot(data, 'b.')
xlabel('x-axis')
ylabel('y-axis')

bins = 100

figure
hold on
h=title('Histogram of Randn distribution');
h.FontSize=20;

% plot histogram
histogram(data,bins);
h=xlabel('x-axis');
h.FontSize=20;
h=ylabel('y-axis');
h.FontSize=20;

