%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all rights reserved
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems
% Plymouth University
% A324 Portland Square
% PL4 8AA
% Plymouth, Devon, UK
% howardlab.com
% 14/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Train a neural network to implement inverse model
% you need to implement this script to run the assignment section 2

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% your script from here onwards

% used to load in the varibales from the workspace from other files
P1Data = load('Task_1_workspace.mat');

% epsiode variables
iterations = P1Data.samples;
tests = 1000;
alpha = 0.01;
hiddenUnits = 10;

% testing dataset
theta = P1Data.theta;
% training dataset
point2 = P1Data.point2;

% intialising the first pass matricies
a2 = zeros(2,1);
net2 = zeros(3,2);
output = 0;

% differentials with respect to W1 and W2 
errGradwrtW1 = zeros(3,2);
errGradwrtW2 = zeros(1,3);

% initialising the wieghts to non-zero values
W1 = generateUniformDistribution(-0.1, 0.1, hiddenUnits, 3);
W2 = generateUniformDistribution(-0.1, 0.1, 2, hiddenUnits + 1);

% Organise training data from P1
x = point2;
xHat = [x; ones(1,iterations)]; % Augmenting the input for bais term
t = theta;

% creating the error and output vectors with a dynamically adjustatable
% length
outputVector = zeros(2, iterations);
errorVector = zeros(2, tests);
averageError = zeros(2, tests);

% implement psuedo code here:
for c = 1:tests
    error = 0; % setting intial error to 0
    for i = 1:iterations
        
        % using the index of variables to train the data
        X = xHat(:, i);
        T = t(:, i);
        net = W1 * X;
        
        a2 = 1./(1+exp(-net)); % Calculate internal activations of layer 1
        a2Hat = [a2; 1;]; % Augment a2 to account for bias term in W2
        net2 = W2 * a2Hat;
        output = net2; % Calculate output activations of layer 2
        
        % calculating the delta terms
        delta3 = -(T-output); % Calculate output layer delta term
        w2bar = W2(:, 1:hiddenUnits);
        delta2 = (w2bar' * delta3) .* a2 .* (1- a2); % Back prop to calculate input (lower) layer delta term
        
        % calculating the differential terms
        errGradwrtW1 = delta2 .* X'; % Calculate error gradient w.r.t. W1
        errGradwrtW2 = delta3 .* a2Hat'; % Calculate error gradient w.r.t. W2
        
        % updating weights
        W1 = W1 - alpha * errGradwrtW1; % Update W1
        W2 = W2 - alpha * errGradwrtW2; % Update W2
        
        % adding to the error term
        error = error + (T - output)' * (T - output);
        outputVector(:, i) = output; %adding the current output to the output vector to allow plotting of the learning
    end
    errorVector(:, c) = error; % adding the error to allow plotting of errors to track training details
end

% averaging the errors for plotting
averageError = errorVector / iterations;

% calc output of net
net2 = W1 * xHat;
a2 = 1 ./(1 + exp(-net2));
len = length(a2);
a2Hat = [a2; ones(1, len)];
outputVector = W2 * a2Hat;

armLen = P1Data.armLen;
origin = P1Data.origin;

% calculate end kinematics (tilda is used as point1 isn't used)
[~, point2] = RevoluteForwardKinematics2D(armLen, outputVector, origin);


figure 
hold on
plot(averageError(1, :), 'g.-');
plot(averageError(2, :), 'k.-');
title("10618407 - P2 Error over iterations");
ylabel("Error Value");
xlabel("Iteration No.");
legend('Error 1', 'Error 2');

figure 
tiledlayout(2, 2)
% top left
nexttile
plot(theta(1, :), theta(2, :), 'b.')
title("10618407 - Random Joing Angle Data");
% top right
nexttile
plot(xHat(1, :), xHat(2, :), 'b.');
title("10618407 - Random Endpoint Data");
% bottom left
nexttile
plot(outputVector(1, :), outputVector(2, :), 'r.');
title("10618407 - Inverse Model Joint Angle");
% bottom right
nexttile
plot(point2(1, :), point2(2, :), 'r.');
title("10618407 - Regenerated Via Inv and Fwd Model Endpoint");

save('Task_2_workspace'); % saves workspace for other tasks