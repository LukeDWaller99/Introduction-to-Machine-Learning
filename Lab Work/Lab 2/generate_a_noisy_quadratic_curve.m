clear all 
clc
close all 

A = 1.6;
B = 2.5;
C = 6;

noise = randn(1, 100);

x = linspace(-4, 6, 100);

y = A * x.^2 + B * x + C;

y = y + noise;

figure
hold on 
plot(y, 'b.-')