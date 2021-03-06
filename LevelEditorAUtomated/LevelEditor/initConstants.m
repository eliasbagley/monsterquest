% initialize all constants and load stuff

%% define constants and initialize stuff

% create worker threads
%matlabpool
% create a 3x3 cell array for holding 8 point connectivity zones


%direction = [-1 0]; % default direction shows right
directionStr = 'NONE';
global blankZoneStruct;
global snap;
global localZoneMap;
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
localZoneMap = cell(3, 3);
collisionToggle = 0;
vert = 0;
interval = -1; % determines how many cells before repeating a tiling. -1 is selected tile size
selectMethod = 0; % 0 is rect, 1 is getpts
currentLayer = 1; % 1 is base layer, 2 is low overlayers, 3 is tall grass, 4 is overlays
eraser = 0; % toggles whether the eraser is active or not
pxPerGrid = 16; % each tile is 32 x 32
needToRestore = 0; % used for saving/restoring selectedTile when using eraser
snap = 1; % toggle snap to grid functionality

curr = 1; % acts as a stack and saves every change
showAllToggle = 0;
%           [height width] in px, of the 'zone' to be made
numLayers = 5;
%           [height width] in px, of the 'zone' to be made
gridSize = [16*32/pxPerGrid 16*32/pxPerGrid];
imageSize = [pxPerGrid*gridSize(1) pxPerGrid*gridSize(2)];
maxChanges = 5;


% create a blank image black and fully transparent
imageMatrix = (zeros(imageSize(1), imageSize(2), 3));
imageAlpha  = (zeros(imageSize(1), imageSize(2)));

blankZoneStruct.layerImage = cell(1, numLayers); % ground, obstacles, tall grass, overlays
blankZoneStruct.layerAlpha = cell(1, numLayers+1); % alpha channel for each of the images

% initialize all the layers to 'blank'
for i=1:numLayers
    blankZoneStruct.layerImage{i} = imageMatrix;
    blankZoneStruct.layerAlpha{i} = imageAlpha;
end
blankZoneStruct.layerAlpha{6} = imageAlpha;

% only grid the last layer, as this is always the 'grid' layer
% grid the image with blank lines
imageMatrix(pxPerGrid:pxPerGrid:end,:,:) = 0.0; % every PXth row to black
imageMatrix(:, pxPerGrid:pxPerGrid:end, :) = 0.0;
imageAlpha(pxPerGrid:pxPerGrid:end,:,:) = 1.0; % every PXth row to opaque
imageAlpha(:, pxPerGrid:pxPerGrid:end, :) = 1.0;


blankZoneStruct.layerImage{numLayers} = imageMatrix; % set it to the last layer
blankZoneStruct.layerAlpha{numLayers} = imageAlpha;

blankZoneStruct.map = containers.Map(); %maps local rows/col to zone numbers and row col in that zone
blankZoneStruct.parent = []; %might want a better default 

% the data to be exported
blankZoneStruct.grass = zeros(gridSize(1), gridSize(2));
blankZoneStruct.obstacles = zeros(gridSize(1), gridSize(2));

% if we have to create a new zone, we have to create a new buffer too
blankZoneStruct.buffer.image = cell(1,maxChanges);
blankZoneStruct.buffer.alpha = cell(1, maxChanges);
% add buffers for the grass and obstacle matricies also
blankZoneStruct.buffer.grass = cell(1, maxChanges);
blankZoneStruct.buffer.obstacles = cell(1, maxChanges);
blankZoneStruct.buffer.map1 = cell(1,maxChanges);
blankZoneStruct.buffer.map2 = cell(1,maxChanges);









%% load in the tile sets (more tilesets to come)
[tilesets alphas sizes menuChoices gridImage gridAlpha] = loadTilesets('tiles/', pxPerGrid);

% figure out what folder to save this in
saveDir = inputdlg('What is the world location of this zone (save directory name)?', 'Save World Location', 1, {'0,0'});
saveDir = saveDir{1}; % no reason why it should be a cell, so convert to str
if isempty(saveDir)
    saveDir = 'zone'; % if they press cancel, save it in the old zone folder
end

% load all the zones around this one
%localZoneMap = loadLocalZones(localZoneMap, saveDir, [0 0]);
parentZone = blankZoneStruct;
% create the blank layers
initLayers;


%prevZone = localZoneMap{2, 3}; % right zone will be default

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
hold on;
h4 = imshow(doubleZoneStruct.layerImage{4});
set(h4, 'AlphaData', doubleZoneStruct.layerAlpha{4});
hold on;
h5 = imshow(doubleZoneStruct.layerImage{5});
set(h5, 'AlphaData', doubleZoneStruct.layerAlpha{5});
hold off;

%h =          imshow(doubleZoneStruct.layerImage{i}, 'InitialMagnification', 100);
%set(h, 'AlphaData', doubleZoneStruct.layerAlpha{i});

%handles.ax2 = axes;

%get(mapFigureHandle)
%handles.imageHandle = imshow(imageMatrix, 'InitialMagnification', 100);
% imageAlpha was modified: evaluate this change later
%set(handles.imageHandle, 'AlphaData', imageAlpha);
%handles.scrollPanelHandle = imscrollpanel(handles.mapFigureHandle, handles.imageHandle);
%api = iptgetapi(handles.scrollPanelHandle);


%set(handles.scrollPanelHandle,'Units','normalized','Position',[0 .1 1 .9])

% Add a magnification box and an overview tool
%handles.hMagBox = immagbox(handles.mapFigureHandle, handles.imageHandle);
%pos = get(handles.hMagBox,'Position');
%set(handles.hMagBox,'Position',[0 0 pos(3) pos(4)])
%imoverview(handles.imageHandle)

handles.tileFigureHandle = figure('Name', 'Tileset-');
% start by selecting a tile
%figure(handles.tileFigureHandle);

prevFlag = 0;
%flag = menu('Choose a Tileset', menuChoices);
 flag = floor(12*rand);