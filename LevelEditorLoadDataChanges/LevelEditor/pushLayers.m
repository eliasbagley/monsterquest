% save the current stuff
doubleZoneStruct.buffer.image{curr} = doubleZoneStruct.layerImage;
doubleZoneStruct.buffer.alpha{curr} = doubleZoneStruct.layerAlpha;
doubleZoneStruct.buffer.grass{curr} = doubleZoneStruct.grass;
doubleZoneStruct.buffer.obstacles{curr} = doubleZoneStruct.obstacles;
doubleZoneStruct.buffer.objects{curr} = doubleZoneStruct.objects;

zoneStruct.buffer.map{curr} = copy(zoneStruct.map); % these are only creating shallow copies
zoneStruct2.buffer.map{curr} = copy(zoneStruct2.map);
%doubleZoneStruct.buffer.doors{curr} = doubleZoneStruct.doors;
%doubleZoneStruct.buffer.map1{curr} = doubleZoneStruct.map1;
%doubleZoneStruct.buffer.map2{curr} = doubleZoneStruct.map2;
curr = curr + 1;

% reset if it gets too large
if curr > maxChanges
    curr = 1;
end