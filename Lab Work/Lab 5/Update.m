close all 
clc
clear all

alpha = 0.2; 
gamma = 0.9;
state = 1;
action = 1; 
Q = initQ;
reward = rewardFunction(state, action);
nextState = transitionFunction(state, action);

QPrime = updateQ(Q, state, action, nextState, reward, alpha, gamma);
disp(Q(state, action));
disp(QPrime(state, action));