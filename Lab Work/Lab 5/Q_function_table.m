close all
clc
clear all 

qTable = initQ();

surf(qTable);
axis([1 4 1 11 0 1]);
view([-35 45]);
xlabel('Action');
ylabel('States');
title('Q Function Table');