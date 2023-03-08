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

% Generate arm data to train inverse model
% you need to implement this script to run the assignment section 1

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% your script from here onwards

% number of samples used for training 
samples = 10000;

% define lengths of the arm sections and adding into matrix
L1 = 0.4;
L2 = 0.4;
armLen = [L1, L2];

% defining the origin of the plot
origin = [0,0];

%generate 1000 random values between 0 and pi for the arm joint locations
for i = 1:samples
    theta(1, i) = generateUniformDistribution(0, pi, 1, 1);
    theta(2, i) = generateUniformDistribution(0, pi, 1, 1);
end

[point1, point2] = RevoluteForwardKinematics2D(armLen, theta, origin);

% plot training data
figure
hold on
h=title('10618407 - Arm Endpoint Locations');
h.FontSize=20;
h =plot(point2(1,:), point2(2,:), 'b+');
h= plot(origin(1,1), origin(1,2), 'g.', 'MarkerSize', 36);

legend('End points', 'Origin');
h=xlabel('X');
h.FontSize=15;
h=ylabel('Y');
h.FontSize=15;

% saves workspace for other tasks
save('Task_1_workspace'); 
