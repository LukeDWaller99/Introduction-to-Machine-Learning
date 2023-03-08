close all
clc
clear all

rewards = [];

for i = 1:11
    for j = 1:4
        rewards(i, j) = rewardFunction(i,j);
    end
end