
%Clear Workspace
clc;
clear all;

file1 = imread('images/s1.png');
file2 = imread('images/s2.png');

img = file2;

% disp(img);
% error('stop');

sizeX = size(img,1);
sizeY = size(img,2);
img_YCbCr = rgb2ycbcr(img);    % Convert to YCbCr Color Space

% imshow(img_YCbCr);
% disp(img);
% error('stop');

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

% disp(img);
% error('stop');
% imshow(img_YCbCr(:,:,2));

Y_component = img_YCbCr(:,:,1);
Cb_component = img_YCbCr(:,:,2);
Cr_component = img_YCbCr(:,:,3);


Y_component_transformed_linear = jpegEncoder(Y_component, STD_Y_Qt_Mask);
Cb_component_transformed_linear = jpegEncoder(Cb_component, STD_Cb_Cr_Qt_Mask);
Cr_component_transformed_linear = jpegEncoder(Cr_component, STD_Cb_Cr_Qt_Mask);

%  disp(size(Y_component_linear));
%  disp(size(Cb_component_linear));
%  disp(size(Cr_component_linear));

 %  Write the separate components in 3 files

% Now we use the decoder to get back the image.
Y_component_compressed = jpegDecoder(Y_component_transformed_linear, STD_Y_Qt_Mask, sizeX, sizeY);
Cb_component_compressed = jpegDecoder(Cb_component_transformed_linear, STD_Cb_Cr_Qt_Mask, sizeX, sizeY);
Cr_component_compressed = jpegDecoder(Cr_component_transformed_linear, STD_Cb_Cr_Qt_Mask, sizeX, sizeY);

%  disp(size(Y_component));
%  disp(size(Cb_component));
%  disp(size(Cr_component));

newImg_YCbCr(:,:,1) = Y_component_compressed;
newImg_YCbCr(:,:,2) = Cb_component_compressed;
newImg_YCbCr(:,:,3) = Cr_component_compressed;
 
newImg_RGB = ycbcr2rgb(newImg_YCbCr);
imshow(newImg_RGB);
[PSNR1,MSE1,] = measerr(img,newImg_RGB);
fprintf('PeakSignalToNoiseRatio :%f Mean Square Error :%f',PSNR1, MSE1);

