clc;
clear all;
close all;

%%%%%%% get the cover image %%%%%%%
[filename1,pathname1]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
i=imread([pathname1,filename1]);
i=(im2double(imresize(i,[256 256])));
figure,imshow(i,[]);
title('input cover image');

%% CHANNEL SEPARATION %%%
redi=i(:,:,1);
greeni=i(:,:,2);
bluei=i(:,:,3);

figure,imshow(redi,[]);
title('red channel cover image');


figure,imshow(greeni,[]);
title('green channel cover image');
figure,imshow(bluei,[]);
title('blue channel cover image');

%%%%%%% get the secret image %%%%%%%
[filename2,pathname2]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
j=imread([pathname2,filename2]);
j=(im2double(imresize(j,[256 256])));
figure,imshow(j,[]);
title('secret image');

%% CHANNEL SEPARATION %%%
redj=j(:,:,1);
greenj=j(:,:,2);
bluej=j(:,:,3);

figure,imshow(redj,[]);
title('red channel secret image');
figure,imshow(greenj,[]);
title('green channel secret image');
figure,imshow(bluej,[]);
title('blue channel secret image');

% watermarking-red channel %
[lli1,hli1,lhi1,hhi1]=dwt2(redi,'db1');
dredi=[lli1,hli1;lhi1,hhi1];
figure,imshow(dredi,[]);
title('DWT decomposed cover red chn image');

[llj1,hlj1,lhj1,hhj1]=dwt2(redj,'db1');
dredj=[llj1,hlj1;lhj1,hhj1];
figure,imshow(dredj,[]);
title('DWT decomposed secret red chn image');

k=0.9;
q=0.0005;
gmred=(k.*lli1)+(q.*llj1);

wmred=idwt2(gmred,hli1,lhi1,hhi1,'db1');
figure,imshow(wmred,[]);
title('watermarked image-red channel');

% watermarking-green channel %
[lli2,hli2,lhi2,hhi2]=dwt2(greeni,'db1');
dgreeni=[lli2,hli2;lhi2,hhi2];
figure,imshow(dgreeni,[]);
title('DWT decomposed cover green chn image');

[llj2,hlj2,lhj2,hhj2]=dwt2(greenj,'db1');
dgreenj=[llj2,hlj2;lhj2,hhj2];
figure,imshow(dgreenj,[]);
title('DWT decomposed secret green chn image');

k=0.9;
q=0.0005;
gmgreen=(k.*lli2)+(q.*llj2);

wmgreen=idwt2(gmgreen,hli2,lhi2,hhi2,'db1');
figure,imshow(wmgreen,[]);
title('watermarked image-green chn channel');

% watermarking-blue channel %
[lli3,hli3,lhi3,hhi3]=dwt2(bluei,'db1');
dbluei=[lli3,hli3;lhi3,hhi3];
figure,imshow(dbluei,[]);
title('DWT decomposed cover blue chn image');

[llj3,hlj3,lhj3,hhj3]=dwt2(bluej,'db1');
dbluej=[llj3,hlj3;lhj3,hhj3];
figure,imshow(dbluej,[]);
title('DWT decomposed secret blue chn image');

k=0.9;
q=0.0005;
gmblue=(k.*lli3)+(q.*llj3);

wmblue=idwt2(gmblue,hli3,lhi3,hhi3,'db1');
figure,imshow(wmblue,[]);
title('watermarked image-blue chn channel');

wmrgb(:,:,1)=wmred;
wmrgb(:,:,2)=wmgreen;
wmrgb(:,:,3)=wmblue;
figure,imshow(wmrgb,[]);
title('rgb watermarked image');
imwrite(wmrgb,'invisibe_watermarked_image.jpg');
%% extraction %%

w=im2double(imread('invisibe_watermarked_image.jpg'));
figure,imshow(w);
title('watermarked image');

redw=w(:,:,1);
greenw=w(:,:,2);
bluew=w(:,:,3);

% inverse watermarking-red channel %
[llw1,hlw1,lhw1,hhw1]=dwt2(redw,'db1');
dredw=[llw1,hlw1;lhw1,hhw1];
figure,imshow(dredw,[]);
title('DWT watermarked red chn image');
% 
[lli1,hli1,lhi1,hhi1]=dwt2(redi,'db1');
dredi=[lli1,hli1;lhi1,hhi1];
% figure,imshow(dredi,[]);
% title('DWT input red chn image');

kk=q;
qq=k;
rw=(llw1*qq)-(kk*lli1);
k1=lli1-llj1;
sec1=lli1-k1;

c1=idwt2(sec1,hlj1,lhj1,hhj1,'db1');
figure,imshow(c1,[]);
title('extracted watermark image-red channel');


% inverse watermarking-green channel %
[llw2,hlw2,lhw2,hhw2]=dwt2(greenw,'db1');
dgreenw=[llw2,hlw2;lhw2,hhw2];
figure,imshow(dgreenw,[]);
title('DWT watermarked green chn image');

[lli2,hli2,lhi2,hhi2]=dwt2(greeni,'db1');
dgreeni=[lli2,hli2;lhi2,hhi2];
% figure,imshow(dredi,[]);
% title('DWT input red chn image');

kk=q;
qq=k;
rw2=(llw2*qq)-(kk*lli2);
k2=lli2-llj2;
sec2=lli2-k2;

c2=idwt2(sec2,hlj2,lhj2,hhj2,'db1');
figure,imshow(c1,[]);
title('extracted watermark image-blue channel');

% inverse watermarking-blue channel %
[llw3,hlw3,lhw3,hhw3]=dwt2(bluew,'db1');
dbluew=[llw3,hlw3;lhw3,hhw3];
figure,imshow(dbluew,[]);
title('DWT watermarked blue chn image');

[lli3,hli3,lhi3,hhi3]=dwt2(bluei,'db1');
dgreeni=[lli3,hli3;lhi3,hhi3];
% figure,imshow(dredi,[]);
% title('DWT input red chn image');

kk=q;
qq=k;
rw3=(llw3*qq)-(kk*lli3);
k3=lli3-llj3;
sec3=lli3-k3;

c3=idwt2(sec3,hlj3,lhj3,hhj2,'db1');
figure,imshow(c3,[]);
title('extracted watermark image-blue channel');

ww(:,:,1)=c1;
ww(:,:,2)=c2;
ww(:,:,3)=c3;
figure,imshow(ww,[]);
title('extracted watermark image-rgb');