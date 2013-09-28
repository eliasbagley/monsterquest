% creates a deep copy of a map (copies all properties), rather than just
% copying the address
function mapCopy = copy(map)

if isempty(map)
    mapCopy = containers.Map();
    return;
end

mapCopy = containers.Map();
ks = keys(map);

for key = ks
    mapCopy(key{1}) = map(key{1});
end