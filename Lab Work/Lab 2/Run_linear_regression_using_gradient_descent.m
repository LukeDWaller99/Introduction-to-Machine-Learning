clear all
clc
close all

samples = 100;

noise = randn(1,samples);

x = linspace(-4, 6, samples);

m0 = 1.6;
c0 = 6;

m = randn(1);
c = randn(1);
iterations = 100;
learningRate = 0.001;

y = m0*x + c0;
y = y + noise;

yInit = m * x + c;

for cidx = 1:iterations
    mGrad = -2 * sum(x .* (y - (m * x + c)));
    cGrad = -2 * sum((y - (m * x + c)));
    m = m - learningRate * mGrad;
    c = c - learningRate * cGrad;
    
    error(cidx) = sum( (y - (m * x + c)).^2);
end 

Yu = m * x + c;


figure
hold on
title('ERROR')
plot(error)

figure
hold on 
title('Raw Noisy Line Data Plot')
plot(x, yInit, 'b-')
plot(x, Yu, 'ro-')
plot(x, y, 'g.-')
legend('Initial Line', 'Solution', 'Data')
xlabel('Data point number')
ylabel('Data point value')