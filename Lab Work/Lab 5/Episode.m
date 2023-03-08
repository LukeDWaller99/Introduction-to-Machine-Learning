close all
clc
clear all

% loop that runs until the goal state is reached
running = 1;
steps = 0;
episodes = 10;
Q = initQ();
alpha = 0.001;
gamma = 0.9;
explorationRate = 0.1;  

for i = 1:episodes
    EpisodeFunc(Q, alpha, gamma, explorationRate);
% your code here in code step
% make greedy action selection
% get the next state due to that action
% get the reward from the action on the current state
% update the Q- table
% termination if reaches goal state
% update steps
% up
end
