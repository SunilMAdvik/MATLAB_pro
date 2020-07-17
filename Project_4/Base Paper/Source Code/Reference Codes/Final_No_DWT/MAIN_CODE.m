clc
close all
clear all

%% 1.AES Algorithm.
% To get the Secret text data for Encryption...
[file path]=uigetfile('*.txt','choose txt file');
if isequal(file,0) || isequal(path,0)
    warndlg('User Pressed Cancel');
else
    data1=fopen(file,'r');
    D=fread(data1);
    fclose(data1);
end

ranka = D(1:16);
data_text = ranka;

%% AES ENCRYPTION ...

[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;

% Convert plaintext from hexadecimal (string) to decimal representation
plaintext_AES = data_text;
% Convert the plaintext to ciphertext,
% using the expanded key, the S-box, and the polynomial transformation matrix
ciphertext_AES = cipher(plaintext_AES, w, s_box, poly_mat, 1);

%% CIPHER TEXT..
Cipher_Test = ciphertext_AES;

disp('Cipher Text of the Original Message:');
disp(Cipher_Test);

file = fopen('Cipher_Test.txt', 'wt');
    fprintf(file,'%s\n',Cipher_Test);
    fclose(file);

%% Embedding Procedure...

 [filename, pathname] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
f = fullfile(pathname, filename);
disp('Reading Cover image');

hide_pic=imread(f);   
IMGRAY= rgb2gray(hide_pic);%read image ...
figure, imshow(IMGRAY);
title('Cover Image');
impixelinfo;

pic_data=(im2double(imresize(IMGRAY,[256 256])));
figure, imshow(pic_data);
title('Resized Cover Image');
impixelinfo;

[ll1,hl1,lh1,hh1]=dwt2(pic_data,'db1');
a=[ll1,hl1;lh1,hh1];
figure,imshow(a,[]);
title('1-level decomposed cover image');

[ll2,hl2,lh2,hh2]=dwt2(ll1,'db1');
b=[ll2,hl2;lh2,hh2];
bb=[b,hl1;lh1,hh1];
figure,imshow(bb,[]);
title('2-level decomposed cover image');

[n,m]=size(ll2);
m=m/3;

M='Cipher_Test.txt';
secret=fopen(M,'rb');         % open secret file
[M,L]=fread(secret,'ubit1');  % read secret file as bin array
[L,M]=lsbhide(pic_data,M,L);

%% Extraction Of Chiper txt from hidden image..
hid_data='hidden1.jpg';
L=lsbget(M,L,hid_data);

%% Decryption of original txt from chiper text..
Extrct_file='output.txt';
Extrct_file=fopen(Extrct_file,'r');
Extract_chiper=fread(Extrct_file);
fclose(Extrct_file);

rank_chiper = Extract_chiper(1:16);
Extract_chiper_text = rank_chiper;
    
re_plaintext = inv_cipher (Extract_chiper_text, w, inv_s_box, inv_poly_mat,1);

disp('Decrypted of origial Message:');
disp(re_plaintext);
disp(['Decrypted origial Message is:' re_plaintext]);

fid = fopen('Decrypted origial Message.txt','wb');
fwrite(fid,char(re_plaintext'),'char');
fclose(fid);
