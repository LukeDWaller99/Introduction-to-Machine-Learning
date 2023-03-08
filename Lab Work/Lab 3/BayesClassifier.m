%Bayesian Function
function [class] = BayesClassifier(X1, X2, mean1, mean2, stdev)
%Class A
%feature1
pA1 = (1/(sqrt(2*pi*(stdev(1,1)*stdev(1,1)))))*exp(-((X1-mean1(1))*(X1-mean1(1)))/(2*stdev(1,1)));
%feature 2
pA2 = (1/(sqrt(2*pi*(stdev(1,1)*stdev(1,1)))))*exp(-((X2-mean1(2))*(X2-mean1(2)))/(2*stdev(1,1)));

%Class B
%feature1
pB1 = (1/(sqrt(2*pi*(stdev(2,2)*stdev(2,2)))))*exp(-((X1-mean2(1))*(X1-mean2(1)))/(2*stdev(2,2)));
%feature2
pB2 = (1/(sqrt(2*pi*(stdev(2,2)*stdev(2,2)))))*exp(-((X2-mean2(2))*(X2-mean2(2)))/(2*stdev(2,2)));

%calc probabilities for each class
PClassA = pA1 * pA2 *0.5;
PClassB = pB1 * pB2 * 0.5;

%assign result based on probabilities
if PClassA > PClassB
    class = 1;
else
    class = 0;
end
