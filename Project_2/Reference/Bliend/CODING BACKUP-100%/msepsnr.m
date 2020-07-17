function [mse,psnr]=msepsnr(i,y)

si=size(i);
m=si(1);
n=si(2);
x=double(i);
mse=0;
for e=1:m
    for f=1:n
    mse=mse+(x(e,f)-y(e,f))^2;
    end
end
mse=mse/(m*n);%%%%mse%%%%
psnr=10*log10((255^2)/mse);%%%%%psnr%%%%%

