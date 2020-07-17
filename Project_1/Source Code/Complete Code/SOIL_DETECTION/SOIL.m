clc;
clear all; 
close all; 



%% General settings
fontSize = 14;
  

%%%%%%%%   stage 1 Image acquisition   %%%%%%%%%%%%%%
%% Pick the image and Load the image
 [filename, pathname] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
f = fullfile(pathname, filename);
disp('Reading image')

rgbimage = imread(f);                          %read image ...
figure, imshow(rgbimage);
title('input color image');
impixelinfo;

RGBIMAGE = imresize(rgbimage,[256 256]);       %resize image...
figure, imshow(RGBIMAGE);
title('input resized image');
impixelinfo;

% filter each channel separately
r = medfilt2(RGBIMAGE(:, :, 1), [7 7]);
g = medfilt2(RGBIMAGE(:, :, 2), [7 7]);
b = medfilt2(RGBIMAGE(:, :, 3), [7 7]);

% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);
figure,imshow(K);
impixelinfo;
title('Filtered image');

% Enhance Contrast
I = imadjust(K,stretchlim(K));
figure, imshow(I);
title('Contrast Enhanced');

%% IMAGE FEATURE EXTRACTIONS...

% Extract Features from query image
[Feature_Vector] = feature_extraction(I);
disp('Feature_test');
Feature_test = Feature_Vector;

%% SVM Classifier
  
  load Train_data                        % Train the images and save file... 
train_label      = zeros(size(20,1),1);
train_label(1:8,1)   = 1;                 % group 1
train_label(9:18,1)  = 2;                 % group 2
train_label(19:25,1)   = 3;               % group 3
train_label(26:33,1)   = 4;               % group 4
train_label(34:44,1)   = 5;               % group 5
train_label(45:52,1)   = 6;               % group 6
train_label(53:61,1)   = 7;               % group 7

result = multisvm(Feature_train,train_label,Feature_test); 

disp(result);

if result == 1
    helpdlg(' Clay ');
    disp(' Clay ');
elseif result == 2
    helpdlg(' Clayey Peat ');
    disp('Clayey Peat');
elseif result == 3
    helpdlg(' Clayey Sand ');
    disp(' Clayey Sand ');
elseif result == 4
    helpdlg(' Humus Clay ');
    disp(' Humus Clay ');
elseif result == 5
    helpdlg(' Peat ');
    disp(' Peat ');
elseif result == 6
    helpdlg(' Sandy Clay ');
    disp('Sandy Clay');
elseif result == 7
    helpdlg(' Silty Sand ');
    disp(' Silty Sand ');
end

