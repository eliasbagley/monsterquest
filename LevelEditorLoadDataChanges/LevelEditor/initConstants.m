% initialize all constants and load stuff

%% define constants and initialize stuff

directionStr = 'NONE';
global blankZoneStruct;
global gridSize;
global pxPerGrid;
global saveDir;
global indoorsX;
global indoorsY;

% for making the locations of the indoors stuff persistant
fid = fopen('indoorsLocations.txt');
tempArr = fscanf(fid, '%d', [1 2]);
fclose(fid);
indoorsX = tempArr(1);
indoorsY = tempArr(2);

grid = 1; % toggles gridlines on/off
settingBackpointer = 0;
move = 0;
indoors = 0;
copyMode = 0; % if copying is enabled/disabled
collisionToggle = 0;
vert = 0;
selectMethod = 0; % 0 is rect, 1 is getpts
currentLayer = 1; % 1 is base layer, 2 is low overlayer, 3 is tall grass, 4 is overlays
eraser = 0; % toggles whether the eraser is active or not
pxPerGrid = 16; % each tile is 32 x 32
needToRestore = 0; % used for saving/restoring selectedTile when using eraser

curr = 1; % acts as a stack and saves every change
%           [height width] in px, of the 'zone' to be made
numLayers = 3; % base overlay grid
%           [height width] in px, of the 'zone' to be made
gridSize = [16*32/pxPerGrid 16*32/pxPerGrid];
imageSize = [pxPerGrid*gridSize(1) pxPerGrid*gridSize(2)];
maxChanges = 15;


% create a blank image black and fully transparent
imageMatrix = (zeros(imageSize(1), imageSize(2), 3));
imageMatrixWhite = (ones(imageSize(1), imageSize(2), 3));
imageAlpha  = (zeros(imageSize(1), imageSize(2)));

blankZoneStruct.layerImage = cell(1, numLayers); % ground, obstacles, tall grass, overlays
blankZoneStruct.layerAlpha = cell(1, numLayers); % alpha channel for each of the images

% initialize all the layers to 'blank'
for i=1:numLayers
    blankZoneStruct.layerImage{i} = imageMatrix;
    blankZoneStruct.layerAlpha{i} = imageAlpha;
end


% only grid the last layer, as this is always the 'grid' layer
% grid the image with blank lines
imageMatrixWhite(pxPerGrid:pxPerGrid:end,:,:) = 0.0; % every PXth row to black
imageMatrixWhite(:, pxPerGrid:pxPerGrid:end, :) = 0.0;

imageAlpha(pxPerGrid:pxPerGrid:end,:,:) = 1.0; % every PXth row to opaque
imageAlpha(:, pxPerGrid:pxPerGrid:end, :) = 1.0;

blankZoneStruct.layerImage{numLayers} = imageMatrixWhite; % set it to the last layer
blankZoneStruct.layerAlpha{numLayers} = imageAlpha;

blankZoneStruct.map = containers.Map(); %maps local rows/col to zone numbers and row col in that zone
blankZoneStruct.parent = []; % empty means that there's no parent zone


% the data to be exported
blankZoneStruct.grass = zeros(gridSize(1), gridSize(2));
blankZoneStruct.obstacles = zeros(gridSize(1), gridSize(2));
blankZoneStruct.objects = cell(gridSize(1), gridSize(2));



% if we have to create a new zone, we have to create a new buffer too
blankZoneStruct.buffer.image = cell(1,maxChanges);
blankZoneStruct.buffer.alpha = cell(1, maxChanges);
% add buffers for the grass and obstacle matricies also
blankZoneStruct.buffer.grass = cell(1, maxChanges);
blankZoneStruct.buffer.objects = cell(1, maxChanges);
blankZoneStruct.buffer.obstacles = cell(1, maxChanges);


blankZoneStruct.buffer.map = cell(1, maxChanges);



%% load in the tile sets (more tilesets to come)
[tilesets alphas sizes menuChoices gridImage gridAlpha] = loadTilesets('tiles/', pxPerGrid);

% figure out what folder to save this in
saveDir = inputdlg('What is the world location of this zone (save directory name)?', 'Save World Location', 1, {'0,0'});
if isempty(saveDir)
    saveDir = '-100000,-100000'; % if they press cancel, save it in some junk spot far away
else
    saveDir = saveDir{1}; % no reason why it should be a cell, so convert to str 
end

parentZone = blankZoneStruct;
parentZone.map = copy(blankZoneStruct.map);

% create the blank layers
initLayers;

%% show the tileset to allow picking and set up figures

%handles.ax1 = axes;
% show the blank canvas
handles.mapFigureHandle = figure('Name', strcat('Map-', saveDir, 'Base Layer'), 'Color', [139 69 19]/255.0);

h1 = imshow(doubleZoneStruct.layerImage{1}, 'InitialMagnification', 100);
set(h1, 'AlphaData', doubleZoneStruct.layerAlpha{1});
hold on;
h2 = imshow(doubleZoneStruct.layerImage{2});
set(h2, 'AlphaData', doubleZoneStruct.layerAlpha{2});
hold on;
h3 = imshow(doubleZoneStruct.layerImage{3});
set(h3, 'AlphaData', doubleZoneStruct.layerAlpha{3});
hold off;


handles.tileFigureHandle = figure('Name', 'Tileset-');

prevFlag = 0;
flag = menu('Choose a Tileset', menuChoices);