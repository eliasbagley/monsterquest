% turn this into a function that takes the save location and the struct

function saveState(saveDir, zoneStruct)

%global localZoneMap;

% saveDirNum = str2num(saveDir);
% % write everything to the localZoneMap to keep everything consistent
% for i = 1:3
%     for j = 1:3
%         if all(str2num(localZoneMap{i,j}.name) == saveDirNum)
%             localZoneMap{i,j} = zoneStruct; % keep state consistent
%             break;
%         end
%     end
% end

% saving

% merge the base and obstacle layers and the grass layers
[base baseAlpha] = flatten(zoneStruct.layerImage, zoneStruct.layerAlpha, 1, 3); % flatten the first 3 layers
% change to the zone directory to put everything in
pwd
cd zones;

if ~exist(saveDir, 'dir') % if the save directory doesn't exist, create it
    mkdir(saveDir);
    addpath(saveDir);
end
cd(saveDir);
% save the obstacles matrix, the grass matrix, and the layer matrix data
% (for loading/editing later)
% alternative idea: save the entire workspace

%obstacles = zoneStruct.obstacles;
%grass = zoneStruct.grass;
layerImage = zoneStruct.layerImage;
layerAlpha = zoneStruct.layerAlpha;
map = zoneStruct.map;

%save('-ascii', strcat('obstacles-', saveDir, '.txt'), 'obstacles');
%save('-ascii', strcat('grass-', saveDir, '.txt'), 'grass');
fid = fopen(strcat('obstacles-', saveDir, '.txt'), 'wt');
fprintf(fid, '%d ', zoneStruct.obstacles);
fclose(fid);
fid = fopen(strcat('grass-', saveDir, '.txt'), 'wt');
fprintf(fid, '%d ', zoneStruct.grass);
fclose(fid);

fid = fopen(strcat('parent-', saveDir, '.txt'), 'wt');
fprintf(fid, '%s', zoneStruct.parent);
fclose(fid);

% write the contents of the map into a file
ks = keys(map);
fid = fopen(strcat('indoors-', saveDir, '.txt'), 'wt');
for key=ks
    value = map(key{1});
    if length(value) == 2
        line = sprintf('%s#%d,%d', key{1}, value(1), value(2));
    else
        line = sprintf('%s#%d,%d,%d,%d', key{1}, value(1), value(2), value(3), value(4));
    end
    if strcmp(key, ks(end))
        fprintf(fid, '%s', line); % don't add a newline to the last one
    else
        fprintf(fid, '%s\n', line);
    end
end
fclose(fid);

% save the 'loaded data' in a new directory, so we can easily delete it at
% release time
if ~exist(strcat('loadData-', saveDir),  'dir')
    fprintf('making dir\n');
    mkdir(strcat('loadData-', saveDir));
    addpath(strcat('loadData-', saveDir));
end
cd(strcat('loadData-', saveDir));
save('-mat', strcat('layerImage-', saveDir, '.mat'), 'layerImage');
save('-mat', strcat('map-', saveDir, '.mat'), 'map');
save('-mat', strcat('layerAlpha-', saveDir, '.mat'), 'layerAlpha');
%save('-mat', strcat('buffer-', saveDir, '.mat'), 'buffer'); too slow,
%buffer is too big
cd ..;

% eventually save the 'clipboard' (when copy/paste functionality is saved)

% write the flattened 3 layers, and the overlay as images. these are for
% displaying on the iPhone
imwrite(base, strcat('base-', saveDir, '.png'),'Alpha', baseAlpha);
imwrite(layerImage{4}, strcat('overlay-', saveDir, '.png'), 'Alpha', layerAlpha{4});

% get back to the main workspace
cd ..;
cd ..;