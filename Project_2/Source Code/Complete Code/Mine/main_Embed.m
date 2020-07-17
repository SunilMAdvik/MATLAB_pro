%% %% Blind Dual Watermarking for Color Images...

clc;
clear all;
close all;

[filename1, pathname1] = uigetfile(...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
i=imread([pathname1,filename1]);
RGB=(im2double(imresize(i,[512 512])));
figure,imshow(RGB,[]);
title('input cover image');

[m,n,dim]=size(RGB);

%% 1. Embedding the Invisible Robust Watermark...
%% Rgb to ycbcr conversion..

YCBCR = rgb2ycbcr(RGB);
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

%% %%%%%%% get the Water_marking image %%%%%%% 

 [filename2, pathname2] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
s=imread([pathname2,filename2]);

W=(im2double(imresize(s,[512 512])));


ss = rgb2gray(W);
[M, N]= size(ss);
figure,imshow(ss,[]);
title('watermark image');

[ll_1,hl_1,lh_1,hh_1]=dwt2(ss,'db1');
d=[ll_1,hl_1;lh_1,hh_1];
figure,imshow(d,[]);
title('1-level DWT decomposed Watermarking image');

%% %% EMBEDDING TECHNIQUE%%%            
k=0.90;
q=0.00002;
% k=input('enter the input value (b/w 0.8 to 1) of k');
% q=input('enter the input value (b/w 0.00001 to 0.1) of q');

wmi=(k.*LL1)+(q.*ll_1);
% figure,imshow(wmi,[]);

%%INVERSE DWT%%%%
c1=idwt2(wmi,HL1,LH1,HH1,'db1');
figure,imshow(c1,[]);
title('encrypted/watermarked image');

K = cat(3, c1,Cb, Cr);
figure,imshow(K);
title('Robust Watermarked Image');

RGB_W = ycbcr2rgb(K);
figure,imshow(RGB_W);
title('Robust Watermarked RGB Image');

imwrite(RGB_W,'invisibe_watermarked_image.jpg');

%% Embedding the Invisible Fragile Watermark...
%% R_band..

R_W =RGB_W(:,:,1);
blockR_W = reshape(R_W,4,4,[]);
R=blockR_W (:,:,1);
[LLR,HLR,LHR,HHR]=dwt2(R,'db1');

WF_1 = uint8(randi([0, 1], 4,4))
[LL_F1,HL_F1,LH_F1,HH_F1]=dwt2(WF_1,'db1');

k=k;
q=0.00001;

wm_R=(k.*LLR)+(q.*LL_F1);
R_1=idwt2(wm_R,HLR,LHR,HHR,'db1');

blockR_W(:,:,1)= R_1 ;
R1= reshape(blockR_W,512,512);
figure,imshow(R1,[]);
title(' Invisible Fragile Watermark R-band image');

%% Green band..
G_W=RGB_W(:,:,2);
blockG_W = reshape(G_W,4,4,[]);
G=blockG_W(:,:,1);
[LLG,HLG,LHG,HHG]=dwt2(G,'db1');

WF_2 = randi([0, 1], 4,4)
[LL_F2,HL_F2,LH_F2,HH_F2]=dwt2(WF_2,'db1');

k=k;
q=0.00002;

wm_G=(k.*LLG)+(q.*LL_F2);
G_1=idwt2(wm_G,HLG,LHG,HHG,'db1');
blockG_W(:,:,1)= G_1 ;
G1= reshape(blockG_W,512,512);
figure,imshow(G1,[]);
title(' Invisible Fragile Watermark G-band image');

%% Blue band..

B_W=RGB_W(:,:,3);
blockB_W = reshape(B_W,4,4,[]);
B=blockB_W(:,:,1);
[LLB,HLB,LHB,HHB]=dwt2(B,'db1');

WF_3 = randi([0, 1], 4,4)
[LL_F3,HL_F3,LH_F3,HH_F3]=dwt2(WF_3,'db1');

k=k;
q=0.00002;

wm_B=(k.*LLB)+(q.*LL_F3);
B_1=idwt2(wm_B,HLB,LHB,HHB,'db1');
blockB_W(:,:,1)= B_1 ;
B1= reshape(blockB_W,512,512);
figure,imshow(B1,[]);
title(' Invisible Fragile Watermark B-band image');

K_F = cat(3, R1,G1, B1);
figure,imshow(K_F,[]);
title('Dual Watermark Embedded image');

 imwrite(K_F,'Dual Watermark Embedded image.jpg');
 
 %% %%DATA(TEXT) EMBEDDING IN THE ENCRYPTED IMAGE%%%
inputkey=input('enter the transmitter keyword','s');
value=ischar(inputkey);
if value==1 
%%% for key information
k1=LL1-ll_1;
end
 
%% .Extraction of  the Invisible Robust Watermark...
%% Rgb to ycbcr conversion ..

YCBCRe = rgb2ycbcr(RGB_W);
figure
imshow(YCBCRe);
title('Image in YCbCr Color Space');

%% CHANNEL SEPARATION %%
Ye =YCBCRe(:,:,1);
figure,imshow(Ye,[]);
title('Y channel cover image');

Cbe=YCBCRe(:,:,2);
Cre=YCBCRe(:,:,3);

%% %%%DWT DECOMPOSITION OF Y band Cover Image%%

[LL1e,HL1e,LH1e,HH1e]=dwt2(Ye,'db1');
ae=[LL1e,HL1e;LH1e,HH1e];
% figure,imshow(ae,[]);
% title('decrypted/extracted image');

kk=q;
qq=k;
rw=(LL1e*qq)-(kk*LL1);

%%%KEYWORD MATCHING%%%
outputkey=input('enter the receiver keyword','s');
check=strcmp(inputkey,outputkey);

if check==1
sec3=LL1-k1;

a1=idwt2(sec3,HL1e,LH1e,HH1e,'db1');
figure,imshow(a1,[]);
title('decrypted/extracted image');
extracted_image=a1;
% %%%find psnr and mse%%%
% [mse,psnr]=msepsnr(ss,extracted_image)

psnr_=getPSNR(ss,extracted_image);
ssim_=getMSSIM(ss,extracted_image);
fprintf('PSNR= %f - SSIM= %f\n',psnr_,ssim_);
else    
disp('Keywords not matched-process stop')    
end
% 
% error = ss - extracted_image;
% 
% MSE = sum(sum(error .* error)) / (M * N);
% if(MSE > 0)
%     PSNR = 10*log10(M*N./MSE);
% else
%     PSNR = 99;
% end

%% Plot The Graph of K vs PSNR and SSIM..
 
% images = Lean
% Water_Mark= logo_4 (matlab log)


k  =  [ 0.10,       0.2,     0.3 ,      0.4 ,     0.50   ,    0.6,       0.70 ,     0.80 ,      0.90];

PsNR =[88.992004, 88.605651, 87.958370, 87.319232, 86.887233, 86.636438, 86.514037, 86.484753 , 86.482253];

SSIM= [0.999979 , 0.999979 ,  0.999977 ,0.999976 , 0.999975 , 0.999974 , 0.999974 , 0.999974 ,  0.999974];

figure
plot(k ,PsNR,'-gs',...
    'MarkerSize',10,...
     'MarkerEdgeColor','b',...
    'LineWidth',2)
grid on
xlabel('K');
ylabel('PSNR');
title('K Vs PSNR');
legend('Image-Lean.jpg');

figure,
plot(k ,SSIM,'-gs',...
    'MarkerSize',10,...
     'MarkerEdgeColor','b',...
    'LineWidth',2)

grid on
xlabel('K');
ylabel('SSIM');
title('K vs SSIM');
legend('Image-Lean.jpg');