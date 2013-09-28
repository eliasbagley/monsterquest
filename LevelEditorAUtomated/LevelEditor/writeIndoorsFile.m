% appends to the indoors file where a new doorway is

function writeIndoorsFile(row, col)




global saveDir;
global indoorsX;
global indoorsY;

cd zones;
cd(saveDir);

cmd = sprintf('%d,%d#%d,%d\n', row, col, indoorsX, indoorsY);
fprintf('writing %s', cmd);

fid = fopen(strcat('indoors-', saveDir, '.txt'), 'a+');
fprintf(fid, '%s', cmd);
fclose(fid);

% make them wayy far away from each other
indoorsX = indoorsX + 50;
indoorsY = indoorsY + 50;

cd ..;
cd ..;

fid = fopen('indoorsLocations.txt', 'wt');
fprintf(fid, '%d %d', indoorsX,indoorsY);
fclose(fid);

end


