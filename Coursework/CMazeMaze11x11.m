
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all rights reserved
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems
% Plymouth University
% A324 Portland Square
% PL4 8AA
% Plymouth, Devon, UK
% howardlab.com
% 07/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


classdef CMazeMaze11x11
    % define Maze work for RL
    %  Detailed explanation goes here
    
    properties
        
        % parameters for the gmaze grid management
        %scalingXY;
        blockedLocations;
        cursorCentre;
        limitsXY;
        xStateCnt
        yStateCnt;
        stateCnt;
        stateNumber;
        totalStateCnt
        squareSizeX;
        cursorSizeX;
        squareSizeY;
        cursorSizeY;
        stateOpen;
        stateStart;
        stateEnd;
        stateEndID;
        stateX;
        stateY;
        xS;
        yS
        stateLowerPoint;
        textLowerPoint;
        stateName;
        
        % parameters for Q learning
        QValues;
        tm;
        actionCnt;
        
        % added values for use between functions
        avaliableStateIDs
    end
    
    methods
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % constructor to specity maze
        function f = CMazeMaze11x11(limitsXY)
            
            % set scaling for display
            f.limitsXY = limitsXY;
            f.blockedLocations = [];
            
            % setup actions
            f.actionCnt = 4;
            
            % build the maze
            f = SimpleMaze11x11(f);
            
            % display progress
            disp(sprintf('Building Maze CMazeMaze11x11'));
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % build the maze
        function f = SetMaze(f, xStateCnt, yStateCnt, blockedLocations, startLocation, endLocation)
            
            % set size
            f.xStateCnt=xStateCnt;
            f.yStateCnt=yStateCnt;
            f.stateCnt = xStateCnt*yStateCnt;
            
            % compute state countID
            for x =  1:xStateCnt
                for y =  1:yStateCnt
                    
                    % get the unique state identified index
                    ID = x + (y -1) * xStateCnt;
                    
                    % record it
                    f.stateNumber(x,y) = ID;
                    
                    % also record how x and y relate to the ID
                    f.stateX(ID) = x;
                    f.stateY(ID) = y;
                end
            end
            
            % calculate maximum number of states in maze
            % but not all will be occupied
            f.totalStateCnt = f.xStateCnt * f.yStateCnt;
            
            
            % get cell centres
            f.squareSizeX= 1 * (f.limitsXY(1,2) - f.limitsXY(1,1))/f.xStateCnt;
            f.cursorSizeX = 0.5 * (f.limitsXY(1,2) - f.limitsXY(1,1))/f.xStateCnt;
            f.squareSizeY= 1 * (f.limitsXY(2,2) - f.limitsXY(2,1))/f.yStateCnt;
            f.cursorSizeY = 0.5 * (f.limitsXY(2,2) - f.limitsXY(2,1))/f.yStateCnt;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % init maze with no closed cell
            f.stateOpen = ones(xStateCnt, yStateCnt);
            f.stateStart = startLocation;
            f.stateEnd = endLocation;
            f.stateEndID = f.stateNumber(f.stateEnd(1),f.stateEnd(2));
            
            % put in blocked locations
            for idx = 1:size(blockedLocations,1)
                bx = blockedLocations(idx,1);
                by = blockedLocations(idx,2);
                f.stateOpen(bx, by) = 0;
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % get locations for all states
            for x=1:xStateCnt
                for y=1:yStateCnt
                    
                    % start at (0,0)
                    xV = x-1;
                    yV = y-1;
                    
                    % pure scaling component
                    % assumes input is between 0 - 1
                    scaleX =  (f.limitsXY(1,2) - f.limitsXY(1,1)) / xStateCnt;
                    scaleY = (f.limitsXY(2,2) - f.limitsXY(2,1)) / yStateCnt;
                    
                    % remap the coordinates and add on the specified orgin
                    f.xS(x) = xV  * scaleX + f.limitsXY(1,1);
                    f.yS(y) = yV  * scaleY + f.limitsXY(2,1);
                    
                    % remap the coordinates, add on the specified orgin and add on half cursor size
                    f.cursorCentre(x,y,1) = xV * scaleX + f.limitsXY(1,1) + f.cursorSizeX/2;
                    f.cursorCentre(x,y,2) = yV * scaleY + f.limitsXY(2,1) + f.cursorSizeY/2;
                    
                    f.stateLowerPoint(x,y,1) = xV * scaleX + f.limitsXY(1,1);  - f.squareSizeX/2;
                    f.stateLowerPoint(x,y,2) = yV * scaleY + f.limitsXY(2,1); - f.squareSizeY/2;
                    
                    f.textLowerPoint(x,y,1) = xV * scaleX + f.limitsXY(1,1)+ 10 * f.cursorSizeX/20;
                    f.textLowerPoint(x,y,2) = yV * scaleY + f.limitsXY(2,1) + 10 * f.cursorSizeY/20;
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % draw rectangle
        function DrawSquare(f, pos, faceColour)
            % Draw rectagle
            rectangle('Position', pos,'FaceColor', faceColour,'EdgeColor','k', 'LineWidth', 3);
        end
        
        % draw circle
        function DrawCircle(f, pos, faceColour)
            % Draw rectagle
            rectangle('Position', pos,'FaceColor', faceColour,'Curvature', [1 1],'EdgeColor','k', 'LineWidth', 3);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % draw the maze
        function DrawMaze(f)
            figure('position', [100, 100, 1200, 1500]);
            fontSize = 20;
            hold on
            h=title(sprintf('10618407: Maze wth %d x-axis X %d y-axis cells', f.xStateCnt, f.yStateCnt));
            set(h,'FontSize', fontSize);
            
            for x=1:f.xStateCnt
                for y=1:f.yStateCnt
                    pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                    
                    % if location open plot as blue
                    if(f.stateOpen(x,y))
                        DrawSquare( f, pos, 'b');
                        % otherwise plot as black
                    else
                        DrawSquare( f, pos, 'k');
                    end
                end
            end
            
            
            % put in start locations
            for idx = 1:size(f.stateStart,1)
                % plot start
                x = f.stateStart(idx, 1);
                y = f.stateStart(idx, 2);
                pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                DrawSquare(f, pos,'g');
            end
            
            % put in end locations
            for idx = 1:size(f.stateEnd,1)
                % plot end
                x = f.stateEnd(idx, 1);
                y = f.stateEnd(idx, 2);
                pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                DrawSquare(f, pos,'r');
            end
            
            % put on names
            for x=1:f.xStateCnt
                for y=1:f.yStateCnt
                    sidx=f.stateNumber(x,y);
                    stateNameID = sprintf('%s', f.stateName{sidx});
                    text(f.textLowerPoint(x,y,1),f.textLowerPoint(x,y,2), stateNameID, 'FontSize', 20)
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % setup 11x11 maze
        function f = SimpleMaze11x11(f)
            
            xCnt=11;
            yCnt=11;
            
            % specify start location in (x,y) coordinates
            % example only
            startLocation = [1 1];
            
            
            % specify end location in (x,y) coordinates
            % example only
            endLocation=[11 11];
            
            
            % specify blocked location in (x,y) coordinates
            % example only
            f.blockedLocations = [5 1; 9 1;
                                2 2; 3 2;
                                3 3; 4 3; 6 3; 9 3;
                                1 4; 4 4; 9 4;
                                5 5; 7 5; 9 5;
                                3 6; 5 6; 7 6; 9 6;
                                2 7; 3 7; 7 7; 9 7;
                                3 8; 6 8; 7 8; 9 8;
                                3 9; 7 9;
                                7 10;
                                ];
                                
                                
            
            % build the maze
            f = SetMaze(f, xCnt, yCnt, f.blockedLocations, startLocation, endLocation);
            
            % write the maze state
            maxCnt = xCnt * yCnt;
            for idx = 1:maxCnt
                f.stateName{idx} = num2str(idx);
            end
            
            % create a 1x121 vector with the values 1 - 121  
            stateIDs = (1:121);
            
            % create a blank blocked states matrix
            blockedStateIDs =[];
            
            % go through all the blocked states
            for i = 1:length(f.blockedLocations)
                temp = f.blockedLocations(i, :);
                % add all the blocked state ids to a list
                blockedStateIDs = [blockedStateIDs temp(1) + ((temp(2) - 1) * 11)];
            end
            
            f.avaliableStateIDs = [];
            blockedStateIDs = [blockedStateIDs 121]; % add the end postion to the end of the list as it is not a valid starting position
            
