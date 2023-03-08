function action = GreedyActionSelection(QTable, state, e)
    
    

    if x > (1 - e)
        disp('Exploration');
        action = randi([1, 4]);
    else
        disp('Not Exploring');
        [~, action] = max(QTable(state, :));
    end
end