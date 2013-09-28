%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Elias Bagley
%   Date:   1/29/2012
%   CS 4500 Senior Capstone Project
%
%   This program is a level editor for a game, which allows you to select
%   tiles and draw them onto a map.
%
%   todo:
%      export stuff into function (where possible)
%      have an 'undo' hotkey (keep track of previous picture, if undo is
%      pressed, redisplay that picture) (test this better, or make a 'redo')
%       add copy/paste functionality
%       add a repeating rect thing for every grid, like tiling
%       scrollbars on the figure (might not want to do this if other stuff works)
%       add the ability to draw trees at arbitrary pixel locations, not
%       just snapping to grid
%       make a separate tool to specify wher the tree trunks are, so we
%       don't have to do it for each level we make
%       look into 'montage' or similar to display a zone next to the current zone, so
%       you know how to build it (can't do alpha channel, it seems)
%       - time per zone/level of zone information coded into the tilesets
%       - use arrow keys to concatenate matricies, so you can sequentially
%       build an entire level (4 on a screen at a time?)
%       - reposition the two figure windows so that both can be seen at the
%       same time
%       - if it's not in getrect, button presses aren't recognized. I
%       should add a keydown handler to the main figures
%       - can things on obstacle layer be positioned at an arbitrary pixel,
%       or do they need to snap to grid?
%       - toolbar might still be nice
%       - have a button that will pop up a new figure with only the current
%       layer (I got confused when erasing something on the wrong layer)
%       have the coordinates be on the title of the map, and also save teh
%       coordinate string to the struct that loadZone returns
%       don't create a new layer if the program starts and they enter an
%       existing location, load it instead

%       right now, the grid is being saved along with everything else. it
%       might be faster to not save this part of it

%       filling with snap off causes a crash
%       add interiors
%       add 'cut' functionality
%       bug: when there is an unrecognized button pressed, it draws a tile
%       in the top left corner

% push changes to 'o' and 'r' onto the buffer
% make door selection be a 'wormhole', so that you have to set both
% locations before you finish
% change the target zone manually by pressing a button
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% clean up before we take a suckers money
close all;
clear;

%% display help information and initialize constants

displayHelpInformation;
initConstants; % initialize all constants and matricies


%% main level creator loop
while 1
    directionStr = 'NONE'; % hacky
    % decide what figure to show
    switch flag
        case 0 % show the map that we're drawing
            if prevFlag ~= flag % only call the figure if the flag has changed
                figure(handles.mapFigureHandle);
                set(handles.mapFigureHandle, 'Name', strcat('Map-',saveDir));
                displayLayers;
            end
        otherwise
            if prevFlag ~= flag % only do the figure stuff if the flag has changed
                figure(handles.tileFigureHandle);
                set(handles.tileFigureHandle, 'Name', strcat('Tileset-',num2str(flag)));
                %clf; % this might clear some memory and speed things up
                %grid on;
                cla reset;
                a = imshow(tilesets{flag}, 'InitialMagnification', 100);
                
                set(a, 'AlphaData', alphas{flag});
                
                hold on;
                
                % show the layer for this tileset
                b = imshow(gridImage{flag}, 'InitialMagnification', 100); % last layer is the gridded layer
                set(b, 'AlphaData', gridAlpha{flag});
                hold off;
                
            end
    end
    
    
    if (flag ~= 0) %figure out what picture on tileset was clicked
        prevFlag = flag;
        currentTileset = flag; % keeps track of the current tileset
        
        tileset = tilesets{flag};
        alpha_data_tileset = alphas{flag};
        tilesetSize = size(tileset);
        
        [rect button] = e_getrect; % get user input
        rect = floor(rect); % elimated fractional pixels
        
        x = rect(1); y = rect(2); widthTile = rect(3); heightTile = rect(4);
        
        % figures out how many rows and columns were dragged, their
        % location, and their index
        [numRows numCols yStartPxTile xStartPxTile row col] = getSpan(rect, pxPerGrid);
        %row
        %col
        handleButtonPresses;
        
        % check for errors in clicking
        if x <= 0 || y <= 0 || x >= tilesetSize(2) || y >= tilesetSize(1) || (x + widthTile) >= tilesetSize(2) || (y+heightTile) >= tilesetSize(1)  %just ignore if you click off screen
            fprintf('Trying to select tile out of bounds\n');
            continue;
        end
        
        
        selectedTile = tileset(yStartPxTile:(yStartPxTile+numRows*pxPerGrid-1), xStartPxTile:(xStartPxTile+numCols*pxPerGrid-1), :);
        selectedTileAlpha = alpha_data_tileset(yStartPxTile:(yStartPxTile+numRows*pxPerGrid-1), xStartPxTile:(xStartPxTile+numCols*pxPerGrid-1), :);
        
        
        flag = 0; % 0 is the map, go back to map canvas after picking a tile
    else
        if selectMethod == 0
            
            % this is ugly
            if eraser
                if needToRestore == 0
                    % nuke the old selected tile, replace with a blank 1x1
                    % selected tile
                    selectedTile_old = selectedTile;
                    selectedTileAlpha_old = selectedTileAlpha;
                    numRows = 1;
                    numCols = 1;
                    selectedTile = zeros(pxPerGrid, pxPerGrid, 3);
                    selectedTileAlpha = zeros(pxPerGrid, pxPerGrid);
                    
                    needToRestore = 1;
                end
            else
                if needToRestore == 1
                    fprintf('why are we restoring');
                    selectedTile = selectedTile_old;
                    selectedTileAlpha = selectedTileAlpha_old;
                    needToRestore = 0;
                end
                
            end
            
            sizeTile = size(selectedTileAlpha);
            
            [rect button] = e_getrect;
            
            rect = floor(rect);
            
            
            handleButtonPresses; % handle button presses before saving
            
            x = rect(1); y = rect(2); width = rect(3); height = rect(4);
            
            % save the layers and matricies on the buffer (undo stack)
            pushLayers;
            
            if (rect(1) <= 0 || rect(2) <= 0 || rect(2) >= 2*imageSize(2) || rect(1) >= 2*imageSize(1)) %just ignore if you click off image (consider allowing if they are dragging)
                fprintf('Trying to place tile out of bounds\n');
                continue;
            end
            
            % gets the number of rows and cols that the user clicked and
            % dragged on the map
            [numRowsMap numColsMap yStartPxMap xStartPxMap row col] = getSpan(rect, pxPerGrid);
            pos = [col-1 row-1]
            doubleSize = size(doubleZoneStruct.layerAlpha{1});
            
            if x <= 0 || y <= 0 || x >= doubleSize(2) || y >= doubleSize(1) || (x + width) >= doubleSize(2) || (y+height) >= doubleSize(1)  %just ignore if you click off screen
                continue;
            end
            
            if indoors
                % write the location to the 'indoors' file located in the
                % zone folder
                
                % highlight this location
                doubleZoneStruct.layerAlpha{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1) = .5;
                doubleZoneStruct.layerImage{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1, 1) = 1;
                doubleZoneStruct.layerImage{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1, 2) = 0;
                doubleZoneStruct.layerImage{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1, 3) = 0;
                displayLayers;
                
                
                
                destLoc = [indoorsX indoorsY];
                
                % write it into the correct zone
                if row <= 32 && col <= 32
                    localLoc = sprintf('%d,%d', row,col);
                    zoneStruct.map(localLoc) = destLoc;
                else
                    if row > 32
                        newrow = row - 32;
                        newcol = col;
                    elseif col > 32
                        newrow = row;
                        newcol = col - 32;
                    end
                    localLoc = sprintf('%d,%d', newrow,newcol);
                    zoneStruct2.map(localLoc) = destLoc;
                end
                
                fprintf('adding door at %s\n', localLoc);
                
                indoorsX = indoorsX + 50;
                indoorsY = indoorsY + 50;
                
                fid = fopen('indoorsLocations.txt', 'wt');
                fprintf(fid, '%d %d', indoorsX,indoorsY);
                fclose(fid);
                
                continue;
            end
            
            if settingBackpointer
                % set the entrypoint to the zone
                
                
                if row <= 32 && col <=32
                    if isempty(zoneStruct.parent)
                        fprintf('no where to set a back pointer to (needs a parent zone)!\n');
                        continue;
                        
                    end
                    fprintf('linking back to zoneStruct\n');
                    
                    doubleZoneStruct.layerAlpha{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1) = .5;
                    doubleZoneStruct.layerImage{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1, 1) = 1;
                    doubleZoneStruct.layerImage{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1, 2) = 0;
                    doubleZoneStruct.layerImage{numLayers}((row-1)*pxPerGrid+1:row*pxPerGrid-1, (col-1)*pxPerGrid+1:col*pxPerGrid-1, 3) = 0;
                    
                    % get the local location that the user clicked
                    localLoc = sprintf('%d,%d', row, col);
                    % find the mapping to this zone
                    destLoc = zoneStruct.parent; %4tuple representing zone and location in zone
                    % add the door going back to the parent
                    zoneStruct.map(localLoc) = destLoc;
                    
                    % update the info in the parent zone
                    destLocStr = sprintf('%d,%d', zoneStruct.parent(3), zoneStruct.parent(4));
                    value = parentZone.map(destLocStr); % tuple
                    newValue = [value(1) value(2) row col];
                    parentZone.map(destLocStr) = newValue;
                    
                    
                    
                else
                    if isempty(zoneStruct2.parent)
                        fprintf('no where to set a back pointer to (needs a parent zone)!\n');
                        continue;
                    end
                    fprintf('linking back to zoneStruct2\n');
                    if row > 32
                        newrow = row - 32;
                        newcol = col;
                    elseif col > 32
                        newrow = row;
                        newcol = col - 32;
                    end
                    
                    
                    doubleZoneStruct.layerAlpha{numLayers}((newrow-1)*pxPerGrid+1:row*pxPerGrid-1, (newcol-1)*pxPerGrid+1:col*pxPerGrid-1) = .5;
                    doubleZoneStruct.layerImage{numLayers}((newrow-1)*pxPerGrid+1:row*pxPerGrid-1, (newcol-1)*pxPerGrid+1:col*pxPerGrid-1, 1) = 1;
                    doubleZoneStruct.layerImage{numLayers}((newrow-1)*pxPerGrid+1:row*pxPerGrid-1, (newcol-1)*pxPerGrid+1:col*pxPerGrid-1, 2) = 0;
                    doubleZoneStruct.layerImage{numLayers}((newrow-1)*pxPerGrid+1:row*pxPerGrid-1, (newcol-1)*pxPerGrid+1:col*pxPerGrid-1, 3) = 0;
                    
                    localLoc = sprintf('%d,%d', newrow, newcol);
                    destLoc = zoneStruct2.parent;
                    zoneStruct2.map(localLoc) = destLoc;
                    destLocStr = sprintf('%d,%d', zoneStruct2.parent(3), zoneStruct2.parent(4));
                    
                    value = parentZone.map(destLocStr); %tuple
                    newValue = [value(1) value(2) newrow newcol];
                    parentZone.map(destLocStr) = newValue;
                    
                end
                
                fprintf('adding backpointer...\n');
                fprintf('Saving parent zone..\n');
                saveState(parentZone.name, parentZone);
                fprintf('Done!\n');
                
                continue;
            end
            
            if move
                
                if row <=32 && col <=32 % zoneStruct was clicked
                    fprintf('moving from zoneStruct\n');
                    loc = sprintf('%d,%d', row, col); % the location that the user clicked to 'move' to, check that it's a door first
                    currentZone = zoneStruct.name;
                    if isKey(zoneStruct.map, loc) % then this was previously added as a door, so load that zone
                        fprintf('Moving...\n');
                        
                        parentZone = zoneStruct;
                        parentZone.map = copy(zoneStruct.map);
                        
                        mapValue = zoneStruct.map(loc);
                        saveDir = sprintf('%d,%d', mapValue(1), mapValue(2));
                        initLayers; % call the same initLayer code that was initially called
                        zoneStruct.parent = [str2num(currentZone) row col]
                        displayLayers;
                    else
                        fprintf('Not a valid location!\n');
                    end
                else % zoneStruct2 was clicked
                    fprintf('moving from zoneStruct2\n');
                    if row > 32
                        newrow = row -32;
                        newcol = col;
                    else
                        newrow = row;
                        newcol = col -32;
                    end
                    loc = sprintf('%d,%d', newrow, newcol); % the location that the user clicked to 'move' to, check that it's a door first
                    currentZone = zoneStruct2.name;
                    if isKey(zoneStruct2.map, loc) % then this was previously added as a door, so load that zone
                        fprintf('Moving...\n');
                        
                        parentZone = zoneStruct2;
                        parentZone.map = copy(zoneStruct2.map);
                        
                        mapValue = zoneStruct2.map(loc);
                        saveDir = sprintf('%d,%d', mapValue(1), mapValue(2));
                        initLayers; % call the same initLayer code that was initially called
                        zoneStruct.parent = [str2num(currentZone) newrow newcol]
                        displayLayers;
                    else
                        fprintf('Not a valid location!\n');
                    end
                    
                    
                end
                continue
            end
            
            % calculate the number of tiles that will fit in each direction
            % (round down so we don't write off the end of the matrix)
            
            numRowDir = floor(numRowsMap*pxPerGrid/sizeTile(1));
            numColDir = floor(numColsMap*pxPerGrid/sizeTile(2));
            
            % so that single left/right click still work
            if (numRowDir == 0)
                numRowDir = 1;
            end
            if (numColDir == 0)
                numColDir = 1;
            end
            
            % still need to do error checking for this
            
            % temporary variables
            startX = xStartPxMap;
            startY = yStartPxMap;
            if ~copyMode
                for i=1:numRowDir
                    xStartPxMap = startX;
                    for j=1:numColDir
                        
                        % alpha compositing algorithm, A over B
                        
                        % make sure we don't try to access off the end
                        
                        % break differently depending on orientation
                        
                        if size(doubleZoneStruct.obstacles, 1) > size(doubleZoneStruct.obstacles, 2) % up/down
                            if (xStartPxMap+numCols*pxPerGrid-1 > imageSize(2) || yStartPxMap+numRows*pxPerGrid-1 > 2*imageSize(1))
                                fprintf('Clicking off screen\n');
                                break;
                            end
                        else % left right
                            if (xStartPxMap+numCols*pxPerGrid-1 > 2*imageSize(2) || yStartPxMap+numRows*pxPerGrid-1 > imageSize(1))
                                fprintf('Clicking off screen\n');
                                break;
                            end
                        end
                        
                        
                        alphaComp;
                        
                        
                        xStartPxMap = xStartPxMap+sizeTile(2);
                        
                        
                    end
                    
                    yStartPxMap = yStartPxMap + sizeTile(1);
                    
                end
            else % copy mode enabled
                % get the actual matrix data corresponding to the clicked location
               
                    selectedTile = doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:(yStartPxMap+numRowsMap*pxPerGrid-1), xStartPxMap:(xStartPxMap+numColsMap*pxPerGrid-1), :);
                    selectedTileAlpha = doubleZoneStruct.layerAlpha{currentLayer}(yStartPxMap:(yStartPxMap+numRowsMap*pxPerGrid-1), xStartPxMap:(xStartPxMap+numColsMap*pxPerGrid-1), :);
    
            end
            
        elseif selectMethod == 1 % the user is in 'manual obstacle selection mode'
            
            [rect button] = e_getrect; % change this to get rect, it will be easier to use
            x = rect(1); y = rect(2); width = rect(3); height = rect(4);
            tilesetSize = size(doubleZoneStruct.layerAlpha{1});
            
            [numRowsMap numColsMap yStartPxMap xStartPxMap row col] = getSpan(rect, pxPerGrid);
            
        
            
            
            handleButtonPresses;
            
            pushLayers;
            
            % check for errors in clicking
            if x <=0 || y <= 0 || x >= tilesetSize(2) || y >= tilesetSize(1) || (x + width) >= tilesetSize(2) || (y+height) >= tilesetSize(1)  %just ignore if you click off screen
                fprintf('Out of bounds\n');
                continue;
            end
            
            sizeTileGrid =  size(doubleZoneStruct.layerAlpha{1}(yStartPxMap:(yStartPxMap+numRowsMap*pxPerGrid-1), xStartPxMap:(xStartPxMap+numColsMap*pxPerGrid-1), :))/pxPerGrid;
            
            
            
            obsRow = floor(yStartPxMap/pxPerGrid)+1;
            obsCol = floor(xStartPxMap/pxPerGrid)+1;
            doubleZoneStruct.obstacles(obsRow:(obsRow-1)+sizeTileGrid(1), obsCol:(obsCol-1)+sizeTileGrid(2)) = 1;
            
            for f=1:sizeTileGrid(1)
                for j = 1:sizeTileGrid(2)
                    doubleZoneStruct.layerAlpha{numLayers}((obsRow-2+f)*pxPerGrid+1:(obsRow-1+f)*pxPerGrid-1, (obsCol-2+j)*pxPerGrid+1:(obsCol-1+j)*pxPerGrid-1) = .3;
                end
            end
            
         
        elseif selectMethod == 2 % selecting grass
            [rect button] = e_getrect; % change this to get rect, it will be easier to use
            x = rect(1); y = rect(2); width = rect(3); height = rect(4);
            tilesetSize = size(doubleZoneStruct.layerAlpha{1});
            
            [numRowsMap numColsMap yStartPxMap xStartPxMap row col] = getSpan(rect, pxPerGrid);
            
            handleButtonPresses;
            
                pushLayers;
            
            % check for errors in clicking
            if x <=0 || y <= 0 || x >= tilesetSize(2) || y >= tilesetSize(1) || (x + width) >= tilesetSize(2) || (y+height) >= tilesetSize(1)  %just ignore if you click off screen
                fprintf('Out of bounds\n');
                continue;
            end
            
            sizeTileGrid =  size(doubleZoneStruct.layerAlpha{1}(yStartPxMap:(yStartPxMap+numRowsMap*pxPerGrid-1), xStartPxMap:(xStartPxMap+numColsMap*pxPerGrid-1), :))/pxPerGrid;
            
            
            
            obsRow = floor(yStartPxMap/pxPerGrid)+1;
            obsCol = floor(xStartPxMap/pxPerGrid)+1;
            doubleZoneStruct.grass(obsRow:(obsRow-1)+sizeTileGrid(1), obsCol:(obsCol-1)+sizeTileGrid(2)) = 1;
            
        
            for f=1:sizeTileGrid(1)
                for j = 1:sizeTileGrid(2)
                    % overlay grass with the green
                    doubleZoneStruct.layerImage{numLayers}((obsRow-2+f)*pxPerGrid+1:(obsRow-1+f)*pxPerGrid-1, (obsCol-2+j)*pxPerGrid+1:(obsCol-1+j)*pxPerGrid-1, 1) = 0;
                    doubleZoneStruct.layerImage{numLayers}((obsRow-2+f)*pxPerGrid+1:(obsRow-1+f)*pxPerGrid-1, (obsCol-2+j)*pxPerGrid+1:(obsCol-1+j)*pxPerGrid-1, 2) = 1;
                    doubleZoneStruct.layerImage{numLayers}((obsRow-2+f)*pxPerGrid+1:(obsRow-1+f)*pxPerGrid-1, (obsCol-2+j)*pxPerGrid+1:(obsCol-1+j)*pxPerGrid-1, 3) = 0;
                    doubleZoneStruct.layerAlpha{numLayers}((obsRow-2+f)*pxPerGrid+1:(obsRow-1+f)*pxPerGrid-1, (obsCol-2+j)*pxPerGrid+1:(obsCol-1+j)*pxPerGrid-1) = .3;
                end
            end
        elseif selectMethod == 3 % selecting doors
            [rect button] = e_getrect; % change this to get rect, it will be easier to use
            [numRowsMap numColsMap yStartPxMap xStartPxMap row col] = getSpan(rect, pxPerGrid);
            
            handleButtonPresses;
            
             pushLayers;
            
            objectText = inputdlg('Object Text', 'Object Text', 1, {''});
            if isempty(objectText)
                objectText = [];  
            else
                objectText = objectText{1}; % no reason why it should be a cell, so convert to str
            end
            
            doubleZoneStruct.objects{row, col} = objectText; % still need to save this to the local struct
            
           
            
        end
        
        % every iteration, draw everything
        displayLayers;
        
        prevFlag = flag;
    end
end
