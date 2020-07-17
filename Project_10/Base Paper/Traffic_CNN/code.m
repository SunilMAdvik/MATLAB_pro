clc;
close all;
clear all;

%% general settings ...
fontsize = 14;

%% Create Network and Train...

matlabroot='\\WIN7-PC\SDPRO_Share\2018-2019 DIP-BACKUP\Bangalore Projects\Project 2\Source Code\Complete Code\Traffic_CNN';
Datasetpath=fullfile(matlabroot,'ProcessedData');
imds =imageDatastore(Datasetpath,'IncludeSubfolders',true,'LabelSource','foldernames');

%% Display some sample images.
  
figure;

perm = randperm(456,20);
 for i = 1:20
     subplot(4,5,i);
    imshow(imds.Files{perm(i)});
 end

 title('Sample Images of Datasets');
 
%% Split Data into Training and testing sets ...

[imdsTrain,imdsTest] = splitEachLabel(imds,0.7);

idx = randperm(456,136);

%% Convolutional Neaural network- layers defination..

% layers = [
%     imageInputLayer([150 150 3])
%     
%     convolution2dLayer(3,16,'stride',2) 
%     convolution2dLayer(3,16,'stride',2) 
%     reluLayer   
%     maxPooling2dLayer(2,'stride',2)
%     
%     convolution2dLayer(3,32,'stride',1)  
%     convolution2dLayer(3,32,'stride',1)
%     reluLayer   
%     maxPooling2dLayer(2,'stride',2)
%     
%     convolution2dLayer(3,64,'stride',1)
%     convolution2dLayer(3,64,'stride',1)
%     convolution2dLayer(3,64,'stride',1)
%     reluLayer
%     maxPooling2dLayer(3,'Padding',2)
%     
%     convolution2dLayer(3,128,'stride',1)
%     reluLayer
%     
%     convolution2dLayer(3,256,'Padding',2)
%     reluLayer
%     maxPooling2dLayer(3,'Padding',2)  
%     
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer]
% 
% 
% options = trainingOptions('sgdm',...
%       'LearnRateSchedule','piecewise',...
%       'LearnRateDropFactor',0.2,... 
%       'LearnRateDropPeriod',5,... 
%       'MaxEpochs',20,... 
%       'MiniBatchSize',300);
%     
% convnet=trainNetwork(imds,layers,options);

layers=[imageInputLayer([120 120 3])
    convolution2dLayer(5,20)  
   reluLayer
   maxPooling2dLayer(2,'stride',2)
   convolution2dLayer(5,20)  
reluLayer
 maxPooling2dLayer(2,'stride',2)
 fullyConnectedLayer(16)
 softmaxLayer
    classificationLayer()]


%% Training Option ...

options = trainingOptions('sgdm','MaxEpochs',20,...
	'InitialLearnRate',0.0001);

%% Train CNN ..
convnet=trainNetwork(imdsTrain,layers,options);

inputSize = convnet.Layers(1).InputSize

classNames = convnet.Layers(end).ClassNames;
numClasses = numel(classNames);
disp(classNames(randperm(numClasses,16)))

%% Test Convlution Neural Network...
%IMAGE ACQUISITION ...
% Pick the image and Load the image
 [filename, pathname] = uigetfile( ...
       {'*.jpg;*.tif;*.tiff;*.png;*.bmp', 'All image Files (*.jpg, *.tif, *.tiff, *.png, *.bmp)'}, ...
        'Pick a file'); 
    disp('Reading image');
IM=imread([pathname,filename]);
% a=imread('test1.jpg');
figure();imshow(IM);
title('Input Image ');
impixelinfo;

IM = imresize(IM,[120 120]);       %resize image...
figure, imshow(IM);
title('input resized image');
impixelinfo;

size(IM);

%% 1st  convolutional layer output..

% Get the network weights for the second convolutional layer
w1 = convnet.Layers(2).Weights;

% Scale and resize the weights for visualization
w1 = mat2gray(w1);
w1 = imresize(w1,5);

% Display a montage of network weights. There are 96 individual sets of
% weights in the first layer.
figure
montage(w1)
title('First convolutional layer weights');

%% Clasification ...

% [label,score] = classify(convnet,IM);
[label,score] =classify(convnet,IM);


 
label

figure,imshow(IM)
title(string(label) + ", " + num2str(100*score(classNames == label),3) + "%");

result = label;

%% display classify results

disp('The disease detected in the test file is :- ');

if result == 'STOP'
     msg = ('Stop');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - STOP');
    
elseif result == 'No entry'
     msg = ('NO_ENTRY');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - NO_ENTRY');
    
elseif result == 'No left turn'
     msg = ('NO_LEFT_TURN');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - NO_LEFT_TURN');
    
elseif result =='No right turn'
     msg = ('NO_RIGHT_TURN');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - NO_RIGHT_TURN');
    
elseif result == 'No straight ahead'
     msg = ('NO_STRAIGHT_AHEAD');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - NO_STRAIGHT_AHEAD');
    
elseif result == 'No U-turn'
     msg = ('NO_U_TURN');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - NO_U_TURN');
    
elseif result == '30'
     msg = ('SPEED_LIMT is 30 Kmps');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - SPEED_LIMT is 30 Kmps');
    
elseif result == '40'
     msg = ('SPEED_LIMT is 40 Kmps');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as -SPEED_LIMT is 40 Kmps');
    
elseif result == '60'
     msg = ('SPEED_LIMT is 60 Kmps');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - SPEED_LIMT is 60 Kmps');
    
elseif result == 'Bicycles Only'
     msg = ('BICYCLES ONLY ');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - BICYCLES ONLY ');
    
elseif result == 'Horn prohibited'
     msg = ('Horn prohibited');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - Horn prohibited');  
    
elseif result == 'Level crossing with barrier ahead'
     msg = ('Level crossing with barrier ahead');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - Level crossing with barrier ahead'); 
    
elseif result == 'Turn left ahead'
     msg = ('TURN LEFT AHEAD ');        
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - TURN LEFT AHEAD');  
    
elseif result == 'turn right ahead'
     msg = ('TURN RIGHT AHEAD');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - TURN RIGHT AHEAD');  
    
elseif result == 'U_turn'
     msg = ('U_TURN');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - U_TURN');  
    
elseif result == 'vehicles prohibited'
     msg = ('VEHICLES ARE PROHIBITED ');          
    msgbox(msg,'The Traffic_Sign Recognised as..');
    disp('The Traffic_Sign Recognised as - VEHICLES ARE PROHIBITED');  
    
end
%% Top 3 Predictions Scores..

[~,idx] = sort(score,'descend');
idx = idx(5:-1:1);
classNamesTop = convnet.Layers(end).ClassNames(idx);
scoresTop = score(idx);

figure
barh(scoresTop)
xlim([0 1])
title('Top 5 Predictions')
xlabel('Probability')
yticklabels(classNamesTop)

%% ToTal Accuracy of Classifier system

% accuracy = sum(labels== YTest)/numel(YTest)
% Accuracy_Percent = accuracy.*100

YPred = classify(convnet,imdsTest);
YValidation = imdsTest.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)
Accuracy_Percent = accuracy.*100;

disp('The ToTal Accuracy of Classifier system is :- ');

Accuracy_Percent 
