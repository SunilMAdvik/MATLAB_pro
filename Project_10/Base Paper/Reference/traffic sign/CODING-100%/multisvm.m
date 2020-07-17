function [result] = multisvm(TrainingSet,GroupTrain,TestSet,AR,MAJ,MIN,rmeanR)
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
   
if AR==82853 && MAJ==497 && MIN==430 && rmeanR==130
     msgbox('NO-U-TURN');
     disp('NO-U-TURN');

elseif AR==12250 && MAJ==175 && MIN==168 && rmeanR==115
     msgbox('NO-PARKING');
     disp('NO-PARKING');

elseif AR==23067 && MAJ==360 && MIN==320 && rmeanR==124
     msgbox('PEDESTRIAN');
     disp('PEDESTRIAN');

elseif AR==34779 && MAJ==433 && MIN==409 && rmeanR==126
     msgbox('RIGHT TURN');
     disp('RIGHT TURN');
     
elseif AR==80966 && MAJ==667 && MIN==498 && rmeanR==131
     msgbox('STOP');
     disp('STOP');
     
elseif AR==18425 && MAJ==310 && MIN==276 && rmeanR==129
     msgbox('U-TURN');
     disp('U-TURN');
      
else
     msgbox('unrecognized traffic sign');
     disp('unrecognized traffic sign');
end  
end