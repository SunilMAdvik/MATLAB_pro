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

%%  PRE-PROCESSING ...

rgbimage = imread(f);                          %read image ...
figure, imshow(rgbimage);
title('input color image');
impixelinfo;

gray=rgb2gray(rgbimage);                       % Converting the RGB (color) image to gray (intensity).
resize = imresize(gray,[640 480]);           % resize image...
MFI = medfilt2(resize,[3 3]) ;                           %Median filter is used...              
%% ENHANCE LICENSE PLATE ...

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
SE = strel('rectangle',[3 11]);                % Morphological Closing...
JJ = imclose(J,SE);
BW2 = imfill(JJ,'holes')                      %  Image Filling Small Holes...

conn = conndef(3,'maximal');                  % Connectivity definations ...
BW3 = bwareaopen(BW2,1200,conn);              % Remove all the small objets...
imcontour(BW3);                        % Extract contour part of Image ...

%% LICENSE PLATE LOCALISATION AND EXTRACTION ...
s=regionprops(BW3,'Area','BoundingBox','Extent');     % Measure properties of image region...
[hh,ii] = sort([s.Area],'descend');
[jj,kk] = sort([s.Extent],'descend');

out = imcrop(resize,s(kk(1)).BoundingBox);    %  Extract the license plate...
figure,imshow(out);
title(' Extracted license plate');

%% LICENSE PLATE RECOGNITION ...
 load imgfildata;
Extract = imresize(out,[256 150]);
[~,cc]=size(Extract);
threshold = graythresh(Extract);
picture =~im2bw(out,threshold);
picture = bwareaopen(picture,15);
figure,imshow(picture);                      
title('BLACK AND WHITE LETTERS');

if cc>100
    picture1=bwareaopen(picture,60);
else
picture1=bwareaopen(picture,30);
end
figure,imshow(picture1);
title('remove small letters');

picture2=bwareaopen(picture1,90);
figure,imshow(picture2);
title('only LEtters');

[L,Ne]=bwlabel(picture2);
propied=regionprops(L,'BoundingBox');
hold on
pause(1)
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off
final_output=[];
t=[];
for n=1:Ne
  [r,c] = find(L==n);
  n1=picture(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  figure,imshow(n1)
  pause(0.2)
  x=[ ];
totalLetters=size(imgfile,2);
 for k=1:totalLetters
    
    y=corr2(imgfile{1,k},n1);
    x=[x y];
    
 end
 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
final_output=[final_output out];
end
end
file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',final_output);
    fclose(file);                     
    winopen('number_Plate.txt')
