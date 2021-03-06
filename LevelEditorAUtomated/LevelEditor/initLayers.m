% init layers
cd zones;

if exist(saveDir, 'dir') % load it if it exists
cd ..;    
    zoneStruct = loadZone(saveDir);

    loc = str2num(saveDir);
    loc(1) = loc(2)+1;
    saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
    %zoneStruct2 = localZoneMap{2, 3}; % right by defalt, remember row/col %might this be a problem?
    zoneStruct2 = loadZone(saveDir2);
    otherSaveDir = zoneStruct2.name;
    for i = 1:numLayers
        doubleZoneStruct.layerImage{i} = [zoneStruct.layerImage{i} zoneStruct2.layerImage{i}];
        doubleZoneStruct.layerAlpha{i} = [zoneStruct.layerAlpha{i} zoneStruct2.layerAlpha{i}];
    end
    doubleZoneStruct.obstacles = [zoneStruct.obstacles zoneStruct2.obstacles];
    doubleZoneStruct.grass = [zoneStruct.grass zoneStruct2.grass];
    doubleZoneStruct.map1 = zoneStruct.map;
    doubleZoneStruct.map2 = zoneStruct2.map;
    
    oldAlpha = doubleZoneStruct.layerAlpha{5};
    
    %obstacles = zoneStruct.obstacles;
    %grass = zoneStruct.grass;
    %layerImage = zoneStruct.layerImage;
    %layerAlpha = zoneStruct.layerAlpha;
    %buffer = zoneStruct.buffer;
    
    
else % else create a blank zone, and the zoneStruct that goes with it
    cd ..;
    zoneStruct = blankZoneStruct;
    zoneStruct.name = saveDir;
    
    loc = str2num(saveDir);
    loc(1) = loc(1)+1;
    saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
    cd zones;
    if exist(saveDir2, 'dir')
        cd ..;
        zoneStruct2 = loadZone(saveDir2);
        otherSaveDir = zoneStruct2.name;
    else
        zoneStruct2 = blankZoneStruct;
        zoneStruct2.name = saveDir2;
        otherSaveDir = zoneStruct2.name;
    end
    
    for i = 1:numLayers
        doubleZoneStruct.layerImage{i} = [zoneStruct.layerImage{i} zoneStruct2.layerImage{i}];
        doubleZoneStruct.layerAlpha{i} = [zoneStruct.layerAlpha{i} zoneStruct2.layerAlpha{i}];
    end
    doubleZoneStruct.obstacles = [zoneStruct.obstacles zoneStruct2.obstacles];
    doubleZoneStruct.grass = [zoneStruct.grass zoneStruct2.grass];
    doubleZoneStruct.map1 = zoneStruct.map;
    doubleZoneStruct.map2 = zoneStruct2.map;
    
    oldAlpha = doubleZoneStruct.layerAlpha{5};
    
end
