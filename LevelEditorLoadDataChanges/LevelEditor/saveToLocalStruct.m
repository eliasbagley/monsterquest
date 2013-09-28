% save to local struct

if size(doubleZoneStruct.obstacles, 1) > size(doubleZoneStruct.obstacles, 2) % if is up/down
        % zone struct 2 is top, zoneStruct is bottom
    zoneStruct.obstacles = doubleZoneStruct.obstacles(16*32/pxPerGrid+1:end, 1:end);
    zoneStruct.grass = doubleZoneStruct.grass(16*32/pxPerGrid+1:end, 1:end);
    zoneStruct.objects = doubleZoneStruct.objects(16*32/pxPerGrid+1:end, 1:end);
    
    for i =1:numLayers
        zoneStruct.layerImage{i} = doubleZoneStruct.layerImage{i}(513:end, 1:end, :);
        zoneStruct.layerAlpha{i} = doubleZoneStruct.layerAlpha{i}(513:end, 1:end, :);
    end
     
    
    zoneStruct2.obstacles = doubleZoneStruct.obstacles(1:16*32/pxPerGrid, 1:end);
    zoneStruct2.grass = doubleZoneStruct.grass(1:16*32/pxPerGrid, 1:end);
    zoneStruct2.objects = doubleZoneStruct.objects(1:16*32/pxPerGrid, 1:end);
    
    for i =1:numLayers
        zoneStruct2.layerImage{i} = doubleZoneStruct.layerImage{i}(1:512, 1:end, :);
        zoneStruct2.layerAlpha{i} = doubleZoneStruct.layerAlpha{i}(1:512, 1:end, :);
    end
    
    
else % left, right (zoneStruct is left, zonestruct2 is right)
    zoneStruct.obstacles = doubleZoneStruct.obstacles(1:end, 1:16*32/pxPerGrid);
    zoneStruct.grass = doubleZoneStruct.grass(1:end, 1:16*32/pxPerGrid);
    zoneStruct.objects = doubleZoneStruct.objects(1:end, 1:16*32/pxPerGrid);
    
    for i =1:numLayers
        zoneStruct.layerImage{i} = doubleZoneStruct.layerImage{i}(1:end, 1:512, :);
        zoneStruct.layerAlpha{i} = doubleZoneStruct.layerAlpha{i}(1:end, 1:512, :);
    end
    
    
    zoneStruct2.obstacles = doubleZoneStruct.obstacles(1:end, 16*32/pxPerGrid+1:end);
    zoneStruct2.grass = doubleZoneStruct.grass(1:end, 16*32/pxPerGrid+1:end);
    zoneStruct2.objects = doubleZoneStruct.objects(1:end, 16*32/pxPerGrid+1:end);
    
    for i =1:numLayers
        zoneStruct2.layerImage{i} = doubleZoneStruct.layerImage{i}(1:end, 513:end, :);
        zoneStruct2.layerAlpha{i} = doubleZoneStruct.layerAlpha{i}(1:end, 513:end, :);
    end
    
end
