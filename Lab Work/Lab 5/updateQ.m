function QTableNew = updateQ(QTable, state, action, resultingState, reward, alpha, gamma)

   QTableNew(state, action) = QTable(state, action) + (alpha * (reward + (gamma * max(QTable(resultingState, :)) - QTable(state, action))));
    
end