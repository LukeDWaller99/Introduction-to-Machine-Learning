close all 
clc
clear all 

start = [];
for i = 1: 1000
    start(i) = startingState();
end
plot(start, 'b+')