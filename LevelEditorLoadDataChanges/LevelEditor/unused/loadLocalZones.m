% load local zones


function localZoneMap = loadLocalZones(localZoneMap, saveDir, direction)

% represents 8 point connectivity of the map

% if direction is [0 0], then load everything. if it isn't, then shift
% everything and load what is new. it will likely be faster
cd zones;
index = str2num(saveDir);
directionStr = num2str(direction);

x = (index(1)-1):(index(1)+1);
y = (index(2)-1):(index(2)+1);

if all(direction == [0 0])
    for i=1:3
        for j=1:3
            dirStr = strcat(num2str(x(i)), ',', num2str(y(end+1-j)));
            if exist(dirStr, 'dir')
                localZoneMap{j,i} = loadZone(dirStr); % need to test
            else
                localZoneMap{j,i} = blankZone(dirStr);
            end
        end
    end
else
    
    localZoneMap = circshift(localZoneMap, direction);
    
    switch directionStr
        case num2str([1 0]) %up
            j = 1;
            for i=1:3
                dirStr = strcat(num2str(x(i)), ',', num2str(y(end+1-j)));
                if exist(dirStr, 'dir')
                    localZoneMap{j,i} = loadZone(dirStr); % need to test
                else
                    localZoneMap{j,i} = blankZone(dirStr);
                end
            end
        case num2str([-1 0]) %down
            j = 3;
            for i=1:3
                dirStr = strcat(num2str(x(i)), ',', num2str(y(end+1-j)));
                if exist(dirStr, 'dir')
                    localZoneMap{j,i} = loadZone(dirStr); % need to test
                else
                    localZoneMap{j,i} = blankZone(dirStr);
                end
            end
        case num2str([0 1]) %left
            i = 1;
            for j=1:3
                dirStr = strcat(num2str(x(i)), ',', num2str(y(end+1-j)));
                if exist(dirStr, 'dir')
                    localZoneMap{j,i} = loadZone(dirStr); % need to test
                else
                    localZoneMap{j,i} = blankZone(dirStr);
                end
            end
        case num2str([0 -1]) %right
            i = 3;
            for j=1:3
                dirStr = strcat(num2str(x(i)), ',', num2str(y(end+1-j)));
                if exist(dirStr, 'dir')
                    localZoneMap{j,i} = loadZone(dirStr); % need to test
                else
                    localZoneMap{j,i} = blankZone(dirStr);
                end
            end
            
            
    end
end

%     for i = 1:3
%         for j = 1:3
%             % find the folder that corresponds to this location
%             dirStr = strcat(num2str(x(i)), ',', num2str(y(end+1-j)));
%
%             if exist(dirStr, 'dir')
%                 localZoneMap{j,i} = loadZone(dirStr); % need to test
%             else
%                 localZoneMap{j,i} = blankZone(dirStr);
%             end
%         end
%     end

cd ..;
