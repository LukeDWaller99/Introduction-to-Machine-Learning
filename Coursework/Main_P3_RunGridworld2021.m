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
% 22/09/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find path through maze
% you need to expand this script to run the assignment section 3

close all
clear all
clc

% YOU NEED TO DEFINE THESE VALUES
limits = [0 1; 0 1;];

% build the maze
maze = CMazeMaze11x11(limits);

% draw the maze
maze.DrawMaze();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOU NEED TO DEFINE THESE VALUES
% init the q-table
minVal = 0.001;
maxVal = 0.1;

% test values
state = 1;
action = 1;
e = 0.1;
alpha = 0.2;
gamma = 0.9;
trials = 1000;
episodes = 1000;
terminationState = 121;
optimisedQTable = [];

stateplot = [];
pathTaken = [];

% build the transition matrix
maze = maze.BuildTransitionMatrix();
% print out values
maze.tm;

% Runing Q Learning

for trialIndex = 1:trials
    maze = maze.InitQTable(minVal, maxVal);
    for episodeIndex = 1:episodes
        startingState = maze.RandomStartingState();
        state = startingState;
        
        isRunning = 1;
        numberOfSteps = 1;
        
        while(isRunning)
            
            %greedy action selection
            action = maze.greedyActionSelector(maze.QValues, state, e);
            
            % resulting state
            resultingState = maze.tm(state, action);
            
            %sort out reward function
            reward = maze.RewardFunction(state, action);
            
            maze.QValues = maze.updatedQTable(maze.QValues, state, action, resultingState, reward, alpha, gamma); 
            
            %termination of learning
            if(state == terminationState)
                stepsAcrossTrials(trialIndex, episodeIndex) = numberOfSteps;
                isRunning = 0;
                break % terminate current episode 
            end
            
            % update the steps
            numberOfSteps = numberOfSteps + 1;
            
            %update the current state 
            state = resultingState;
        end
    end
end

optimisedQTable = maze.QValues;


isRunning = 1;
state = 1;
finalNumberOfSteps = 1;
statePlot = [];

while(isRunning)
    
    for stepNumber = 1:21
        pathTaken(stepNumber) = state;
        
        % create a 2xN matrix, N is the steps
        
        % plotting x coordinate of pathTaken
        if(mod(state, 11) == 0)
            statePlot(1, finalNumberOfSteps) = 10.5; % this places cross in the centre of the box
        else
            statePlot(1, finalNumberOfSteps) =  (mod(state, 11)) - 0.5; % places cross in centre of the box
        end
        
        % plotting y coordinate of pathTaken
        statePlot(2, finalNumberOfSteps) = ((state - (statePlot(1, finalNumberOfSteps) + 0.5)) / 11) + 0.5; %scales and plots the value in the centre
         
                       
        % greedy action selection - no exploration so e = 0
        action = maze.greedyActionSelector(optimisedQTable, state, 0);
        
        % resulting state
        resultingState = maze.tm(state, action);
        
        % sort out reward function
        reward = maze.RewardFunction(state, action);
        
        % termination of learning
        if(state == terminationState)
            isRunning = 0;
            break % terminate
        end
        
        % update the steps
        finalNumberOfSteps = finalNumberOfSteps + 1;
        
        
        %update the current state
        state = resultingState;
    end
end

statePlot = statePlot / 11;
% Plotting the route on top of the robot arm
maze = CMazeMaze11x11(limits);
maze.DrawMaze();
plot(statePlot(1,:), statePlot(2,:), 'xcy-', 'MarkerSize', 15, 'LineWidth', 5);


for x = 1:episodes
   meanSteps(x) = mean(stepsAcrossTrials(:, x));
   stdSteps(x) = std(stepsAcrossTrials(:, x));
end

figure 
hold on
errorbar(meanSteps, stdSteps);
axis([0 1000 -500 2000])
xlabel('Episode Number');
ylabel('Number of Steps');
title('10618407 - Q-Learning in Operation across Multiple Trials')

startingStateHistVals = [];

for x = 1:1000
     startingStateHistVals = [startingStateHistVals maze.RandomStartingState()];
end

figure 
histogram(startingStateHistVals, 121)
title('10618407: Histogram of Starting States');
xlabel('State Number');
ylabel('State Frequency');

save('Task_3_workspace'); % saves workspace for other tasks
