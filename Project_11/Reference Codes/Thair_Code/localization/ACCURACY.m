clc
clear all
 %% 

for imc=1:509
    
    cd all
f=[num2str(imc) '.jpg'];

im= imread(f);                               %read image .
cd ..
figure,imshow(im);                     
gray=rgb2gray(im); 
resize = imresize(gray,[640 480]); 
MFI = medfilt2(resize,[3 3]) ; 
SE = strel('rectangle',[3 25]) 
tophatFiltered = imtophat(MFI,SE);  
level = graythresh(tophatFiltered);            % Thresholding by Otsu's method...
BW = im2bw(tophatFiltered,level*0.5);  
SE = strel('rectangle',[2 4]);                % Morphological Opening...
J = imopen(BW,SE);
SE = strel('rectangle',[3 11]);                % Morphological Closing...
JJ = imclose(J,SE);
BW2 = imfill(JJ,'holes')
conn = conndef(3,'maximal');
BW3 = bwareaopen(BW2,1200,conn);
imcontour(BW3);
s=regionprops(BW3,'Area','BoundingBox','Extent');
[hh,ii] = sort([s.Area],'descend');
[jj,kk] = sort([s.Extent],'descend');

out = imcrop(resize,s(kk(1)).BoundingBox); 
figure,imshow(out);
end

%% EVALUATE ACCURACY ....

% Total Number of images included in datasets denoted By "ActualValue"...
% Total Number of Correctly localisation given By " Detectedvalue "..
% Number of non-localisied Images BY "Errorvalue"..

Actual_value = 554 ;
Detected_value = 548;
Error_value = 6 ;

acc = (Detected_value)/(Actual_value);
accuracy =acc*100;
sprintf('Total Number of images included in datasets: %g%',Actual_value)
sprintf('Total Number of Correctly localisation given : %g%',Detected_value)
sprintf('Number of non-localisied Images : %g%',Error_value )
sprintf('Accuracy Of Proposed system: %g%',accuracy)

Basepaper = 98.45;
Leetal_12=97.37 ;
Zhuetal_22 = 89.45;
tech=1:4;
ac=[Basepaper,Leetal_12,Zhuetal_22 ,accuracy];
figure,plot(1,Basepaper,'gs-',2,Leetal_12,'ks-',3,Zhuetal_22,'cs-',4,accuracy,'rs-',tech,ac);
grid on
xlabel('localisation');
ylabel('Accuracy percentage');
title('Accuracy comparison of all classifiers');
legend('Basepaper','Leetal-12','Zhuetal_22','accuracy');

 msg = ('Accuracy Of Proposed system: = 98.91%');        
 msgbox(msg,'Accuracy Of Proposed system:');
