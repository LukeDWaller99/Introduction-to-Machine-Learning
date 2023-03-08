close all 
clc
clear all 


% class 0
Mean1 = [3; -1];
Sigma1 = [2 4; 4 10];

% class 1
Mean2 = [-3; -1];
Sigma2 = [2 4; 4 10];

% generating training data
trainingSamples = 1000;
[trainingData, trainingTarget] = GenerateGaussianData(trainingSamples, Mean1, Sigma1, Mean2, Sigma2);

% generate testing data
testingSamples = 1000;
[testingData, testingTarget] = GenerateGaussianData(testingSamples, Mean1, Sigma1, Mean2, Sigma2);

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