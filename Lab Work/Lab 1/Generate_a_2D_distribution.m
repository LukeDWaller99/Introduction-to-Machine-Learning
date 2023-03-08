clear all
clc
close all 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samples = 1000

data = randn(2, samples);

size(data)

figure
hold on 
title('Dot Plot of Randn function of a 2 by n')
plot(data(1,:),data(2,:), 'b.')
xlabel('x-axis')
ylabel('y-axis')

M = mean(data,2)

C = cov(data')