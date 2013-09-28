%resets the figure (to erase all previous stuff), then draws all layers

%redisplay the map


%cla reset;

% if collisionToggle
%     doubleImageSize = size(doubleZoneStruct.obstacles);
%     %oldAlpha = doubleZoneStruct.layerAlpha{5};
%     newAlpha = oldAlpha;
%     for i = 1:doubleImageSize(1)
%         for j = 1:doubleImageSize(2)
%             if doubleZoneStruct.obstacles(i,j)
%                 newAlpha((i-1)*pxPerGrid+1:i*pxPerGrid, (j-1)*pxPerGrid+1:j*pxPerGrid) = .5;
%             end
%         end
%     end
%     doubleZoneStruct.layerAlpha{5} = newAlpha;
% else
%     doubleZoneStruct.layerAlpha{5} = oldAlpha;
% end

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
        
        %h = imshow(doubleZoneStruct.layerImage{i}, 'InitialMagnification', 100);
        %set(h, 'AlphaData', doubleZoneStruct.layerAlpha{i});
        
        %hold on;
        
        
        
        
        
    end
end


if ((strcmp(directionStr,'UD') && ~vert) || (strcmp(directionStr,'LR') && vert))
    cla reset;
    h1 = imshow(doubleZoneStruct.layerImage{1}, 'InitialMagnification', 100);
    set(h1, 'AlphaData', doubleZoneStruct.layerAlpha{1});
    hold on;
    h2 = imshow(doubleZoneStruct.layerImage{2});
    set(h2, 'AlphaData', doubleZoneStruct.layerAlpha{2});
    hold on;
    h3 = imshow(doubleZoneStruct.layerImage{3});
    set(h3, 'AlphaData', doubleZoneStruct.layerAlpha{3});
    hold on;
    h4 = imshow(doubleZoneStruct.layerImage{4});
    set(h4, 'AlphaData', doubleZoneStruct.layerAlpha{4});
    hold on;
    if grid
        h5 = imshow(doubleZoneStruct.layerImage{5});
        set(h5, 'AlphaData', doubleZoneStruct.layerAlpha{5});
    else
        h5 = imshow(doubleZoneStruct.layerImage{5});
        set(h5, 'AlphaData', 0*doubleZoneStruct.layerAlpha{5});
    end
    hold off;
    
% elseif strcmp(directionStr, 'NONE')
%     switch currentLayer
%         case 1
%             set(h1, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%         case 2
%             set(h2, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%         case 3
%             set(h3, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%         case 4
%             set(h4, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%     end
%     set(h5, 'CData', doubleZoneStruct.layerImage{5}, 'AlphaData', doubleZoneStruct.layerAlpha{5});
else
    % switch currentLayer
    %     case 1
    %         set(h1, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
    %     case 2
    %         set(h2, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
    %     case 3
    %         set(h3, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
    %     case 4
    %         set(h4, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
    % end
    set(h1, 'CData', doubleZoneStruct.layerImage{1}, 'AlphaData', doubleZoneStruct.layerAlpha{1});
    set(h2, 'CData', doubleZoneStruct.layerImage{2}, 'AlphaData', doubleZoneStruct.layerAlpha{2});
    set(h3, 'CData', doubleZoneStruct.layerImage{3}, 'AlphaData', doubleZoneStruct.layerAlpha{3});
    set(h4, 'CData', doubleZoneStruct.layerImage{4}, 'AlphaData', doubleZoneStruct.layerAlpha{4});
    if grid
        set(h5, 'CData', doubleZoneStruct.layerImage{5}, 'AlphaData', doubleZoneStruct.layerAlpha{5});
    else
        set(h5, 'CData', doubleZoneStruct.layerImage{5}, 'AlphaData', 0*doubleZoneStruct.layerAlpha{5});
    end
    
end


switch directionStr
    case 'UD'
        %zoneStruct2 = localZoneMap{1,2}; % up
        doubleZoneStruct.obstacles = [zoneStruct2.obstacles; zoneStruct.obstacles];
        doubleZoneStruct.grass = [zoneStruct2.grass; zoneStruct.grass];
        otherSaveDir = zoneStruct2.name;
        vert = 1;
    case 'LR'
        %zoneStruct2 = localZoneMap{2,3}; % up
        doubleZoneStruct.obstacles = [zoneStruct.obstacles zoneStruct2.obstacles];
        doubleZoneStruct.grass = [zoneStruct.grass zoneStruct2.grass];
        otherSaveDir = zoneStruct2.name;
        vert = 0;
    case 'NONE'
end


% switch currentLayer
%     case 1
%         set(h1, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%     case 2
%         set(h2, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%     case 3
%         set(h3, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
%     case 4
%         set(h4, 'CData', doubleZoneStruct.layerImage{currentLayer}, 'AlphaData', doubleZoneStruct.layerAlpha{currentLayer});
% end
%h =          imshow(doubleZoneStruct.layerImage{i}, 'InitialMagnification', 100);
%set(h, 'AlphaData', doubleZoneStruct.layerAlpha{i});

%hold on;


switch currentLayer
    case 1
        layerStr = 'Base Layer';
    case 2
        layerStr = 'Obstacle Layer';
    case 3
        layerStr = 'Grass Layer';
    case 4
        layerStr = 'Overlay Layer';
end

set(handles.mapFigureHandle, 'Name', strcat('Map-', saveDir, '-', layerStr));

