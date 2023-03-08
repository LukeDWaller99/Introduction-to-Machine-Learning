function reward = rewardFunction(state, action)

    if (state == 5) && (action == 3)
        reward = 10;
    else
        reward = 0;
    end
    
end