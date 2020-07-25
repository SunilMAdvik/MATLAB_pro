clc;           
clear;        
close all;  
di=dir('letters_numbers');
st={di.name};
nam=st(3:end);
imgfile=cell(2,length(nam));
for i=1:length(nam)
   imgfile(1,i)={imread(['letters_numbers','\',cell2mat(nam(i))])};
   temp=cell2mat(nam(i));
   imgfile(2,i)={temp(1)};
end
save('imgfildata.mat','imgfile');
clear;
