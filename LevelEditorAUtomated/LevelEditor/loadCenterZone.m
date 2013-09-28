% display everything?
%displayLayers;

% load center zone

%zoneStruct = localZoneMap{2,2};

if ~isempty(zoneStruct)
    %obstacles = zoneStruct.obstacles;
    %grass = zoneStruct.grass;
    %layerImage = zoneStruct.layerImage;
    %layerAlpha = zoneStruct.layerAlpha;
%     
%     for i = 1:numLayers
%         layerImage{i} = zoneStruct.layerImage.layerImage; %idk what the deal is here
%         layerAlpha{i} = zoneStruct.layerAlpha.layerAlpha;
%     end
else % if it's empty, there's no saved data here, so create a blank zone
    initLayers; % blanks layer information back out to zero
end