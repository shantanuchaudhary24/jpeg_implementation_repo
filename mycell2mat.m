function outputMatrix = mycell2mat(cellInput)

SizeX = size(cellInput,1);
SizeY = size(cellInput,2);
outputMatrix = [];
    for j=1:1:SizeY
        outputMatrix(j) = str2double(cellInput{1,j});
    end
    
end