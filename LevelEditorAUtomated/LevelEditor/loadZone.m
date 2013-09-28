% loads the information for a zone

% first, save the current directory so we know where to go back to
function zoneStruct = loadZone(zoneDirStr)

global blankZoneStruct;
global pxPerGrid;

cd zones;
if ~exist(zoneDirStr, 'dir')
    cd ..;
    zoneStruct = blankZoneStruct;
    zoneStruct.name = zoneDirStr;
    return;
end
cd ..;


% save location of current dir
%currentDir = pwd;

% next, change to the new directory
%cd(zoneDirStr);

% load all the information there
%cd zones;
% get the location as the last part of the full path
%cd(zoneDirStr)

%cd(strcat('loadData-', zoneDirStr));

zoneStruct = load(strcat('layerImage-', zoneDirStr, '.mat'));
a = load(strcat('layerAlpha-', zoneDirStr, '.mat')); % matlab saves things into structs funny
zoneStruct.layerAlpha = a.layerAlpha;
%b = load(strcat('buffer-', zoneDirStr, '.mat'));
%zoneStruct.buffer = b.buffer;
%cd ..;

if exist(strcat('map-', zoneDirStr, '.mat'), 'file')
    a = load(strcat('map-', zoneDirStr, '.mat')); % matlab saves things into structs funny
    zoneStruct.map = a.map;
else
    zoneStruct.map = containers.Map();
end

if exist(strcat('parent-', zoneDirStr, '.txt'), 'file')
    fid = fopen(strcat('parent-', zoneDirStr, '.txt'));
    zoneStruct.parent = fscanf(fid, '%d', [1 2]);
    fclose(fid);
else
    zoneStruct.parent = 0;
end


fid = fopen(strcat('obstacles-', zoneDirStr, '.txt'));
zoneStruct.obstacles = fscanf(fid, '%d', [16*32/pxPerGrid 16*32/pxPerGrid]);
fclose(fid);

fid = fopen(strcat('grass-', zoneDirStr, '.txt'));
zoneStruct.grass = fscanf(fid, '%d', [16*32/pxPerGrid 16*32/pxPerGrid]);
fclose(fid);

obsSize = size(zoneStruct.obstacles);

% special case for backwards compatibility of obstacle sizes
if (obsSize(1) ~= 32 || obsSize(2) ~= 32)
    zoneStruct.obstacles = zeros(32, 32);
    zoneStruct.grass = zeros(32, 32);
end



%zoneStruct.obstacles = load(strcat('obstacles-', zoneDirStr, '.txt'));
%zoneStruct.grass = load(strcat('grass-', zoneDirStr, '.txt'));


%cd ..;
% other constants maybe should be reset, but idk
%zoneStruct.flag = 0; % so that it will draw on the map figure
zoneStruct.name = zoneDirStr;
%cd ..;
% change back to the currentDir
%cd(currentDir);


end