clear all
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples = 200;
data = rand(samples,1);
size(data)
data(1:10)

figure
hold on 
title('Dot Plot of Rand function')
plot(data, 'b.')
xlabel('x-axis')
ylabel('y-axis')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plotting histogram
samples = 1000000;

data = rand(samples,1);
size(data)
data(1:10)

bins = 100;
figure
hold on
h=title('Histogram of uniform distribution');
h.FontSize=20;

% plot histogram
histogram(data,bins);
h=xlabel('x-axis');
h.FontSize=20;
h=ylabel('y-axis');
h.FontSize=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plotting histogram
samples = 1000000;

data = randn(samples,1);
size(data)
data(1:10)

bins = 100;
figure
hold on
h=title('Histogram of guassian distribution');
h.FontSize=20;

% plot histogram
histogram(data,bins);
h=xlabel('x-axis');
h.FontSize=20;
h=ylabel('y-axis');
h.FontSize=20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rand function picks values between 0 and 1

% The plots are as expected, the uniform distribution is mostly flat and
% even
% The gaussian follows the shape of a bell curve which is to be expected
% The more bins that are used for the histograms has a large effect on how
% good the data looks, for the gaussian the more bins the better, for the
% uniform distribution having less bins would make the data appear to be flatter 

