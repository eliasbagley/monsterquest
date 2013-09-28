


%imageMatrix = doubleZoneStruct.layerImage{currentLayer};
%imageAlpha = doubleZoneStruct.layerAlpha{currentLayer};

sizeTileGrid = size(selectedTileAlpha)/pxPerGrid; %dimensions of selected tile, in cells


% these will need to be cleared out when eraser functionality is added
obsRow = floor(yStartPxMap/pxPerGrid)+1;
obsCol = floor(xStartPxMap/pxPerGrid)+1;

numRows = floor(size(selectedTileAlpha, 1)/pxPerGrid);
numCols = floor(size(selectedTileAlpha, 2)/pxPerGrid);
endRow = yStartPxMap+numRows*pxPerGrid-1;
endCol = xStartPxMap+numCols*pxPerGrid-1;


B = doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, :);
Balpha = doubleZoneStruct.layerAlpha{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol);

if eraser %if eraser is active (only block out a single square)
    
    % remove doors also (need to think about how to remove a backpointer)
    if obsRow <=32 && obsCol <=32 % in zoneStruct
        
        locationStr = sprintf('%d,%d', obsRow,obsCol);
        if isKey(zoneStruct.map, locationStr)
            fprintf('Removing door at %s\n', locationStr);
            remove(zoneStruct.map, locationStr);
        end
        
        if zoneStruct.objects{obsRow, obsCol}
            fprintf('Removing object at %s\n', locationStr);
            zoneStruct.objects{obsRow, obsCol} = [];
        end
        
        
    else
        if obsRow > 32
            newObsRow = obsRow - 32;
            newObsCol = obsCol;
        else
            newObsCol = obsCol - 32;
            newObsRow = obsRow;
        end
        
        locationStr = sprintf('%d,%d', newObsRow, newObsCol);
        if isKey(zoneStruct2.map, locationStr)
            fprintf('Removing door at %s\n', locationStr);
            remove(zoneStruct2.map, locationStr);
        end
        
        if zoneStruct2.objects{newObsRow, newObsCol}
            fprintf('Removing object at %s\n', locationStr);
            zoneStruct.objects{newObsRow, newObsCol} = [];
        end
    end
    
    % makes it fit back in at the right size
    % this is the eraser stuff
    numRows = 1;
    numCols = 1;
    result = B*0;
    resultAlpha = Balpha*0;
    
    
    doubleZoneStruct.obstacles(obsRow, obsCol) = 0;
    doubleZoneStruct.layerAlpha{numLayers}((obsRow-1)*pxPerGrid+1:obsRow*pxPerGrid-1, (obsCol-1)*pxPerGrid+1:obsCol*pxPerGrid-1) = 0;
    doubleZoneStruct.npc(obsRow, obsCol) = 0;
    doubleZoneStruct.object(obsRow, obsCol) = 0;
    doubleZoneStruct.grass(obsRow, obsCol) = 0;
    
    
    
else %if eraser isn't active, alpha comp as normal
    
    [result resultAlpha] = alphaCompFunc(selectedTile, selectedTileAlpha, B, Balpha);
    
end
% copy result back into the image matrix

doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, 1) = result(1:end, 1:end, 1);
doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, 2) = result(1:end, 1:end, 2);
doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, 3) = result(1:end, 1:end, 3);
doubleZoneStruct.layerAlpha{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol) = resultAlpha(1:end, 1:end);


%doubleZoneStruct.layerImage{currentLayer} = imageMatrix;
%doubleZoneStruct.layerAlpha{currentLayer} = imageAlpha;