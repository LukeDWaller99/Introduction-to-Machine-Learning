% Generate 100 samples points using the equation for a 1D line, y = mx + c
% Using follwoing parameters:
% x-axis from -4 to 6
% m = 1.6
% c = 6

clear all
clc
close all

m = 1.6;
c = 6;

noise = randn(1,100);

x = linspace(-4, 6, 100);

y = m*x + c;
y = y + noise;

figure
hold on 
title('Raw Noisy Line Data Plot')
plot(x, y, 'bo-')
xlabel('Data point number')
ylabel('Data point value')
