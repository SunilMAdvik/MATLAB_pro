function [Feature_train train_label Feature_test]=featinp(Feature_Vector)

%% SVM Classifier
  Feature_test = Feature_Vector;
  load Train_data                        % Train the images and save file... 
train_label      = zeros(size(20,1),1);
train_label(1:8,1)   = 1;                 % group 1
train_label(9:18,1)  = 2;                 % group 2
train_label(19:25,1)   = 3;               % group 3
train_label(26:33,1)   = 4;               % group 4
train_label(34:44,1)   = 5;               % group 5
train_label(45:52,1)   = 6;               % group 6
train_label(53:61,1)   = 7;               % group 7

end