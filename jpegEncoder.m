

function zigzag_array = jpegEncoder(inputmatrix, mask, dctTransform)

inputmatrix = double(inputmatrix);
Hsize = size(inputmatrix,1);
Wsize = size(inputmatrix,2);

% Level Offset (Shift to mean by subtracting 128)
offsetMatrix = ones(Hsize,Wsize).*128;
inputmatrix = inputmatrix - offsetMatrix;


% Custom Block Size
BlockSize = 8;
XDim = Hsize/BlockSize;
YDim = Wsize/BlockSize;

dim1Dist = zeros(1,XDim);
dim2Dist = zeros(1,YDim);

for i = 1:XDim
    dim1Dist(i) = BlockSize;
end

for i = 1:YDim
    dim2Dist(i) = BlockSize;
end

% Convert to subblocks using MAT2CELL
SubBlockCell = mat2cell(inputmatrix,dim1Dist,dim2Dist);
fprintf('Sub Block Conversion Completed\n');

HSizeCell = size(SubBlockCell,1);
WSizeCell = size(SubBlockCell,2);

% Initialise transform cells
TransformedCell_DCT = cell(HSizeCell,WSizeCell);

for i=1:HSizeCell
    for j=1:WSizeCell
        if (dctTransform)
            TransformedCell_DCT{i,j} = dct2(SubBlockCell{i,j});
        else
            TransformedCell_DCT{i,j} = real(fft2(SubBlockCell{i,j}));    
        end
    end
end
fprintf('Transformation to frequency domain completed\n');


% Quantize according to standard JPEG quantization tables 
for i=1:HSizeCell
    for j=1:WSizeCell
        TransformedCell_DCT{i,j} = round(TransformedCell_DCT{i,j}./mask);
    end
end
fprintf('Coefficients Have been quantised\n');

% ZigZag Scan on each cell
zigzag_array = [];
for i=1:HSizeCell
    for j=1:WSizeCell
        linear_cell = zigzag(TransformedCell_DCT{i,j});
        zigzag_array = [zigzag_array linear_cell];
        
    end
end
end

