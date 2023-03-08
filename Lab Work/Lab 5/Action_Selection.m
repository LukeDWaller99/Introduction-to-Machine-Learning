close all 
clc
clear all

Q = initQ;

for i = 1:11
    disp(i)
    output(i) = GreedyActionSelection(Q, i, 0.1);
    
end