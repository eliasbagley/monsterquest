% save the current stuff
doubleZoneStruct.buffer.image{curr} = doubleZoneStruct.layerImage;
doubleZoneStruct.buffer.alpha{curr} = doubleZoneStruct.layerAlpha;
doubleZoneStruct.buffer.grass{curr} = doubleZoneStruct.grass;
doubleZoneStruct.buffer.obstacles{curr} = doubleZoneStruct.obstacles;
doubleZoneStruct.buffer.map1{curr} = doubleZoneStruct.map1;
doubleZoneStruct.buffer.map2{curr} = doubleZoneStruct.map2;
curr = curr + 1;

% reset if it gets too large
if curr > maxChanges
    curr = 1;
end