function [output] = generateUniformDistribution(samples, min, max)

    output = min + (max - min) .* rand(samples, 1);

end