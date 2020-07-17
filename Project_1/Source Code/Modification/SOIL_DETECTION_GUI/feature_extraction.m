
    % Extract Features
    
function [Feature_Vector] = feature_extraction(queryImage)
% https://stackoverflow.com/questions/20608458/gabor-feature-extraction
  
    % for gabor filters we need gary scale image
     img = double(rgb2gray(queryImage))/255;
     [mag, phase] = imgaborfilt(img,4,90);% 4 = number of scales, 6 = number of orientations
     meanAmplitude = mean2(mag);
     Standard_Deviation = std2(mag);
     
     color_moments = colorMoments(queryImage);
     hsvHist = hsvHistogram(queryImage);
     
    % construct the queryImage feature vector
    Feature_Vector = [ meanAmplitude Standard_Deviation color_moments hsvHist];