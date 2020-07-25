%NUMBERPLATEEXTRACTION 
%%%extracts the characters from the input number plate image.
warning ('off');
clc;
clear all;
close all;

            %%%%%%% read the input cover image %%%%%%%
[filename pathname]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
Bln=imread([pathname filename]);
figure,imshow(Bln);
title('Blurred input image');
impixelinfo;

%%% Tried restoration assuming no noise%%%

len= 21;
theta= 11;

Psf = fspecial('motion',len,theta);
est_nsr = 0;
deblur=deconvwnr(Bln,Psf,est_nsr);
figure,imshow(deblur)
title('Restoration of Blurred and Noisy Image Using NSR = 0')

%%% restoration %%%
g=imread('img122.jpg');
g=rgb2gray(g);
g=im2double(g);
noise_mean = 0;
noise_var = 0.0001;
est_nsr = noise_var / var(g(:));
deblurout= deconvwnr(Bln,Psf,est_nsr);
figure,imshow(deblurout)
title('Restoration of Blurred Image');

%%%ROI EXTRACTION%%%
%%%Extrating the license plate area%%%
%  rect=[200 100 180 180];
% rect=[230 280 320 140];
rect=[760 780 530 140]; 
g= imcrop(g, rect);
figure,imshow(g);
title('license plate region');

% %%%HISTOGRAM EQUALIZATION%%%%
his=histeq(g);
figure,imshow(his);
title('histogram equalized image');

% %%%MEDIAN FILTER %%%
g=medfilt2(g,[3 3]);
figure,imshow(g);
title('histogram equalized image');

%%%MORPHOLOGICAL OPERATION%%%
se=strel('disk',1); % Structural element (disk of radius 1) for morphological processing.

gi=imdilate(g,se);
figure,imshow(gi);
title('dilated image');

ge=imerode(g,se); % Eroding the gray image with structural element.
figure,imshow(ge);
title('eroded image');

gdiff=imsubtract(gi,ge); % Morphological Gradient for edges enhancement.
figure,imshow(gdiff);
title('subtracted image');
impixelinfo;

comp=imcomplement(gdiff);
figure,imshow(comp);
title('inverse subtracted image');

gconv=mat2gray(gdiff); % Converting the class to double.
gconv=conv2(gconv,[1 1;1 1]); % Convolution of the double image for brightening the edges.
figure,imshow(gconv);
title('convolution image'); 

gdiff=imadjust(gconv,[0.5 0.7],[0 1],0.1); % Intensity scaling between the range 0 to 1.
figure,imshow(gdiff);
title('pixel adjusted image');


B=logical(gdiff); % Conversion of the class from double to binary.
figure,imshow(B);
title('binary image');

% Eliminating the possible horizontal lines from the output image of regiongrow
% that could be edges of license plate.
er=imerode(B,strel('line',50,0));
figure,imshow(er);
title('eroded image');

out1=imsubtract(B,er);
figure,imshow(out1);
title('subtracted image');

% Filling all the regions of the image%%%
F=imfill(out1,'holes');
figure,imshow(F);
title('Holes filled image');
% F=out1;

% Thinning the image to ensure character isolation.
H=bwmorph(F,'thin',1);
H=imerode(H,strel('line',3,90));
figure,imshow(H);
title('eroded image');

% Selecting all the regions that are of pixel area more than 100.
final=bwareaopen(H,100);
figure,imshow(final);
title('license plate segmented image');

% final=bwlabel(final); % Uncomment to make compitable with the previous versions of MATLAB®
% Two properties 'BoundingBox' and binary 'Image' corresponding to these
% Bounding boxes are acquired.

Iprops=regionprops(final,'BoundingBox','Image');

% Selecting all the bounding boxes in matrix of order numberofboxesX4;
NR=cat(1,Iprops.BoundingBox);
figure,imshow(NR);
title('Bounding box selection');
% Calling of controlling function.
r=controlling(NR); % Function 'controlling' outputs the array of indices of boxes required for extraction of characters.
if ~isempty(r) % If succesfully indices of desired boxes are achieved.
    I={Iprops.Image}; % Cell array of 'Image' (one of the properties of regionprops)
    noPlate=[]; % Initializing the variable of number plate string.
    for v=1:length(r)
        N=I{1,r(v)}; % Extracting the binary image corresponding to the indices in 'r'.
        letter=readLetter(N); % Reading the letter corresponding the binary image 'N'.
        while letter=='O' || letter=='0' % Since it wouldn't be easy to distinguish
            if v<=3                      % between '0' and 'O' during the extraction of character
                letter='O';              % in binary image. Using the characteristic of plates in Karachi
            else                         % that starting three characters are alphabets, this code will
                letter='0';              % easily decide whether it is '0' or 'O'. The condition for 'if'
            end                          % just need to be changed if the code is to be implemented with some other
            break;                       % cities plates. The condition should be changed accordingly.
        end
        noPlate=[noPlate letter]; % Appending every subsequent character in noPlate variable.
    end
    fid = fopen('noPlate.txt', 'wt'); % This portion of code writes the number plate
    fprintf(fid,'%s\n',noPlate);      % to the text file, if executed a notepad file with the
    fclose(fid);                      % name noPlate.txt will be open with the number plate written.
    winopen('noPlate.txt')

    
else % If fail to extract the indexes in 'r' this line of error will be displayed.
    fprintf('Unable to extract the characters from the number plate.\n');
    fprintf('The characters on the number plate might not be clear or touching with each other or boundries.\n');
end


