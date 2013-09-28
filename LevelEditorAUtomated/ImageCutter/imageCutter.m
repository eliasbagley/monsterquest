% image cutting script

[largeImage map largeAlpha] = imread('bigset.png');
resultSize = [24 24];


imageSize = size(largeImage);

imageNumber = 0;

currX = 1;
currY = 1;

for row=1:resultSize(1):imageSize(1)
    for col=1:resultSize(2):imageSize(2)
        tileImage = largeImage(row:row+resultSize(1)-1, col:col+resultSize(2)-1, :);
        tileAlpha = largeAlpha(row:row+23, col:col+23, :);
        cd tiles;
        imageNumber = imageNumber + 1;
        imwrite(tileImage, sprintf('%d-%d.png', currX, currY), 'Alpha', tileAlpha );
        
        if mod(imageNumber, 100) == 0
            fprintf('Writing image %d\n', imageNumber);
        end
        
        cd ..;
        
        currX = currX + 1;
        
    end     
    currX = 1;
    currY = currY + 1;
end
