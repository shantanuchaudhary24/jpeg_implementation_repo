function code_img(img, encodingScheme)
sizeX = size(img,1);
sizeY = size(img,2);
img_YCbCr = rgb2ycbcr(img);    % Convert to YCbCr Color Space

if (strcmp(encodingScheme,'DCT'))
    DCT = 1;
else
    DCT = 0;
end

% Standard JPEG Quantization Tables for Y Component
STD_Y_Qt_Mask = [
    16,  11,  10,  16,  24,  40,  51,  61
    12,  12,  14,  19,  26,  58,  60,  55
    14,  13,  16,  24,  40,  57,  69,  56
    14,  17,  22,  29,  51,  87,  80,  62
    18,  22,  37,  56,  68, 109, 103,  77
    24,  35,  55,  64,  81, 104, 113,  92
    49,  64,  78,  87, 103, 121, 120, 101
    72,  92,  95,  98, 112, 100, 103,  99];

% Standard JPEG Quantization Table for Cb Cr Components
STD_Cb_Cr_Qt_Mask = [
    17,  18,  24,  47,  99,  99,  99,  99
    18,  21,  26,  66,  99,  99,  99,  99
    24,  26,  56,  99,  99,  99,  99,  99
    47,  66,  99,  99,  99,  99,  99,  99
    99,  99,  99,  99,  99,  99,  99,  99
    99,  99,  99,  99,  99,  99,  99,  99
    99,  99,  99,  99,  99,  99,  99,  99
    99,  99,  99,  99,  99,  99,  99,  99];

Y_component = img_YCbCr(:,:,1);
Cb_component = img_YCbCr(:,:,2);
Cr_component = img_YCbCr(:,:,3);

fprintf('Color Transformation Completed!\n');

% SubSample Cb and Cr color components
Cb_component_subsampled = SubSample(Cb_component);
Cr_component_subsampled = SubSample(Cr_component);
fprintf('Subsampling Completed!\n');

Y_component_transformed_linear = jpegEncoder(Y_component, STD_Y_Qt_Mask, DCT);
fprintf('Encoded Y Component\n');

Cb_component_transformed_linear = jpegEncoder(Cb_component_subsampled, STD_Cb_Cr_Qt_Mask, DCT);
fprintf('Encoded Cb Component\n');

Cr_component_transformed_linear = jpegEncoder(Cr_component_subsampled, STD_Cb_Cr_Qt_Mask, DCT);
fprintf('Encoded Cr Component\n');

% Space separated valued are written to a file
dlmwrite('Encoded.txt',Y_component_transformed_linear);
dlmwrite('Encoded.txt',Cb_component_transformed_linear,'-append');
dlmwrite('Encoded.txt',Cr_component_transformed_linear,'-append');

% java CoolCoolEncoderDecoder [filename] [1 for encode the content of filename / 2 for printing out decoded version of the content of filename]
str_cmd = 'java CoolCoolEncoderDecoder Encoded.txt 1';
[status, cmdout] = unix(str_cmd);

fprintf('Run Length Encoding/Decoding Complete\n');

str_cmd = 'java CoolCoolEncoderDecoder Encoded.txt 2';
[status, cmdout] = unix(str_cmd);

C = strsplit(cmdout, '_');

fprintf('Decoding JPEG\n');
Y_component_decoded = strsplit(C{1,1}, ',');
Cb_component_decoded = strsplit(C{1,2}, ',');
Cr_component_decoded = strsplit(C{1,3}, ',');

Y_component_decoded = mycell2mat(Y_component_decoded);
Cb_component_decoded = mycell2mat(Cb_component_decoded);
Cr_component_decoded = mycell2mat(Cr_component_decoded);

% Now we use the decoder to get back the image.
 Y_component_compressed = jpegDecoder(Y_component_decoded, STD_Y_Qt_Mask, DCT);
 fprintf('Y Component Decoded\n');
 
 Cb_component_compressed = jpegDecoder(Cb_component_decoded, STD_Cb_Cr_Qt_Mask, DCT);
 fprintf('Cb Component Decoded\n');
 
 Cr_component_compressed = jpegDecoder(Cr_component_decoded, STD_Cb_Cr_Qt_Mask, DCT);
 fprintf('Cr Component Decoded\n');

 % Super sample Cb and Cr
 Cb_component_superSampled = SuperSample(Cb_component_compressed);
 fprintf('Supersampling Cb Component\n');
 
 Cr_component_superSampled = SuperSample(Cr_component_compressed);
 fprintf('Supersampling Cr Component\n');
 
 newImg_YCbCr(:,:,1) = Y_component_compressed;
 newImg_YCbCr(:,:,2) = Cb_component_superSampled;
 newImg_YCbCr(:,:,3) = Cr_component_superSampled;
 
 newImg_RGB = ycbcr2rgb(newImg_YCbCr);
 fprintf('Converted to RGB Colo Space\n');
 
 subplot(1,2,1), imshow(img)
 subplot(1,2,2), imshow(newImg_RGB)

 [PSNR1,MSE1,] = measerr(img,newImg_RGB);
 fprintf('PeakSignalToNoiseRatio :%f Mean Square Error :%f\n',PSNR1, MSE1);


end