clc ;
clear all;
close all;
%% general settings ...
fontsize = 14;

%% IMAGE ACQUISITION ...
%  pick the image and load it.

 [filename, pathname] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
f = fullfile(pathname, filename);
disp('Reading image')

rgbimage = imread(f);                          %read image ...
figure, imshow(rgbimage);
title('input color image');
impixelinfo;

resize = imresize(rgbimage,[800 800]);             %resize image...
figure, imshow(resize);
title('input resized image');
impixelinfo;

for i=1;
gray=rgb2gray(resize);                        % Converting the RGB (color) image to gray (intensity).
figure,imshow(gray);
title('grayscale image');
impixelinfo;

imresize = imresize(gray,[640 480]);           % resize image...
figure, imshow(imresize);
title('input resized image');
impixelinfo;

SE = strel('rectangle',[3 25]) 
tophatFiltered = imtophat(imresize,SE);        % Morphological TOP_HOT Filter...
figure,imshow(tophatFiltered);
title('Morphological TOP_HOT Filter');
impixelinfo;

level = graythresh(tophatFiltered);            % Thresholding by Otsu's method...
BW = im2bw(tophatFiltered, level)              % Binarization...
figure,imshow(BW);
title('Binarization');
impixelinfo;

SE = strel('rectangle',[2 4]);                % Morphological Opening...
J = imopen(BW,SE);
figure,imshow(J);
title('Morphological Opening');

SE = strel('rectangle',[4 11]);                % Morphological Closing...
JJ = imclose(J,SE);
figure,imshow(JJ);
title('Morphological Closing');

BW2 = edge(JJ,'sobel');
figure,imshow(BW2);
end