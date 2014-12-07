function output_array = jpegDecoder(linear_array, mask, dctTransform)

% Custom Block Size
BlockSize = 8;
k = 1;
SqDim = sqrt(size(linear_array,2));

stepSize = BlockSize*BlockSize;
sizeXPrime = SqDim/BlockSize; 
sizeYPrime = SqDim/BlockSize;

for i=1:1:sizeXPrime
    for j=1:1:sizeYPrime
        BlockCell{i,j} = invZigzag(linear_array(1,k:(k + stepSize - 1)));
        k = k + stepSize;
    end
end
fprintf('Inverse Zigzag Scan Completed\n');

%   SubBlockCell = mat2cell(inputmatrix,dim1Dist,dim2Dist);
   HSizeCell = size(BlockCell,1);
   WSizeCell = size(BlockCell,2);
   
  %  Multiply by mask to obtain inverse
  for i=1:1:HSizeCell
      for j=1:1:WSizeCell
        BlockCell{i,j} = BlockCell{i,j}.*mask;
      end
  end
  
  % Initialise transform cells
  TransformedCell_IDCT = cell(HSizeCell,WSizeCell);
  for i=1:HSizeCell
      for j=1:WSizeCell
          if (dctTransform)   
            TransformedCell_IDCT{i,j} = idct2(BlockCell{i,j});
          else
            TransformedCell_IDCT{i,j} = real(ifft2(BlockCell{i,j}));
          
          end
      end
  end
  fprintf('Inverse Transformation Completed\n');
  
  output_array = cell2mat(TransformedCell_IDCT);
  
% Level Offset (Shift from mean by adding 128)
offsetMatrix = ones(SqDim,SqDim).*128;
output_array = output_array + offsetMatrix;
output_array = uint8(output_array);
fprintf('Level Offset Recovered\n');
end