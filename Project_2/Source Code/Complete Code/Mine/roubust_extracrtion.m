clc;
close all;
clear all;
%% %%%%%%%%%%% extraction process %%%%%%%%%%%%%%%%%
w=im2double(imread('invisibe_watermarked_image.jpg'));
 figure,imshow(w);

w_1=im2double(imread('Dual Watermark Embedded image.jpg'));
 figure,imshow(w_1);

%% .Extraction of  the Invisible Robust Watermark...
%% Rgb to ycbcr conversion ..

YCBCR = rgb2ycbcr(w_1);
figure
imshow(YCBCR);
title('Image in YCbCr Color Space');

%% CHANNEL SEPARATION %%
Y =YCBCR(:,:,1);
figure,imshow(Y,[]);
title('Y channel cover image');

Cb=YCBCR(:,:,2);
figure,imshow(Cb,[]);
title('Cb is the blue component relative to the green component-channel cover image');

Cr=YCBCR(:,:,3);
figure,imshow(Cr,[]);
title('Cr is the red component relative to the green component-channel cover image');

%% %%%DWT DECOMPOSITION OF Y band Cover Image%%

[LL1,HL1,LH1,HH1]=dwt2(Y,'db1');
a=[LL1,HL1;LH1,HH1];
figure,imshow(a,[]);
title('1-level decomposed Y band  cover image');

% %% Luminance
LL_11 =zeros(256,256);
LL_11  = reshape(LL_11 ,8,8,[]);
blocks = reshape(LL1,8,8,[]);
load Luminance_Quantization.mat
for i=1:1024 
    LL_1 = ((blocks(:,:,i))/q_matx);
    LL_11(:,:,i)= LL_1 ;
end
LL_Q  = reshape(LL_11,256,256);

%%         
k=0.9;
q=0.00002;
% k=input('enter the input value (b/w 0.8 to 1) of k');
% q=input('enter the input value (b/w 0.00001 to 0.1) of q');

% figure,imshow(wmi,[]);
rw=(LL1*q)-(k*ll1);



















%% Extraction of the Invisible Fragile Watermark...
%% R_band..
R_W =w_1(:,:,1);
blockR_W = reshape(R_W,4,4,[]);
R=blockR_W (:,:,1);
[LLR,HLR,LHR,HHR]=dwt2(R,'db1');

%% Rgb to ycbcr conversion ..
YCBCR = rgb2ycbcr(w);
figure,
imshow(YCBCR);
title('Image in YCbCr Color Space');

%% CHANNEL SEPARATION %%

Y =YCBCR(:,:,1);
figure,imshow(Y,[]);
title('Y channel cover image');

Cb=YCBCR(:,:,2);

figure,imshow(Cb,[]);
title('Cb is the blue component relative to the green component-channel cover image');

Cr=YCBCR(:,:,3);
figure,imshow(Cr,[]);
title('Cr is the red component relative to the green component-channel cover image');

%% %%%DWT DECOMPOSITION OF Y band Cover Image%%

[LL1,HL1,LH1,HH1]=dwt2(Y,'db1');
a=[LL1,HL1;LH1,HH1];
figure,imshow(a,[]);
title('1-level decomposed Y band  cover image');

%% Luminance_Quantization..

LL_11 =zeros(256,256);
LL_11  = reshape(LL_11 ,8,8,[]);
blocks = reshape(LL1,8,8,[]);
load Luminance_Quantization.mat
for i=1:1024 
    LL_1 = ((blocks(:,:,i))/q_matx);
    LL_11(:,:,i)= LL_1 ;
end
LL_Q  = reshape(LL_11,256,256);

% rw=(ll11*qq)-(kk*ll1);

WRn = (HH1-LL_Q )/0.9;
figure,imshow(WRn,[]);
title('1-level decomposed Y band  cover image');

% %% DWT FOR INPUT AND WATERMARKED IMAGE%%%
% [ll1,hl1,lh1,hh1]=dwt2(r,'db1');
% a=[ll1,hl1;lh1,hh1];
% 
% [ll11,hl11,lh11,hh11]=dwt2(w,'db1');
% d=[ll11,hl11;lh11,hh11];
% 
% %% ALPHA BLENDING EXTRACTION TECHNIQUE%%% 
% kk=q;
% qq=k;
% rw=(ll11*qq)-(kk*ll1);


% a1=idwt2(sec3,hl11,lh11,hh11,'db1');
% figure,imshow(a1,[]);
% title('decrypted/extracted image');
% extracted_image=a1;
% %%%find psnr and mse%%%
% [mse,psnr]=msepsnr(s,extracted_image)
% else    
% disp('Keywords not matched-process stop')    
% end


LL_11 =zeros(256,256);
LL_11  = reshape(LL_11 ,8,8,[]);
blocks = reshape(LL1,8,8,[]);
load Luminance_Quantization.mat
for i=1:1024 
    LL_1 = ((blocks(:,:,i))/q_matx);
    LL_11(:,:,i)= LL_1 ;
end
LL_Q  = reshape(LL_11,256,256);

% WQLLn=(k.*LL_Q)+(q.*ll_1);