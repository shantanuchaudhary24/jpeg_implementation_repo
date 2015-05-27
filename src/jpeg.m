
%Clear Workspace
clc;
clear all;

file1 = imread('images/s1.png');
file2 = imread('images/s2.png');
file3 = imread('images/s3.bmp');

img = file1;

% General Steps involved in JPEG encoding
% Color Space Transformation (RGB -> YCbCr)
% Subsample Cb, Cr Component (We have employed 4-1-1)
% Encoding each of the color components:
%   Shift to mean (Subtract 128)
%   Convert to sub-blocks, perform transformation, quantize values
%   Perform ZigZag Scan, linearise the block stream, write to file
%   Perform Run Length Encoding

% General Steps involved in JPEG Decoding
% Run length Decoding from file
% Decoding each of the color components:
%     Inverse ZigZag scan on linear array to convert to subblocks
%     Multiple by mask to obtain inverse values
%     Perform Inverse Transform
%     Shift from mean (add 128)
% Supersample Cb, Cr components
% Color Space Transformation (YCbCr -> RGB)

    code_img(img, 'FFT');
    code_img(img, 'DCT');