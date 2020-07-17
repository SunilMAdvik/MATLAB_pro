clc
clear all
 Feature_train=[];
 %% 
for imc=1:61
    
    cd all
f=[num2str(imc) '.jpg'];
im= imread(f);                               %read image .
cd ..
figure,imshow(im);                     
RGBIMAGE = imresize(im,[256 256]);  %resize image...
%[rows columns NumberOfColorbands] = size(RGBIMAGE);
r = medfilt2(RGBIMAGE(:, :, 1), [7 7]);
g = medfilt2(RGBIMAGE(:, :, 2), [7 7]);
b = medfilt2(RGBIMAGE(:, :, 3), [7 7]);

% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);

% Enhance Contrast
I = imadjust(K,stretchlim(K));

%% IMAGE FEATURE EXTRACTIONS...

% Extract Features from query image
[Feature_Vector] = feature_extraction(I);
Feature_train =[Feature_train;Feature_Vector];
 


     end
     save Train_data Feature_train
