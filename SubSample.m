function outputMatrix = SubSample(inputMatrix)
sizeX = size(inputMatrix,1);
sizeY = size(inputMatrix,2);
samplingFactor = 2;
sizeXPrime = sizeX/samplingFactor;
sizeYPrime = sizeY/samplingFactor;
outputMatrix = zeros(sizeXPrime,sizeYPrime);
for i=1:1:sizeXPrime
    for j=1:1:sizeYPrime
        outputMatrix(i,j) = inputMatrix(1+(i-1)*samplingFactor,1+(j-1)*samplingFactor);
    end
end

end