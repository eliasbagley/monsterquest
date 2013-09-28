%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Elias Bagley
%   Date:   1/29/2012
%   CS 4500 Senior Capstone Project
%
%   This function handles the button presses when pressed over a figure.
%
%   input: button, the ascii number of the button that was pressed
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch button
    case 13 %enter
        if selectMethod == 0 || isempty(x)
            prevFlag = flag;
            flag = menu('Choose a tileset', menuChoices);
            continue; % goes back to the main loop
        end
    case 'o'
        if flag == 0 % only allow multi pt selection if we're on the map
            selectMethod = 1;
            fprintf('Manual Obstacle Selection Mode: ON\n');
        end
        continue;
    case 'q' %this doesn't really work right now
        % when the user hits 'q', it will save state and return
        %saveState;
        continue; %deprecated
        fprintf('Goodbye\n');
        return; % exits the program
    case 'b'
        temp = flag;
        flag = currentTileset; % just go back to the current tileset to select again
        prevFlag = temp;
        fprintf('Going back to current tileset...\n');
        continue; % go back to the main loop
    case 's'
        % save both parts of the double
        saveToLocalStruct;
        set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr, ' Saving..'));
        fprintf('Saving.. don''t close the program\n');
        saveState(saveDir, zoneStruct);
        saveState(otherSaveDir, zoneStruct2);
        fprintf('Saving done!\n');
        set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr, ' Saving Done'));
        continue; % goes back to the main loop
    case '1'
        currentLayer = 1; % Base-Brown
        layerStr = 'Base Layer';
        fprintf('switching to base layer...\n');
        if eraser
            oldColor = [139 69 19]/255.0;
            set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr), 'Color', [.7 0 0]);
        else
            set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr), 'Color', [139 69 19]/255.0);
        end
        
        continue;
    case '2' % Obstacle-Orange
        currentLayer = 2;
        layerStr = 'Obstacle Layer';
        fprintf('switching to obstacle layer...\n');
        if eraser
            oldColor = [255 140 0]/255.0;
            set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr), 'Color', [.7 0 0]);
        else
            set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr), 'Color', [255 140 0]/255.0);
        end
        continue;
    case 'u' % undo function
        if flag == 0 % only allow undoing on the map
            
            if curr == 1 % don't undo if there is nothing to undo
                continue;
            end
            
            curr = curr - 1;

            doubleZoneStruct.layerImage = doubleZoneStruct.buffer.image{curr};
            doubleZoneStruct.layerAlpha = doubleZoneStruct.buffer.alpha{curr};
            doubleZoneStruct.grass = doubleZoneStruct.buffer.grass{curr};
            doubleZoneStruct.obstacles = doubleZoneStruct.buffer.obstacles{curr};
            doubleZoneStruct.objects = doubleZoneStruct.buffer.objects{curr};
            zoneStruct.map = copy(zoneStruct.buffer.map{curr});
            zoneStruct2.map = copy(zoneStruct2.buffer.map{curr});
            
            
            displayLayers; % manually force a redraw to update (if it's the map)
            fprintf('undoing last..\n');
        end
        continue;
        
    case 'g' % turn grid lines on off (this doesn't currently work)
        grid = ~grid;
        if grid
            fprintf('Gridlines ON\n');
        else
            fprintf('Gridlines OFF\n');
        end
        
        % force a redraw
        displayLayers;
        
        continue;
    case 'h' % display help information
        displayHelpInformation;
        continue;
    case 'f' %fill entire screen
        fprintf('Filling screen with current tile\n');
        doubleImageSize = size(doubleZoneStruct.obstacles)*pxPerGrid;
        rect = [1 1 doubleImageSize(2)-2, doubleImageSize(1)-2];
    case 'e' % erase current layer
        eraser = ~eraser; % toggle the eraser
        if eraser
            oldColor = get(handles.mapFigureHandle, 'Color');
            fprintf('Eraser is ON\n');
            set(handles.mapFigureHandle, 'Color', [.7 0 0]);
        else
            fprintf('Eraser is OFF\n');
            set(handles.mapFigureHandle, 'Color', oldColor);
        end
        continue;
    case 'l' % load a tileset (can probably fix this in a few minutes)
        
        saveDir = uigetdir;
        
        
        if saveDir ~= 0 % if they chose a valid directory, then load it
            
            fullPathArray=regexp(saveDir,'/','split')
            saveDir = fullPathArray{end};
            % reload the local zones since we are now 'centered' elsewhere
            %localZoneMap = loadLocalZones(localZoneMap, saveDir, [0 0]);
            %loadCenterZone;
            initLayers;
        end
        
        % update the display
        if flag == 0 % don't display it if we still need to select a tile
            displayLayers;
        end
        continue;
    case 33
        % switch to the appropriate tileset. Add more of these as they are
        % added
        flag = 1;
        continue;
    case 64
        flag = 2;
        continue;
    case 35
        flag = 3;
        continue;
    case 36
        flag = 4;
        continue;
    case 37
        flag = 5;
        continue
    case 94
        flag = 6;
        continue;
    case 38
        flag = 7;
        continue;
    case 'r' % r for refresh, basically useless right now. I want this to be 'redo' later
        
        if flag == 0 % only allow multi pt selection if we're on the map
           selectMethod = 2;
           fprintf('Grass selection mode: ON\n');
        end
        
    case 30 %up
        curr = 1;
        fprintf('Moving up\n');
        %direction = [1 0];
        directionStr = 'UD';
        
        
        
        if vert
            loc = str2num(saveDir);
            loc(2) = loc(2)+1;
            saveDir = strcat(num2str(loc(1)),',',num2str(loc(2)));
        
            loc = str2num(saveDir);
            loc(2) = loc(2)+1;
            saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
            
            zoneStruct = zoneStruct2;
            zoneStruct.map = copy(zoneStruct2.map);
            zoneStruct2 = loadZone(saveDir2);
            
        else
            
            loc = str2num(saveDir);
            loc(2) = loc(2)+1;
            saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
            
            zoneStruct2 = loadZone(saveDir2);
        end
        zoneStruct2 = loadZone(saveDir2);
        
        %prevZone = zoneStruct;
        displayLayers;
        continue;
    case 31 %down
        curr = 1;
        fprintf('Moving down\n');
        %direction = [-1, 0];
        directionStr = 'UD';
        
        % RIGHT AND DOWN
        
        loc = str2num(saveDir);
        loc(2) = loc(2)-1;
        saveDir = strcat(num2str(loc(1)),',',num2str(loc(2)));
        zoneStruct2 = zoneStruct;
        zoneStruct2.map = copy(zoneStruct.map);
        zoneStruct = loadZone(saveDir);
       % localZoneMap = loadLocalZones(localZoneMap, saveDir, direction);
       % loadCenterZone;
        
        %prevZone = zoneStruct;
        displayLayers;
        continue;
    case 28 % left
        curr = 1;
        fprintf('Moving left\n');
        %direction = [0 1];
        directionStr = 'LR';
        
        % UP AND LEFT
        
        loc = str2num(saveDir);
        loc(1) = loc(1)-1;
        saveDir = strcat(num2str(loc(1)),',',num2str(loc(2)));
        
        zoneStruct2 = zoneStruct;
        zoneStruct2.map = copy(zoneStruct.map);
        zoneStruct = loadZone(saveDir);
        
        %localZoneMap = loadLocalZones(localZoneMap, saveDir, direction);
        %loadCenterZone;
        
        %prevZone = zoneStruct;
        displayLayers;
        continue;
    case 29 %right
        curr = 1;
        fprintf('Moving right\n');
        %direction = [0 -1];
        directionStr = 'LR';
        
        
        if ~vert
            loc = str2num(saveDir);
            loc(1) = loc(1)+1;
            saveDir = strcat(num2str(loc(1)),',',num2str(loc(2)));
            
            loc = str2num(saveDir);
            loc(1) = loc(1)+1;
            saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
            
            zoneStruct = zoneStruct2;
            zoneStruct2.map = copy(zoneStruct2.map);
            zoneStruct2 = loadZone(saveDir2);
            %localZoneMap = loadLocalZones(localZoneMap, saveDir, direction);
            %loadCenterZone;
        else
            loc = str2num(saveDir);
            loc(1) = loc(1)+1;
            saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
            
            zoneStruct2 = loadZone(saveDir2);
        end
        
        
        displayLayers;
        continue;
    
    case 'i' % interact
        if flag == 0
            selectMethod = 3;
            fprintf('Object selection: ON\n');
        end
        
        continue; %deprecated
        
    case 'c' % cancel, go back to regular selection
        if flag == 0
            selectMethod = 0;
            fprintf('Regular selection: ON\n');
        end
        continue;
        
    case 'n' % toggles editing of interior
        indoors = ~indoors;
        if indoors
            fprintf('Indoor selection tool: ON\n');
        else
            fprintf('Indoor selection tool: OFF\n');
        end
        
        continue;
        
    case 'm' % to Move to an interior zone
        move = ~move;
        
        if move
            fprintf('Move tool: ON\n');
        else
            fprintf('Move tool: OFF\n');
        end
        
        continue;
        
    case ',' % move back to parent
         if isempty(zoneStruct.parent)
             fprintf('No parent to go back to!\n');
            continue;
         end
        fprintf('Moving back to parent zone..\n');
        saveDir = sprintf('%d,%d',zoneStruct.parent(1), zoneStruct.parent(2));
        initLayers;
        displayLayers;
        continue;
    case '/' % set a door to go back to the parent. this is kinda buggy
        %fprintf('Setting door to go back to parent zone...\n');
        settingBackpointer = ~settingBackpointer;
        
        if settingBackpointer
            fprintf('Set backpointer tool: ON\n');
        else
            fprintf('Set backpointer tool: OFF\n');
        end
        
        continue;
        
    case 'x'
        
        copyMode = ~copyMode;
        if copyMode
            fprintf('Copying ON\n');
        else
            fprintf('Copying OFF\n');
        end
        
        continue;
    case 'z' % stupid fix to reset the button press
    case '' % test fix
        
    %otherwise % if something unrecognized was pressed, continue
    %    fprintf('Unrecognized button %i pressed\n', button);
    %    continue;
end
