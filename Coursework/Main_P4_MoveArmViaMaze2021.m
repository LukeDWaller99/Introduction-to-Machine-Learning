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

% Move arm through maze
% you need to implement this script to run the assignment section 4

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use maze path locations as inputs for the robot arm inverse kinematic
% model (do this using the inverse kinematic model that we created earlier.
% Use the forwards kinematic function with the angles as inputs to
% calculate the elbow and endpoint positions. 
% The MLP inverse model will not be perfect but try to get it to work as
% well as possible. 
P1Data = load('Task_1_workspace');
P2Data = load('Task_2_workspace');
P3Data = load('Task_3_workspace');

%define limits of the maze
limits = [-0.7 -0.1; -0.2 0.3;];
%draw maze
maze = CMazeMaze11x11(limits);
%drawing maze on arm workspace to check it is workspace of calulated arm
hold on 
maze.DrawMaze();
plot(P1Data.point2(1,:), P1Data.point2(2,:), 'r+');
title('10618407: Maze inside workspace of robot arm');

% scaling the X and Y coordinates for the mapping
scaledXYCoords(1,:) = (P3Data.statePlot(1,:)*(limits(1,2)-limits(1,1))+limits(1,1));
scaledXYCoords(2,:) = (P3Data.statePlot(2,:)*(limits(2,2)-limits(2,1))+limits(2,1));

xHat = [scaledXYCoords; ones(1, length(scaledXYCoords))];

net2 = P2Data.W1 * xHat;
a2 = 1 ./(1+exp(-net2));
len=length(a2);
a2Hat = [a2; ones(1, len)];
outputVector = P2Data.W2 * a2Hat;

armLen = [0.4, 0.4];
origin = [0, 0];
[elbow, hand] = RevoluteForwardKinematics2D(armLen, outputVector, origin);

hold on 
maze.DrawMaze();
h=title('10618407 - Animation of revolute arm moving along path in maze');
h.FontSize=20;
h=xlabel('Horizontal position');
h.FontSize=10;
h=ylabel('Vertical position');
h.FontSize=10;
plot(hand(1,:), hand(2,:), 'y+-', 'Linewidth', 3);
pause(5);

for idx = 1:length(hand)
    xConfig = [origin(1), elbow(1,idx), hand(1,idx)];
    yConfig = [origin(2), elbow(2,idx), hand(2,idx)];
    h1 = plot(xConfig,yConfig, 'g-', 'LineWidth',3);
    h2 = plot(hand(1,idx), hand(2,idx), 'bo','MarkerSize',10, 'MarkerFaceColor', '#E2D3A8');
    h3 = plot(elbow(1,idx), elbow(2,idx), 'wo' , 'MarkerSize',10, 'MarkerFaceColor', 'k');
    h4 = plot(origin(1,1), origin(1,2), 'r+' , 'MarkerSize',10, 'MarkerFaceColor', 'cy');
    pause(0.3);
    delete(h1);
    delete(h2);
    delete(h3);
    delete(h4);
end

save('Task_4_workspace'); % saves workspace for other tasks

