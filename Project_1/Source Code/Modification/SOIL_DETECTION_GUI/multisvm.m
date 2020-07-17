function [result] = multisvm(TrainingSet,GroupTrain,TestSet)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 

u=unique(GroupTrain);
numClasses=length(u);
result = zeros(length(TestSet(:,1)),1);

%build models
for k=1:numClasses
    G1vAll=(GroupTrain==u(k));
    models(k) = svmtrain(TrainingSet,G1vAll);
end

%classify test cases
for j=1:size(TestSet,1)
    for k=1:numClasses
        if(svmclassify(models(k),TestSet(j,:))) 
            break;
        end
    end
    result(j) = k;
   
    if result == 1
    helpdlg(' Clay ');
    disp(' Clay ');
elseif result == 2
    helpdlg(' Clayey Peat ');
    disp('Clayey Peat');
elseif result == 3
    helpdlg(' Clayey Sand ');
    disp(' Clayey Sand ');
elseif result == 4
    helpdlg(' Humus Clay ');
    disp(' Humus Clay ');
elseif result == 5
    helpdlg(' Peat ');
    disp(' Peat ');
elseif result == 6
    helpdlg(' Sandy Clay ');
    disp('Sandy Clay');
elseif result == 7
    helpdlg(' Silty Sand ');
    disp(' Silty Sand ');
end
end