%             go through list of all state ids
            for k = 1:length(stateIDs)
%                 if current state id is not a blocked location, add to the avaliable state ids
                if(~ismember(stateIDs(k), blockedStateIDs))
                    f.avaliableStateIDs = [f.avaliableStateIDs stateIDs(k)];
                end
            end
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % reward function that takes a stateID and an action
        function reward = RewardFunction(f, stateID, action)
            
            if (stateID == 120 && action == 2)||(stateID == 110 && action == 1)
                reward = 10;
            else 
                reward = 0;
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function  computes a random starting state
        function startingState = RandomStartingState(f)
                    
            % removes state 121 from avaliable state IDs
            if((max(f.avaliableStateIDs)) == 121)
                f.avaliableStateIDs(end) = [];
            end
            % picks a random value from the avaliable state ids list and
            % returns it
            startingState = f.avaliableStateIDs(randi(numel(f.avaliableStateIDs)));

        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % look for end state
        function endState = IsEndState(f, x, y)
            
            % default to not found
            endState=0;
            
            if x == 11 && y == 11 % if at the endstate, endState = 1
                endState = 1;
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % init the q-table
        function f = InitQTable(f, minVal, maxVal)
            
            % allocate
            f.QValues = zeros(f.xStateCnt * f.yStateCnt, f.actionCnt);
            
            % rand of the values times rand, + minVal offset
            f.QValues = minVal + (maxVal - minVal) * rand(f.xStateCnt * f.yStateCnt, f.actionCnt); 
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % build the transition matrix
        % look for boundaries on the grid
        % also look for blocked state
        function f = BuildTransitionMatrix(f)
            
            % allocate
            f.tm = zeros(f.xStateCnt * f.yStateCnt, f.actionCnt);
           
            
            f.avaliableStateIDs = [f.avaliableStateIDs 121]

            % if the state ID in the transition table is valid, that cell is valid in
            % the transition function, if not, keep as all zeros

            % if value +11 is valid add a val + 11 to the first column
            % if value +1 is valid add a val +1 to the second column
            % if value -11 is valid add a val - 11 to the third column
            % if value -1 is valid add a val -1 to the forth column 
            % else input the value into the column instead
            
            for m = 1:length(f.tm)
                                    
                % if the value is 121, the maze is complete and not transition function
                if(m == 121)
                    f.tm(m, :) = 121;
                    break
                end
                
                % if the sqaure is a valid space, not a blocked space,
                % add it to the transition state table, if it is a blocked
                % space, keep all the values at zero
                if(ismember(m, f.avaliableStateIDs))
                    % if state +11 is valid (going north) add state +11 to transition table
                    if(ismember(m + 11, f.avaliableStateIDs)) 
                        f.tm(m, 1) = m + 11;
                    else %if state + 11 is not valid (not space north) remain in current state
                        f.tm(m, 1) = m;
                    end
                    % if state +1 is valid (going east) add state +1 to transition table
                    if(ismember(m + 1, f.avaliableStateIDs) && ~((mod(m, 11) == 0))) 
                        f.tm(m, 2) = m + 1;
                    else %if state +1 is not valid (no space east) remain in current state
                        f.tm(m, 2) = m;
                    end
                    % if state -11 is valid (going south) add state -11 to transition table
                    if(ismember(m - 11, f.avaliableStateIDs)) 
                        f.tm(m, 3) = m - 11;
                    else %if state -11 is not valid (no space south) remain in current state
                        f.tm(m, 3) = m;
                    end
                    % if state -1 is valid (going west) add state -1 to transition table
                    if(ismember(m - 1, f.avaliableStateIDs) && ~((mod(m, 11) == 1))) 
                        f.tm(m, 4) = m - 1;
                    else %if state -1 is not valid (no space west) remain in current state
                        f.tm(m, 4) = m;
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Greedy action selector
        function action = greedyActionSelector(f, QTable, state, e)
            
            x = rand; %picks a random value between 0 and 1
            
            % if value 'x' is greater than 1 - e, pick random action (Exploration)
            if x > (1 - e) 
                action = randi([1, 4]);
            else
            % if value 'x' is less than 1 - e, pick the value with highest
            % Q value, that is the action to use
                [~, action] = max(QTable(state, :));    
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Update QTable 
        function QValues = updatedQTable(f, QValues, state, action, resultingState, reward, alpha, gamma)
            
            % finds the maximum action value for a next state
            maxValue = max(QValues(resultingState, :));
            % finds the current Q value for the current state and action 
            currentQValue = QValues(state, action);
            
            % updates Q table
            QValues(state, action) = currentQValue + alpha * (reward + (gamma * maxValue) - currentQValue);
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

