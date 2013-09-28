% init layers
cd zones;

if exist(saveDir, 'dir') % load it if it exists
    cd ..;
    zoneStruct = loadZone(saveDir);
    
    loc = str2num(saveDir);
    loc(1) = loc(1)+1;
    saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
    
    % load zone two if it exists
    
    cd zones;
    if exist(saveDir2, 'dir')
        cd ..;
        zoneStruct2 = loadZone(saveDir2);
        otherSaveDir = zoneStruct2.name;
    else
        cd ..;
        zoneStruct2 = blankZone(saveDir2);
        otherSaveDir = zoneStruct2.name;
    end
    
    
else % else create a blank zone, and the zoneStruct that goes with it
    cd ..;
    zoneStruct = blankZone(saveDir);
    
    
    loc = str2num(saveDir);
    loc(1) = loc(1)+1;
    saveDir2 = strcat(num2str(loc(1)),',',num2str(loc(2)));
    cd zones;
    if exist(saveDir2, 'dir')
        cd ..;
        zoneStruct2 = loadZone(saveDir2);
        otherSaveDir = zoneStruct2.name;
    else
        cd ..;
        zoneStruct2 = blankZone(saveDir2);
        otherSaveDir = zoneStruct2.name;
    end
    
    
    
end

% do this once we have both zones

for i = 1:numLayers
    doubleZoneStruct.layerImage{i} = [zoneStruct.layerImage{i} zoneStruct2.layerImage{i}];
    doubleZoneStruct.layerAlpha{i} = [zoneStruct.layerAlpha{i} zoneStruct2.layerAlpha{i}];
end
doubleZoneStruct.obstacles = [zoneStruct.obstacles zoneStruct2.obstacles];
doubleZoneStruct.grass = [zoneStruct.grass zoneStruct2.grass];
doubleZoneStruct.objects = [zoneStruct.objects zoneStruct2.objects];

curr = 1; % reset curr
% if we have to create a new zone, we have to create a new buffer too
%doubleZoneStruct.buffer.image = cell(1,maxChanges);
%doubleZoneStruct.buffer.alpha = cell(1, maxChanges);
% add buffers for the grass and obstacle matricies also
%doubleZoneStruct.buffer.grass = cell(1, maxChanges);
%doubleZoneStruct.buffer.objects = cell(1, maxChanges);
%doubleZoneStruct.buffer.obstacles = cell(1, maxChanges);


%blankZoneStruct.buffer.map = cell(1, maxChanges);


%doubleZoneStruct.map1 = zoneStruct.map;
%doubleZoneStruct.map2 = zoneStruct2.map;
