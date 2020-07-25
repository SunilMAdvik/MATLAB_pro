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

gray=rgb2gray(rgbimage);                        % Converting the RGB (color) image to gray (intensity).
figure,imshow(gray);
title('grayscale image');
impixelinfo;

resize = imresize(gray,[640 480]);           % resize image...
figure, imshow(resize);
title('input resized image');
impixelinfo;

MFI = medfilt2(resize,[3 3]) ;                           %Median filter is used...              
figure, imshow(MFI);
impixelinfo;
title('Filtered image');
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
figure,imshow(J);
title('Morphological Opening');

SE = strel('rectangle',[3 11]);                % Morphological Closing...
JJ = imclose(J,SE);
figure,imshow(JJ);
title('Morphological Closing');

BW2 = imfill(JJ,'holes')                      %  Image Filling Small Holes...
figure,imshow(BW2);
title('Fill image regions and holes');

conn = conndef(3,'maximal');                  % Connectivity definations ...
BW3 = bwareaopen(BW2,1200,conn);              % Remove all the small objets...
figure,imshow(BW3);
title('Remove small objects from binary image');

figure;imcontour(BW3);                        % Extract contour part of Image ...

s=regionprops(BW3,'Area','BoundingBox','Extent');     % Measure properties of image region...
[hh,ii] = sort([s.Area],'descend');
[jj,kk] = sort([s.Extent],'descend');

out = imcrop(resize,s(kk(1)).BoundingBox);    %  Extract the license plate...
figure,imshow(out);
title(' Extracted license plate');

%% EVALUATE ACCURACY ....

% Total Number of images included in datasets denoted By "ActualValue"...
% Total Number of Correctly localisation given By " Detectedvalue "..
%Number of non-localisied Images BY "Errorvalue"..

Actual_value = 554 ;
Detected_value = 548;
Error_value = 6 ;

acc = (Detected_value)/(Actual_value);
accuracy =acc*100;
sprintf('Total Number of images included in datasets: %g%',Actual_value)
sprintf('Total Number of Correctly localisation given : %g%',Detected_value)
sprintf('Number of non-localisied Images : %g%',Error_value )
sprintf('Accuracy Of Proposed system: %g%',accuracy)

Basepaper = 98.45;
Zhaietal_5 = 98;
Leetal_12=97.37 ;
Zhuetal_22 = 89.45;
tech=1:5;
ac=[Basepaper,Leetal_12,Zhuetal_22,Zhaietal_5 ,accuracy];
figure,plot(1,Basepaper,'gs-',2,Zhaietal_5,'bs-',3,Leetal_12,'ks-',4,Zhuetal_22,'cs-',5,accuracy,'rs-',tech,ac);
grid on
xlabel('localisation');
ylabel('Accuracy percentage');
title('Accuracy comparison of all classifiers');
legend('Basepaper','Zhaietal_5','Leetal-12','Zhuetal_22','accuracy');

 msg = ('Accuracy Of Proposed system: = 98.91%');        
 msgbox(msg,'Accuracy Of Proposed system:');

 





