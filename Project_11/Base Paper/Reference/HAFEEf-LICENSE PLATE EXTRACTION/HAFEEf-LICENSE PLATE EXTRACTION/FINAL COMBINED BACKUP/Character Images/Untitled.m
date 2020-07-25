clc ;
close all;
clear all;

snap = imread('C.bmp');
figure , imshow (snap);
snap=imresize(snap,[42 24]);
figure , imshow (snap);
comp=[ ];

load NewTemplates
 n=1

   sem=corr2(NewTemplates{1,n},snap); 
