

function zigzag_array = jpegEncoder(inputmatrix, mask)


inputmatrix = double(inputmatrix);
Hsize = size(inputmatrix,1);
Wsize = size(inputmatrix,2);
% disp(inputmatrix(1:3));

% Level Offset (Shift to mean by subtracting 128)
offsetMatrix = ones(Hsize,Wsize).*128;
inputmatrix = inputmatrix - offsetMatrix;
% disp(inputmatrix(1:3));
% error('Stop');


% Custom Block Size
 BlockSize = 8;
 XDim = Hsize/BlockSize;
 YDim = Wsize/BlockSize;
%  XDim = floor(XDim);
%  YDim = floor(YDim);

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
 

% Verification for correct sub block creation. We compare 1 created cell with 1
% sub block of direct input image for verification.
%  disp(SubBlockCell{1,1});
%  disp(inputmatrix(1:8,1:8));
%  error('stop');

HSizeCell = size(SubBlockCell,1);
WSizeCell = size(SubBlockCell,2);

% Initialise transform cells
TransformedCell_DCT = cell(HSizeCell,WSizeCell);
% error('Stop');

% disp(SubBlockCell{1,1});

for i=1:HSizeCell
    for j=1:WSizeCell
        TransformedCell_DCT{i,j} = dct2(SubBlockCell{i,j});
%         disp(TransformedCell_DCT{i,j});
    end
end



% Quantize according to standard JPEG quantization tables 
for i=1:HSizeCell
    for j=1:WSizeCell
        TransformedCell_DCT{i,j} = round(TransformedCell_DCT{i,j}./mask);
    end
end

% disp(TransformedCell_DCT{1,1});


% ZigZag Scan on each cell
zigzag_array = [];
for i=1:HSizeCell
    for j=1:WSizeCell
        linear_cell = zigzag(TransformedCell_DCT{i,j});
        zigzag_array = [zigzag_array linear_cell];
%         disp(zigzag_array);
%         error('YOda');  
        
    end
%      disp(TransformedCell_DCT{1,2});
%      disp(zigzag_array(65:67));
%      error('YOda');
end
%  disp(size(zigzag_array));
% Run Legth Coding
end

