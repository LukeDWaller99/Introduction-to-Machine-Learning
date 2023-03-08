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
trainingSamples = 10000;
[trainingData, trainingTarget] = GenerateGaussianData(trainingSamples, Mean1, Sigma1, Mean2, Sigma2);

% generate testing data
testingSamples = 10000;
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

XHat = [trainingData; ones(1, length(trainingData))];
WHat = rand(1,3); 
T = trainingTarget(1,:);

learningRate = 0.0001;
counter = 0;
error = [];

for i = 1:10
    for n = 1:2*trainingSamples
        
        X = XHat(:,n);
        W = WHat;
        t = T(n);

        net = W * X;
        eWRTw = -(t - net)*X';
        W = W - learningRate * eWRTw;
        error(n) = (t - net)*(t - net)';
        counter = counter + 1;
        
    end
end

figure 
hold on
plot(error, 'b.-');
