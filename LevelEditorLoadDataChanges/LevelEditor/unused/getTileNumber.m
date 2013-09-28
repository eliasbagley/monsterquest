function num = getTileNumber(flag, row, col, sizes, pxPerGrid)


num = 0;
for i = 1:(flag-1)
    tilesetSize = sizes{i};
    num = num + tilesetSize(1)*tilesetSize(2);
end
tilesetSize = sizes{flag};
num = num + tilesetSize(2)*(row-1)+col;




end