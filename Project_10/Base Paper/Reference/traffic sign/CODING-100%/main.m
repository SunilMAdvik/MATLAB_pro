warning ('off');
clc;
close all;
clear all;

%%%%%%%%% get the input image %%%%%%%%%%%%%%%%%%%
[filename,pathname]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
im=imread([pathname filename]);%%%% read the image  %%%%%
figure,imshow(im,[]);   %%%% show the image  %%%%%
title('original image');
[m,n,o]=size(im);

%% channel separation %
red=im(:,:,1);
green=im(:,:,2);
blue=im(:,:,3);
figure,imshow(red);
title('Red channel Image');
figure,imshow(green);
title('Green channel Image');
figure,imshow(blue);
title('Blue channel Image');

% color enhancement %
rede=adapthisteq(red);
greene=adapthisteq(green);
bluee=adapthisteq(blue);
cole(:,:,1)=rede;
cole(:,:,2)=greene;
cole(:,:,3)=bluee;
figure,imshow(cole);
title('color enhanced image');

%% probability map %
sht1=(red-green)./(red+green+blue);
p1=(1/sqrt(2))*sht1;

sht2=(2*green-red-blue)./(red+green+blue);
p2=(1/sqrt(6))*sht2;

RGB=im;
Gred=RGB(:,:,1);
Ggreen=RGB(:,:,2);
Gblue=RGB(:,:,3);

normRGB = uint8(zeros(size(RGB,1), size(RGB,2), size(RGB,3)));

redd=im2double(Gred);
greend=im2double(Ggreen);
blued=im2double(Gblue);

rm = mean(mean(redd));
gm = mean(mean(greend));
bm = mean(mean(blued));

normR = redd./(sqrt((redd).^2 + (greend).^2 + (blued).^2));
figure,imshow(normR,[]);
title('probability map for Red channel image');

normG = greend./(sqrt((redd).^2 + (greend).^2 + (blued).^2));
figure,imshow(normR,[]);
title('probability map for green channel image');

normB = blued./(sqrt((redd).^2 + (greend).^2 + (blued).^2));
figure,imshow(normB,[]);
title('probability map for blue channel image');

% normRU=im2uint8(normR);
% normGU=im2uint8(normG);
% normBU=im2uint8(normB);
% 
% normRGB(:,:,1)=normRU;
% normRGB(:,:,2)=normGU;
% normRGB(:,:,3)=normBU;
% 
% figure,imshow(normRGB);
% title('Normalized RGB channel image');
%% COLOR TO GRAY CONVERSION
gim=rgb2gray(im);
figure,imshow(gim);
title('Grayscale Image');
           
%% ENHANCEMENT%%%
% ADAPTIVE HISTOGRAM EQUALIZATION(CLAHE)%%
enh=adapthisteq(gim);
figure,imshow(enh);
title('ENHANCED IMAGE');
[rows,columns]=size(enh);

%% HOG shape detected %%%
[feature,angle,magnitude,Im]= hog_feature_vector(gim);
figure,imshow(uint8(magnitude));
title('shape detected image using HOG');

%% color feature extraction %

[rmeanR,rstdR,rmeanG,rstdG,rmeanB,rstdB]= colorMoments(im);

%% shape visible %%
thr=graythresh(enh);
bina=im2bw(enh,thr);
binac=imcomplement(bina);
figure,imshow(binac);
title('Traffic sign-Binary Image');

%% morphological operations %%
shap=bwareaopen(binac,200);
figure,imshow(shap);
title('Traffic sign segmented image');

%% shape feature extraction %%
g=regionprops(shap,'all');
g1=extractfield(g,'Area');
[g11,index1]=max(g1);
AR=round(g11);

g2=extractfield(g,'MajorAxisLength');
[g22,index2]=max(g2);
MAJ=round(g22);

g3=extractfield(g,'MinorAxisLength');
[g33,index3]=max(g3);
MIN=round(g33);

%% CLASSFICATION USING MULTISVM
% Load All The Training and Testing Features
load TrainingSet
GroupTrain=[1;2;3;4;5;6];
TestSet = [AR,MAJ,MIN,rmeanR];
[result]=multisvm(TrainingSet,GroupTrain,TestSet,AR,MAJ,MIN,rmeanR);
            