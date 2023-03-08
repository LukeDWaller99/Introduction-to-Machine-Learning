clear all
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate 2 cluster Guassian dataset 
% 1. Generate training and testing datasets

% swt mean and covariance for class 0
Mean1 = [3; -1;];
Sigma1 = [2 4; 4 10;];

% set mean and covaraince for class 1
Mean2 = [-3; -1;];
Sigma2 = [2 4; 4 10;];

%generate training and testing data set

trainingSamples = 10000;
testingSamples = 10000;

[trainingData, trainingTarget]  = GenerateGaussianData(trainingSamples, Mean1, Sigma1, Mean2, Sigma2);
[testingData, testingTarget]    = GenerateGaussianData(testingSamples, Mean1, Sigma1, Mean2, Sigma2);
%[uniformData]                   = ((rand(1,testingSamples)-0.5)*20);

data = trainingData;
targets = trainingTarget;

fidx1 = find(targets(1,:) == 1);
c1data = data(:,fidx1);

fidx2 = find(targets(1,:) == 0);
c2data = data(:,fidx2);

figure 
hold on
plot(c1data(1,:), c1data(2,:), 'ro');
plot(c2data(1,:), c2data(2,:), 'b+');
xlabel('x-dimension');
ylabel('y-dimension');
title('Ploting class1 patterns in red and class2 patterns in blue');
legend('Class 1', 'Class 2');

c1mean1 = mean(c1data(1,:), 'all');
c1mean2 = mean(c1data(2,:), 'all');
c2mean1 = mean(c2data(1,:), 'all');
c2mean2 = mean(c2data(2,:), 'all');

c1mean = [c1mean1, c1mean2];
c2mean = [c2mean1, c2mean2];

covariance = cov(c1data, c2data);

newSigma = [sqrt(covariance(1,1)) 0; 0 sqrt(covariance(2,2))];

[newTestingData, newTestingTarget] = GenerateGaussianData(trainingSamples, c1mean', newSigma, c2mean', newSigma); 

data = newTestingData;
targets = newTestingTarget;

fidx1 = find(targets(1,:) == 1);
newc1data = data(:,fidx1);

fidx2 = find(targets(1,:) == 0);
newc2data = data(:,fidx2);

figure 
hold on
plot(newc1data(1,:), newc1data(2,:), 'ro');
plot(newc2data(1,:), newc2data(2,:), 'b+');
xlabel('x-dimension');
ylabel('y-dimension');
title('Niave Bayes Datset Representation');
legend('Class 1', 'Class 2');
