
function [rect button] = getPoint

fig = gcf;
rect = [-1 -1 -1 -1];
button = '';


key = waitforbuttonpress;

if key
    button = get(fig, 'CurrentCharacter');
else
    point = get(fig, 'CurrentPoint');
    rect = [point 0 0];
end
