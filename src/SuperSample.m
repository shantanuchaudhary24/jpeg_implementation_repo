function outputMatrix = SuperSample(inputMatrix)
samplingFactor = 2;
sizeX = size(inputMatrix,1);
sizeY = size(inputMatrix,2);
sizeXPrime = sizeX*samplingFactor;
sizeYPrime = sizeY*samplingFactor;
outputMatrix = zeros(sizeXPrime,sizeYPrime);
for i=1:1:sizeX
    for j=1:1:sizeY
        scaledI = 1 + (i-1)*samplingFactor;
        scaledJ = 1 + (j-1)*samplingFactor;
        outputMatrix(scaledI,scaledJ) = inputMatrix(i,j);
        outputMatrix(scaledI+1,scaledJ+1) = inputMatrix(i,j);
        outputMatrix(scaledI+1,scaledJ) = inputMatrix(i,j);
        outputMatrix(scaledI,scaledJ+1) = inputMatrix(i,j); 
    end
end

end