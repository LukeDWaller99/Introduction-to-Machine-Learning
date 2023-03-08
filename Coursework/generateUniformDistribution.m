function [output] = generateUniformDistribution(min, max, rows, columns)

    output = min + (max - min) .* rand(rows,columns);

end