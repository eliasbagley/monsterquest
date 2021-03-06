

bigLayerImage = cell(1, numLayers);
bigLayerAlpha = cell(1, numLayers);
tic
for i = 1:numLayers
    
    
    a11 = localZoneMap{1,1}.layerImage{i};
    a12 = localZoneMap{1,2}.layerImage{i};
    a13 = localZoneMap{1,3}.layerImage{i};
    a21 = localZoneMap{2,1}.layerImage{i};
    a22 = localZoneMap{2,2}.layerImage{i};
    a23 = localZoneMap{2,3}.layerImage{i};
    a31 = localZoneMap{3,1}.layerImage{i};
    a32 = localZoneMap{3,2}.layerImage{i};
    a33 = localZoneMap{3,3}.layerImage{i};
    
    
    b11 = localZoneMap{1,1}.layerAlpha{i};
    b12 = localZoneMap{1,2}.layerAlpha{i};
    b13 = localZoneMap{1,3}.layerAlpha{i};
    b21 = localZoneMap{2,1}.layerAlpha{i};
    b22 = localZoneMap{2,2}.layerAlpha{i};
    b23 = localZoneMap{2,3}.layerAlpha{i};
    b31 = localZoneMap{3,1}.layerAlpha{i};
    b32 = localZoneMap{3,2}.layerAlpha{i};
    b33 = localZoneMap{3,3}.layerAlpha{i};
    
    
    bigLayerImage{i} = [a11 a12 a13; a21 a22 a23; a31 a32 a33];
    bigLayerAlpha{i} = [b11 b12 b13; b21 b22 b23; b31 b32 b33];
    
    %handles.largeMap = imshow(bigLayerImage, 'InitialMagnification', 100);
    %set(handles.largeMap, 'AlphaData', bigLayerAlpha);
    
    %hold on;
end
toc

tic
[bigLayerImage bigLayerAlpha] = flatten(bigLayerImage, bigLayerAlpha, 1, 4);
toc

tic
handles.overviewHandle = figure;

handles.imageHandle = imshow(bigLayerImage, 'InitialMagnification', 100);
% imageAlpha was modified: evaluate this change later
set(handles.imageHandle, 'AlphaData', bigLayerAlpha);
handles.scrollPanelHandle = imscrollpanel(handles.overviewHandle, handles.imageHandle);
api = iptgetapi(handles.scrollPanelHandle);


set(handles.scrollPanelHandle,'Units','normalized','Position',[0 .1 1 .9])

% Add a magnification box and an overview tool
handles.hMagBox = immagbox(handles.mapFigureHandle, handles.imageHandle);
pos = get(handles.hMagBox,'Position');
set(handles.hMagBox,'Position',[0 0 pos(3) pos(4)])
imoverview(handles.imageHandle)
toc



%hold off;


