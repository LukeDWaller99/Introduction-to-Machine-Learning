clear all 
clc
close all 

A = 1.6;
B = 2.5;
C = 6;
samples = 100;

noise = randn(1, 100);

x = linspace(-4, 6, 100);

y = A * x.^2 + B * x + C;

xLin = [x; ones(1,samples);];
Quad = [x .*x; x; ones(1,samples);];

y = y + noise;

figure
hold on 
plot(x, y, 'b.-')

r = regress(y', xLin');
rQuad = regress(y', Quad');
yReg = r(1) * x + r(2);
yRegQuad = rQuad(1) * x.^2 + rQuad(2) * x + rQuad(3);

plot(x, yReg, 'ro-')
plot(x, yRegQuad, 'g--')

legend('Quadratic', 'Linear Reg', 'Quad Reg')