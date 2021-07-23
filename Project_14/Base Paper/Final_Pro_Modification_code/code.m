clc;
close all;
clear all;
%% general settings ...
fontsize = 14;
%% Create Network and Train...
matlabroot='D:\Ad@off\2018-2019 DIP-BACKUP\Bangalore Projects\Project 14-Modification\Source Code\Modification\Final_Pro';
Datasetpath=fullfile(matlabroot,'Data_sets');
imds =imageDatastore(Datasetpath,'IncludeSubfolders',true,'LabelSource','foldernames');

%% Display some sample images.
figure;
perm = randperm(55,20);
 for i = 1:20
     subplot(4,5,i);
    imshow(imds.Files{perm(i)});
 end
 
%% Split Data into Training and testing sets ...

[imdsTrain,imdsTest] = splitEachLabel(imds,0.7);

idx = randperm(55,17);

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

layers=[imageInputLayer([150 150 3])
    convolution2dLayer(5,20)  
   reluLayer
   maxPooling2dLayer(2,'stride',2)
   convolution2dLayer(5,20)  
reluLayer
 maxPooling2dLayer(2,'stride',2)
 fullyConnectedLayer(5)
 softmaxLayer
    classificationLayer()]

%% Training Option ...

options = trainingOptions('sgdm','MaxEpochs',20,...
	'InitialLearnRate',0.0001);

%% Train CNN ..

convnet=trainNetwork(imds,layers,options);

inputSize = convnet.Layers(1).InputSize

classNames = convnet.Layers(end).ClassNames;
numClasses = numel(classNames);
disp(classNames(randperm(numClasses,5)))

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
RGBIMAGE = imresize(IM,[150 150]);  

size(RGBIMAGE)

%% 1st  convolutional layer output...

% Get the network weights for the second convolutional layer
w1 = convnet.Layers(2).Weights;

% Scale and resize the weights for visualization
w1 = mat2gray(w1);
w1 = imresize(w1,5);

% Display a montage of network weights. There are 96 individual sets of
% weights in the first layer.
figure
montage(w1)
title('First convolutional layer weights')

%% Clasification ...

% [label,score] = classify(convnet,IM);
[label,score] = classify(convnet,RGBIMAGE);

label

figure,imshow(RGBIMAGE)
title(string(label) + ", " + num2str(100*score(classNames == label),3) + "%");

result = label;

%% display classify results

disp('The disease detected in the test file is :- ');

if result=='Healty_leaf'
     msg = ('Healty_Leaf');          
    msgbox(msg,'The Result is..');
    disp('Healty_Leaf');
    
elseif result=='Bacterial_bright'
     msg = ('Bacterial bright');          
    msgbox(msg,'The Result is..');
    disp('Bacterial bright');
     msg = ('Type1:Bacterial bright Disease(i) Use balanced amounts of plant nutrients, especially nitrogen(ii)Apply N in three split doses, 50% basal, 25% in tillering phase and 25%N in panicle initiation stage');
    msgbox(msg,'The suggestion is..'); 
    
elseif result=='Brown_spot'
  msg = ('Brown spot');          
    msgbox(msg,'The Result is..');
    disp('Brown spot');
    msge =  ('Type 2: Brown Spot Disease(i) monitor soil nutrients regularly(ii) apply required fertilizers (iii) for soils that are low in silicon, apply calcium silicate slag before planting..Spraying of infected plants with fungicides, such as Benzoyl and Iprodione and antibiotics, such as Validamycin and Polyoxin, is effective against the disease.');
    msgbox(msge,'The suggestion is..');
    
elseif result=='Leaf_Blast'
      msg = ('Leaf blast');          
    msgbox(msg,'The Result is..');
    disp('Leaf blast');
     msge = ('Type 3: Leaf Blast Disease(i) Adjust planting time. Sow seeds early, when possible, after the onset of the rainy season... (ii) Split nitrogen fertilizer application in two or more treatments. Excessive use of fertilize');
    msgbox(msge,'The suggestion is..');
    
elseif result=='Leaf_streak'
      msg = ('Leaf streak');          
    msgbox(msg,'The Result is..');
    disp('Leaf streak');
    msgbox(msg,'The suggestion is..');
    msg = ('Type 4: Leaf_streak Disease Foliar spray of 0.05 g Streptocycline and 0.05 g Copper Sulfate');   
    
end
%% Top 3 Predictions Scores..

[~,idx] = sort(score,'descend');
idx = idx(3:-1:1);
classNamesTop = convnet.Layers(end).ClassNames(idx);
scoresTop = score(idx);

figure
barh(scoresTop)
xlim([0 1])
title('Top 3 Predictions')
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


% YPred = reshape(YPred,[5,5])
[C,order] = confusionmat(YValidation,YPred);










