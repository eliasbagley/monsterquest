% flattens layers from the bottom layer, through the top layer (inclusive)
function [flattenedImage flattenedAlpha] = flatten(layerImage, layerAlpha,bottomLayer, topLayer)

flattenedImage = layerImage{bottomLayer};
flattenedAlpha =layerAlpha{bottomLayer};
for i=bottomLayer:topLayer-1
    [flattenedImage flattenedAlpha] = alphaCompFunc(layerImage{i+1}, layerAlpha{i+1}, flattenedImage, flattenedAlpha);
end