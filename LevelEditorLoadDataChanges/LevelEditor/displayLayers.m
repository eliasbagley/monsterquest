

% determines how to build up the two zones
if ~strcmp(directionStr, 'NONE') %if we're only alpha comping, don't remake this every time
    
    for i = 1:numLayers
        
        switch directionStr
            case 'UD'
                doubleZoneStruct.layerImage{i} = [zoneStruct2.layerImage{i}; zoneStruct.layerImage{i}];
                doubleZoneStruct.layerAlpha{i} = [zoneStruct2.layerAlpha{i}; zoneStruct.layerAlpha{i}];
                
            case 'LR'
                doubleZoneStruct.layerImage{i} = [zoneStruct.layerImage{i} zoneStruct2.layerImage{i}];
                doubleZoneStruct.layerAlpha{i} = [zoneStruct.layerAlpha{i} zoneStruct2.layerAlpha{i}];
        end
        
                
    end
end

% have to redraw if the direction changes
if ((strcmp(directionStr,'UD') && ~vert) || (strcmp(directionStr,'LR') && vert))
    cla reset;
    h1 = imshow(doubleZoneStruct.layerImage{1}, 'InitialMagnification', 100);
    set(h1, 'AlphaData', doubleZoneStruct.layerAlpha{1});
    hold on;
    h2 = imshow(doubleZoneStruct.layerImage{2});
    set(h2, 'AlphaData', doubleZoneStruct.layerAlpha{2});
    hold on;
    
    if grid % toggle grid drawing on and off
        h3 = imshow(doubleZoneStruct.layerImage{numLayers});
        set(h3, 'AlphaData', doubleZoneStruct.layerAlpha{numLayers});
    else
        h3 = imshow(doubleZoneStruct.layerImage{numLayers});
        set(h3, 'AlphaData', 0*doubleZoneStruct.layerAlpha{numLayers});
    end
    hold off;
    

else
    set(h1, 'CData', doubleZoneStruct.layerImage{1}, 'AlphaData', doubleZoneStruct.layerAlpha{1});
    set(h2, 'CData', doubleZoneStruct.layerImage{2}, 'AlphaData', doubleZoneStruct.layerAlpha{2});

    if grid
        set(h3, 'CData', doubleZoneStruct.layerImage{numLayers}, 'AlphaData', doubleZoneStruct.layerAlpha{numLayers});
    else
        set(h3, 'CData', doubleZoneStruct.layerImage{numLayers}, 'AlphaData', 0*doubleZoneStruct.layerAlpha{numLayers});
    end
    
end


switch directionStr
    case 'UD'
        %zoneStruct2 = localZoneMap{1,2}; % up
        doubleZoneStruct.obstacles = [zoneStruct2.obstacles; zoneStruct.obstacles];
        doubleZoneStruct.grass = [zoneStruct2.grass; zoneStruct.grass];
        doubleZoneStruct.objects = [zoneStruct2.objects; zoneStruct.objects];
        
        otherSaveDir = zoneStruct2.name;
        vert = 1;
    case 'LR'
        %zoneStruct2 = localZoneMap{2,3}; % up
        doubleZoneStruct.obstacles = [zoneStruct.obstacles zoneStruct2.obstacles];
        doubleZoneStruct.grass = [zoneStruct.grass zoneStruct2.grass];      
        doubleZoneStruct.objects = [zoneStruct.objects zoneStruct2.objects];

        otherSaveDir = zoneStruct2.name;
        vert = 0;
    case 'NONE'
end



switch currentLayer
    case 1
        layerStr = 'Base Layer';
    case 2
        layerStr = 'Overlay Layer';
end

set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr));

