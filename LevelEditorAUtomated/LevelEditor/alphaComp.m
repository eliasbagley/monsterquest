


%imageMatrix = doubleZoneStruct.layerImage{currentLayer};
%imageAlpha = doubleZoneStruct.layerAlpha{currentLayer};

sizeTileGrid = size(selectedTileAlpha)/pxPerGrid; %dimensions of selected tile, in cells
        

% these will need to be cleared out when eraser functionality is added
obsRow = floor(yStartPxMap/pxPerGrid)+1;
obsCol = floor(xStartPxMap/pxPerGrid)+1;

numRows = floor(size(selectedTileAlpha, 1)/pxPerGrid);
numCols = floor(size(selectedTileAlpha, 2)/pxPerGrid);
if snap
    endRow = yStartPxMap+numRows*pxPerGrid-1;
    endCol = xStartPxMap+numCols*pxPerGrid-1;
else
    endRow = floor(yStartPxMap-1 + heightTile); % make 'width' and 'height' work for both
    endCol = floor(xStartPxMap-1 + widthTile);
end

B = doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, :);
Balpha = doubleZoneStruct.layerAlpha{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol);

if eraser %if eraser is active (only block out a single square)

    % remove doors also
    locationStr = sprintf('%d,%d', obsRow,obsCol);
    if isKey(zoneStruct.map, locationStr)
        fprintf('Removing door at %s\n', locationStr);
        remove(zoneStruct.map, locationStr);
    end
    
    % makes it fit back in at the right size
    %numRows = 1;
    %numCols = 1;
    result = B*0;
    resultAlpha = Balpha*0;
    
    if currentLayer == 2 % add this to the obstacle matrix
        doubleZoneStruct.obstacles(obsRow, obsCol) = 0;
        doubleZoneStruct.layerAlpha{5}((obsRow-1)*pxPerGrid+1:obsRow*pxPerGrid-1, (obsCol-1)*pxPerGrid+1:obsCol*pxPerGrid-1) = 0;
    elseif currentLayer == 3 % add this to the grass matrix
        doubleZoneStruct.grass(obsRow, obsCol) = 0;
    end
    
    
    
else %if eraser isn't active, alpha comp as normal
    
    
    if currentLayer == 2 % add this to the obstacle matrix
        doubleZoneStruct.obstacles(obsRow:(obsRow-1)+sizeTileGrid(1), obsCol:(obsCol-1)+sizeTileGrid(2)) = 1;
        for f=1:sizeTileGrid(1)
            for j = 1:sizeTileGrid(2)
                doubleZoneStruct.layerAlpha{5}((obsRow-2+f)*pxPerGrid+1:(obsRow-1+f)*pxPerGrid-1, (obsCol-2+j)*pxPerGrid+1:(obsCol-1+j)*pxPerGrid-1) = .5;
            end
        end
        %doubleZoneStruct.layerAlpha{5}((obsRow-1)*pxPerGrid+1:(obsRow-1+sizeTileGrid(1))*pxPerGrid-1, (obsCol-1)*pxPerGrid+1:(obsCol-1+sizeTileGrid(2))*pxPerGrid-1) = .5;
    elseif currentLayer ==3 % add this to the grass matrix
        doubleZoneStruct.grass(obsRow:(obsRow-1)+sizeTileGrid(1), obsCol:(obsCol-1)+sizeTileGrid(2)) = 1;
    end
    
    [result resultAlpha] = alphaCompFunc(selectedTile, selectedTileAlpha, B, Balpha);
    
end
% copy result back into the image matrix
doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, 1) = result(1:end, 1:end, 1);
doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, 2) = result(1:end, 1:end, 2);
doubleZoneStruct.layerImage{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol, 3) = result(1:end, 1:end, 3);
doubleZoneStruct.layerAlpha{currentLayer}(yStartPxMap:endRow, xStartPxMap:endCol) = resultAlpha(1:end, 1:end);


%doubleZoneStruct.layerImage{currentLayer} = imageMatrix;
%doubleZoneStruct.layerAlpha{currentLayer} = imageAlpha;