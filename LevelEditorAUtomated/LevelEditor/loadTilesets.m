%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Elias Bagley
%   Date:   1/29/2012
%   CS 4500 Senior Capstone Project
%   
%  This function looks in the directory specified by path, and loads in the
%  tileset images and alpha channels located there. It also grids each
%  tileset with a pxPerGrid by pxPerGrid black line.
%
%   input:  path, directory of tilesets, ex: 'tiles/'
%           pxPerGrid, the number of pixels wide and high of a grid tile
%
%   output: tilesets, cell array containing the image data of the the tiles
%           alphas, cell array containing the alpha channels of the tiles
%           sizes, a cell array containing the number of tiles for each tileset
%
%
%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tilesets alphas sizes menuChoices gridImage gridAlpha] = loadTilesets(path, pxPerGrid)

% tileset information


filenames = dir(strcat(path, '*.png'));
numberOfTilesets = numel(filenames);
menuChoices = cell(1, numberOfTilesets);
tilesets = cell(1,numberOfTilesets);
alphas = cell(1, numberOfTilesets);
sizes = cell(1, numberOfTilesets);
gridImage = cell(1, numberOfTilesets);
gridAlpha = cell(1, numberOfTilesets);
for i = 1:numel(filenames)
    % load the tileset
    [tileset map alpha] = imread(strcat(path,filenames(i).name));
    
    if length(alpha) == 0
        alpha = ones(size(tileset,1), size(tileset,2));
    end
    
    menuChoices{i} = filenames(i).name;
    
    % save the tileset and alpha values (there are no colormap values)
    tilesets{i} = im2double(tileset);
    alphas{i} = im2double(alpha);
    
    gridImage1 = zeros(size(alpha,1), size(alpha,2));
    gridAlpha1 = gridImage1;
    gridAlpha1(pxPerGrid:pxPerGrid:end,:) = 1; % make the lines opaque
    gridAlpha1(:, pxPerGrid:pxPerGrid:end) = 1;
    
    gridImage{i} = gridImage1;
    gridAlpha{i} = gridAlpha1;
    % store the number of tiles in each tileset
    sizes{i} = size(tileset)/pxPerGrid;
end


end