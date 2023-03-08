close all 
clc
clear all

samples = 100000;
min = 5;
max = 10;

[output] = generateUniformDistribution(samples, min, max);

figure
hold on
plot(output, 'b.');
title('Generate Uniform Distribution');
xlabel('x-dimension');
ylabel('y-dimension');
