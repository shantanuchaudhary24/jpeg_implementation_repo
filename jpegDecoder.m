function output_array = jpegDecoder(linear_array, mask, sizeX, sizeY)

% Custom Block Size
 BlockSize = 8;
k = 1;
for i=1:1:(BlockSize*BlockSize)
    for j=1:1:(BlockSize*BlockSize)
        BlockCell{i,j} = invZigzag(linear_array(k:(k+63)));
        k = k + 64;
    end
end


%   SubBlockCell = mat2cell(inputmatrix,dim1Dist,dim2Dist);
   HSizeCell = size(BlockCell,1);
   WSizeCell = size(BlockCell,2);

%     disp(BlockCell{1,1});
%   disp(TransformedCell_IDCT{1,2});
%   error('Stop'); 
   
  %  Multiply by mask to obtain inverse
  for i=1:1:HSizeCell
      for j=1:1:WSizeCell
        BlockCell{i,j} = BlockCell{i,j}.*mask;
      end
  end
  
%     disp(BlockCell{1,1});
% %   disp(TransformedCell_IDCT{1,2});
%   error('Stop'); 
  
  
  % Initialise transform cells
  TransformedCell_IDCT = cell(HSizeCell,WSizeCell);
  % error('Stop');
  for i=1:HSizeCell
      for j=1:WSizeCell
          TransformedCell_IDCT{i,j} = idct2(BlockCell{i,j});
%           disp(SubBlockCell{i,j});
%           error('Stop');
      end
  end
%    disp(BlockCell{1,1});
%    disp(TransformedCell_IDCT{1,1});
%    error('Stop');  
  output_array = cell2mat(TransformedCell_IDCT);
  
% Level Offset (Shift to mean by subtracting 128)
offsetMatrix = ones(sizeX,sizeY).*128;
output_array = output_array + offsetMatrix;
output_array = uint8(output_array);

end