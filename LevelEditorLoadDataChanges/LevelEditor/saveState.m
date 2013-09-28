% turn this into a function that takes the save location and the struct

function saveState(saveDir, zoneStruct)


% merge the base and obstacle layers and the grass layers
%[base baseAlpha] = flatten(zoneStruct.layerImage, zoneStruct.layerAlpha, 1, 3); % flatten the first 2 layers
% change to the zone directory to put everything in
%pwd

cd zones;

if ~exist(saveDir, 'dir') % if the save directory doesn't exist, create it
    mkdir(saveDir);
end

cd(saveDir);


fid = fopen(strcat('obstacles-', saveDir, '.txt'), 'wt');
fprintf(fid, '%d ', zoneStruct.obstacles);
fclose(fid);
fid = fopen(strcat('grass-', saveDir, '.txt'), 'wt');
fprintf(fid, '%d ', zoneStruct.grass);
fclose(fid);

first = 1;
fid = fopen(strcat('objects-', saveDir, '.txt'), 'wt');
for i = 1:size(zoneStruct.objects,1)
    for j = 1:size(zoneStruct.objects, 2)
        if ~isempty(zoneStruct.objects{i,j})
            line = sprintf('%d,%d#%s', i, j, zoneStruct.objects{i, j});
            if first
                fprintf(fid, '%s', line);
                first = 0;
            else
                fprintf(fid, '\n%s', line);
            end
        end
    end
end
fclose(fid);


fid = fopen(strcat('parent-', saveDir, '.txt'), 'wt');
fprintf(fid, '%s', zoneStruct.parent);
fclose(fid);

% write the doors map
map = zoneStruct.map;
ks = keys(map);
fid = fopen(strcat('indoors-', saveDir, '.txt'), 'wt');
for key = ks
    value = map(key{1});
    if length(value) ==2
        line = sprintf('%s#%d,%d', key{1}, value(1), value(2));
    else
        line = sprintf('%s#%d,%d,%d,%d', key{1}, value(1), value(2), value(3), value(4));
    end
    if strcmp(key, ks(end)) % last one, remove the newline
        fprintf(fid, '%s', line);
    else
        fprintf(fid, '%s\n', line);
    end
end
fclose(fid);

save('-mat', strcat('map-', saveDir, '.mat'), 'map'); % save the map to a mat file

% write the flattened 3 layers, and the overlay as images. these are for
% displaying on the iPhone
imwrite(zoneStruct.layerImage{1}, strcat('base-', saveDir, '.png'),'Alpha', zoneStruct.layerAlpha{1});
imwrite(zoneStruct.layerImage{2}, strcat('overlay-', saveDir, '.png'), 'Alpha', zoneStruct.layerAlpha{2});
imwrite(zoneStruct.layerImage{3}, strcat('grid-', saveDir, '.png'), 'Alpha', zoneStruct.layerAlpha{3});

% get back to the main workspace
cd ..; 
cd ..;