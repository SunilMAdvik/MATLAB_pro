clc ;
clear all;
close all;

%% 1.Hybrid (AES & RSA) Algorithm...
% To get the Secret text data for Encryption...
[file path]=uigetfile('*.txt','choose txt file');
if isequal(file,0) || isequal(path,0)
    warndlg('User Pressed Cancel');
else
    data1=fopen(file,'r');
    D=fread(data1);
    fclose(data1);
end
% ascii_value = uint8(D);
ranka = D(1:16); % Pull odd Part (starts at 1)
data_text_AES = ranka;

%% AES ENCRYPTION ...

[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;

% Convert plaintext from hexadecimal (string) to decimal representation
plaintext_AES = data_text_AES;
% Convert the plaintext to ciphertext,
% using the expanded key, the S-box, and the polynomial transformation matrix
ciphertext_AES = cipher(plaintext_AES, w, s_box, poly_mat, 1);

%% CIPHER TEXT..
Cipher_Test = ciphertext_AES;

disp('Cipher Text of the Original Message:');
disp(Cipher_Test);

disp('Cipher text generated');
fid_1=fopen('cipher.txt','w'); 
fprintf(fid_1,'%d ',Cipher_Test);    

%% Read Cipher_Text File..

fid_2 = fopen('cipher.txt','rb');    
Str = fread(fid_2, [1, inf], 'char'); 
fclose(fid_2);        
Str=(Str); 

%% READ COVER IMAGE...

[filename, pathname] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file');
fIle_1 = fullfile(pathname, filename);
disp('Reading Cover image');
disp('Cover Medium found');
%hide_pic=imread(f);  
IMAge=imread(fIle_1); 
figure,imshow(IMAge);
impixelinfo;
title('Input Cover Image');

imwrite(IMAge,'original.jpeg');

[Rows_1 Col_1 Dim]= size(IMAge);
if Dim == 3
    IMAge=rgb2gray(IMAge);
    figure,imshow(IMAge);
    impixelinfo;
    title('Input Gray Image');
end 

[ll1,hl1,lh1,hh1]=dwt2(IMAge,'haar');
DWT_1=[ll1,hl1;lh1,hh1];
figure,imshow(DWT_1,[]);
title('1-level decomposed cover image');

[ll2,hl2,lh2,hh2]=dwt2(ll1,'haar');
b=[ll2,hl2;lh2,hh2];
DWT_2=[b,hl1;lh1,hh1];
figure,imshow(DWT_2,[]);
title('2-level decomposed cover image');

[Rows_2 Col_2]=size(hh2);
Length_2 = numel(Str); 
Length_3 = 1;

%embedding loop
for B=1:Rows_2
    for C=1:Col_2
        if(Length_3 <= Length_2)
            EMBED_16(B,C) = Str(Length_3);
        else 
            EMBED_16(B,C) = hh2(B,C);
        end
        Length_3 =Length_3+1;
    end
end

IDWT_2=idwt2(ll2,hl2,lh2,EMBED_16,'haar');
figure,imshow(IDWT_2,[]);
title('2-level embedded image');

IDWT_3=idwt2(IDWT_2,hl1,lh1,hh1,'haar');
figure,imshow(IDWT_3,[]);
title('3-level embedded image');

Embed_IMAge=uint8(IDWT_3);
imwrite(Embed_IMAge,'Embed_IMAge.tiff');
disp('Stego-Object created');


%% READ Embedded IMAGE...
disp('STEGANOGRAPY EXTRACTION FOR THESIS | SDP2');


Embed_IMAge=imread('Embed_IMAge.tiff'); 
figure,imshow(Embed_IMAge);
impixelinfo;
title('Stego Image');
disp('Stego-Object found');

[LL1,HL1,LH1,HH1]=dwt2(IDWT_3,'haar');
dwt_1=[LL1,HL1;LH1,HH1];
figure,imshow(dwt_1,[]);
title('1-level decomposed cover image');

[LL2,HL2,LH2,HH2]=dwt2(LL1,'haar');
b_1=[LL2,HL2;LH2,HH2];
dwt_2=[b_1,HL1;LH1,HH1];
figure,imshow(dwt_2,[]);
title('2-level decomposed cover image');

[Rows_3 Col_3]=size(HH2);
Length_2 = numel(Str); 
Length_4 = 1;

%Extraction loop
for D=1:Rows_3
    for E=1:Col_3
        if(Length_4 <= Length_2)
          Extract(Length_4)= HH2(D,E);
        end
        Length_4 =Length_4+1;
    end
end

Extract_Data = uint8(Extract);

idwt_2=idwt2(LL2,HL2,LH2,HH2,'haar');
figure,imshow(idwt_2,[]);
title('1-level embedded image');

idwt_3=idwt2(idwt_2,HL1,LH1,HH1,'haar');
figure,imshow(idwt_3,[]);
title('2-level embedded image');

Extract=uint8(idwt_3);
figure(),imshow(Extract,[]);
impixelinfo;
title('Extracted Cover Image');

imwrite(Extract,'Extract.tiff');
disp('Stego-Object created');

disp('Text message extracted');
fid=fopen('extraction.txt','w'); 
for F=1:Length_2 
    fprintf(fid,'%c',Extract_Data(F)); 
end

%% 1.Hybrid (AES & RSA)Decryption Algorithm.
% To get the Secret text data for Encryption...

fileID_2 = fopen('extraction.txt','r');
Extract_MSG= fscanf(fileID_2,'%d');
fclose(fileID_2);
Length_5=length(Extract_MSG);

ranka_1 = Extract_MSG(1:16); % Pull odd Part (starts at 1)
 % Pull even Part (starts at 17)

data_text_AES = ranka_1;

%% AES ENCRYPTION ...
% Initialization
[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;

% Convert the ciphertext back to plaintext
% using the expanded key, the inverse S-box, 
% and the inverse polynomial transformation matrix
Extracted_AES_Text = inv_cipher (data_text_AES, w, inv_s_box, inv_poly_mat, 1);

Extracted_original_msg = Extracted_AES_Text;

disp(['Decrypted Message is: ' Extracted_original_msg]);
disp('Decrypted text file generated');
fid=fopen('readable.txt','w'); 
fprintf(fid,'%c',Extracted_original_msg); 

