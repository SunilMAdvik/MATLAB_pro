clc ;
clear all;
close all;
%% general settings ...
fontsize = 14;

%% IMAGE ACQUISITION ...
%  pick the image and load it..

 [filename, pathname] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
f = fullfile(pathname, filename);
disp('Reading image');

rgbimage = imread(f);                          %read image ...
figure, imshow(rgbimage);
title('input color image');
impixelinfo;

resize = imresize(rgbimage,[640 480]);           % resize image...
figure, imshow(resize);
title('input resized image');
impixelinfo;

MFI = medfilt2(resize) ;                           %Median filter is used...              
figure, imshow(MFI);
impixelinfo;
title('Filtered image');

SE = strel('rectangle',[3 25]) 
tophatFiltered = imtophat(MFI,SE);        % Morphological TOP_HOT Filter...
figure,imshow(tophatFiltered);
title('Morphological TOP_HOT Filter');
impixelinfo;

level = graythresh(tophatFiltered);            % Thresholding by Otsu's method...
BW = im2bw(tophatFiltered,level*0.5);              % Binarization...
figure,imshow(BW);
title('Binarization');
impixelinfo;

SE = strel('rectangle',[2 4]);                % Morphological Opening...
J = imopen(BW,SE);
figure,imshow(J);
title('Morphological Opening');

SE = strel('rectangle',[3 11]);                % Morphological Closing...
JJ = imclose(J,SE);
figure,imshow(JJ);
title('Morphological Closing');

BW2 = imfill(JJ,'holes')
figure,imshow(BW2);
conn = conndef(2,'minimal')
BW3 = bwareaopen(BW2,1000,conn);
figure,imshow(BW3);

 
figure;
imcontour(BW3);

s=regionprops(BW3,'Area','BoundingBox','Extent');
[hh,ii] = sort([s.Area],'descend'); 
[jj,kk] = sort([s.Extent],'descend');

out = imcrop(resize,s(kk(1)).BoundingBox); 
figure,imshow(out);
title('out image');





