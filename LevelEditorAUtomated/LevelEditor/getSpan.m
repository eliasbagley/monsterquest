%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Elias Bagley
%   Date:   1/29/2012
%   CS 4500 Senior Capstone Project
%
%  This function returns the number of rows and columns that the user
%  dragged as a result of the getrect function call, given the pixel size
%  of a grid. Also returns the starting x and y (upper left) pixel location
%  of the upper left tile selected.
%
%   input:  rect, [x y width height], result of getrect()
%           pxPerGrid, the number of pixels wide and high of a grid tile
%
%   output: numRow       - number of tiles in height that the user drug
%           numCol       - number of tiles in width that the user drug
%           yStartPxTile - y pixel of top left tile
%           xStartPxTile - x pixel of top left tile
%           [row col]    - index of top left tile
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [numRow numCol yStartPx xStartPx row col] = getSpan(rect, pxPerGrid)

global snap;

x = rect(1);
y = rect(2);
width = rect(3);
height = rect(4);

% finds the starting pixel of the snap to grid
if snap
    xStartPx = x - mod(x, pxPerGrid)+1;
    yStartPx = y - mod(y, pxPerGrid)+1;
else
    xStartPx = floor(x);
    yStartPx = floor(y);
end

x_bottomRight = x+width; %problem: what about pxPerGrid here
y_bottomRight = y+height;

x_bottomRightStart = x_bottomRight - mod(x_bottomRight, pxPerGrid)+1;
y_bottomRightStart = y_bottomRight - mod(y_bottomRight, pxPerGrid)+1;


% determines the number of rows and columns that the user selected
% with the getrect function (verified works)
numRow = (y_bottomRightStart-yStartPx)/pxPerGrid+1;
numCol = (x_bottomRightStart-xStartPx)/pxPerGrid+1;

% index of the top left selected
row = (yStartPx-1)/pxPerGrid+1;
col = (xStartPx-1)/pxPerGrid+1;

end
