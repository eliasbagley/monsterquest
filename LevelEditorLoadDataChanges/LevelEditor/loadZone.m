% loads the information for a zone

% first, save the current directory so we know where to go back to
function zoneStruct = loadZone(zoneDirStr)

global pxPerGrid;

cd zones;
if ~exist(zoneDirStr, 'dir')
    cd ..;
    zoneStruct = blankZone(zoneDirStr);
    return;
end


cd(zoneDirStr);

% load the parent text file too
fid = fopen(strcat('parent-', zoneDirStr, '.txt'));
zoneStruct.parent = fscanf(fid, '%d', [1 4]);
fclose(fid);

fid = fopen(strcat('obstacles-', zoneDirStr, '.txt'));
zoneStruct.obstacles = fscanf(fid, '%d', [16*32/pxPerGrid 16*32/pxPerGrid]);
fclose(fid);

fid = fopen(strcat('grass-', zoneDirStr, '.txt'));
zoneStruct.grass = fscanf(fid, '%d', [16*32/pxPerGrid 16*32/pxPerGrid]);
fclose(fid);

% read the objects array
fid = fopen(strcat('objects-', zoneDirStr, '.txt'));
zoneStruct.objects = cell(16*32/pxPerGrid,16*32/pxPerGrid);
InputText = textscan(fid,'%s',4,'delimiter','\n');
for i = 1:size(InputText{1,1},1)
    line = regexp(InputText{1,1}{i},'#','split');
    index = str2num(line{1});
    zoneStruct.objects{index(1), index(2)} = line{2};
end

fclose(fid);

fid = fopen(strcat('indoors-', zoneDirStr, '.txt'));
zoneStruct.map = containers.Map();
InputText = textscan(fid, '%s', 4, 'delimiter', '\n');
for i = 1:size(InputText{1,1}, 1)
     line = regexp(InputText{1,1}{i},'#','split');
   zoneStruct.map(line{1}) = str2num(line{2});
end
fclose(fid);

%map = load(strcat('map-', zoneDirStr, '.mat'));
%zoneStruct.map = map.map;


[image map alpha] = imread(strcat('base-', zoneDirStr, '.png')); % layer 1 is still the base
zoneStruct.layerImage{1} = im2double(image);
zoneStruct.layerAlpha{1} = im2double(alpha);

[image map alpha] = imread(strcat('overlay-', zoneDirStr, '.png')); % layer 2 is now the overlay
zoneStruct.layerImage{2} = im2double(image);
zoneStruct.layerAlpha{2} = im2double(alpha);

[image map alpha] = imread(strcat('grid-', zoneDirStr, '.png')); % layer 3 is now the grid
zoneStruct.layerImage{3} = im2double(image);
zoneStruct.layerAlpha{3} = im2double(alpha);


zoneStruct.name = zoneDirStr;



cd ..; % cd out of the current zone
cd ..; % cd out of the zones folder

end