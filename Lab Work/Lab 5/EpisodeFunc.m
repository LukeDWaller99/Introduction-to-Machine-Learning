function [Q, steps, sMatrix] = EpisodeFunc(Q, alpha, gamma, explorationRate)

    sMatrix = [];
    steps = 0;
    state = startingState;
    while state ~= 2
        actionState = GreedyActionSelection(Q, state, explorationRate);
        sPrime = transitionFunction(state, actionState);
        reward = rewardFunction(state, actionState);
        Q = updateQ(Q, state, actionState, sPrime, reward, alpha, gamma);
        
        state = sPrime;
        
        steps = steps + 1;
        
        sMatrix = [sMatrix state];
        
    end

end
