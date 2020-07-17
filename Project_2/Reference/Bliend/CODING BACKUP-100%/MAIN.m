
clc;
clear all;
close all;

%%%%%%% read the original input image %%%%%%%
[filename,pathname]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
r=imread([pathname filename]);
r=(im2double(imresize(r,[256 256])));
figure,imshow(r,[]);
title('input image');
[m,n,dim]=size(r);

%%%%%%% read the watermark image %%%%%%%

[filename2,pathname2]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
s=imread([pathname2,filename2]);

s=(im2double(imresize(s,[256 256])));
figure,imshow(s,[]);
title('watermark image');

[mw,nw,dimw]=size(s);

%%%DWT DECOMPOSITION OF input IMAGE%%

[ll1,hl1,lh1,hh1]=dwt2(r,'db1');

figure,imshow(ll1,[]);
title('approximation cover image');

figure,imshow(hl1,[]);
title('horizontal cover image');

figure,imshow(lh1,[]);
title('vertical cover image');

figure,imshow(hh1,[]);
title('diagonal cover image');

a=[ll1,hl1;lh1,hh1];
figure,imshow(a,[]);
title('1-level DWT decomposed input image');

%%%DWT DECOMPOSITION OF watermark IMAGE%%

[ll11,hl11,lh11,hh11]=dwt2(s,'db1');

figure,imshow(ll11,[]);
title('approximation wmk image');

figure,imshow(hl11,[]);
title('horizontal wmk image');

figure,imshow(lh11,[]);
title('vertical wmk image');

figure,imshow(hh11,[]);
title('diagonal wmk image');

d=[ll11,hl11;lh11,hh11];
figure,imshow(d,[]);
title('1-level DWT decomposed wmk image');

%%%%ALPHA BLENDING EMBEDDING TECHNIQUE%%%            
% k=0.9;
% q=0.0005;
k=input('enter the input value (b/w 0.8 to 1) of k');
q=input('enter the input value (b/w 0.00001 to 0.1) of q');
wmi=(k.*ll1)+(q.*ll11);

%%INVERSE DWT%%%%
c1=idwt2(wmi,hl1,lh1,hh1,'db1');
figure,imshow(c1,[]);
title('encrypted/watermarked image');

imwrite(c1,'invisibe_watermarked_image.jpg');

%%%%DATA(TEXT) EMBEDDING IN THE ENCRYPTED IMAGE%%%
inputkey=input('enter the transmitter keyword','s');
value=ischar(inputkey);
if value==1 
%%% for key information
k1=ll1-ll11;
end
%% %%%%%%%%%%% extraction process %%%%%%%%%%%%%%%%%
w=im2double(imread('invisibe_watermarked_image.jpg'));
% figure,imshow(w);

%% DWT FOR INPUT AND WATERMARKED IMAGE%%%
[ll1,hl1,lh1,hh1]=dwt2(r,'db1');
a=[ll1,hl1;lh1,hh1];

[ll11,hl11,lh11,hh11]=dwt2(w,'db1');
d=[ll11,hl11;lh11,hh11];

%% ALPHA BLENDING EXTRACTION TECHNIQUE%%% 
kk=q;
qq=k;
rw=(ll11*qq)-(kk*ll1);

%%%KEYWORD MATCHING%%%
outputkey=input('enter the receiver keyword','s');
check=strcmp(inputkey,outputkey);

if check==1
sec3=ll1-k1;

a1=idwt2(sec3,hl11,lh11,hh11,'db1');
figure,imshow(a1,[]);
title('decrypted/extracted image');
extracted_image=a1;
%%%find psnr and mse%%%
[mse,psnr]=msepsnr(s,extracted_image)
else    
disp('Keywords not matched-process stop')    
end

