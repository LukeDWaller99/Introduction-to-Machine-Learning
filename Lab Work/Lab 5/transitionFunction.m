function nextState = transitionFunction(state, action)

    gridWorld = [4, 1, 1, 1;...     % position 1
                 2, 2, 2, 2;...     % position 2
                 6, 3, 3, 3;...     % position 3
                 7, 4, 1, 4;...     % position 4
                 9, 5, 5, 2;...     % position 5
                 11, 6, 6, 3;...    % position 6
                 7, 8, 4, 7;...     % position 7
                 8, 9, 8, 7;...     % position 8
                 9, 10, 5, 8;...    % position 9
                 10, 11, 10, 9;...  % position 10
                 11, 11, 6, 9;...   % position 11
                 ];
             
    nextState = gridWorld(state, action);
end