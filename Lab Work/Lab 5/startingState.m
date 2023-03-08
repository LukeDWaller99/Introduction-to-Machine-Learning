function start = startingState()
  
    startingMatrix = [1, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    start = startingMatrix(randi(numel(startingMatrix)));

end
