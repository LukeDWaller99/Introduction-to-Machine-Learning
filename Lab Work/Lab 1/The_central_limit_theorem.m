clear all
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples = 10000;
data = rand(samples, samples);
size(data)
S = mean(data,2)
data(1:10);

figure
hold on
title('Averaged Data')
plot(S, 'b.')
xlabel('x-axis')
ylabel('y-axis')

bins = 100

figure 
hold on 
title('Histogram of Mean Data')
histogram(S, bins)
xlabel('x-axis')
ylabel('y-axis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The data looks good
% I haved used 10000 samples as this allowed me to open up the graphs but
% still gave a fairly good approximation
% I have used a bin size of 100 as this gave a large enough number of
% results for each bin but also gave a representative average across the
% data