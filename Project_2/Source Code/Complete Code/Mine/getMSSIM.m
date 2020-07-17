function mssim=getMSSIM(frameReference,frameUnderTest)
%Written by: Mahmoud Afifi ~ Assiut University, Egypt
%Reference: Z. Wang, A. C. Bovik, H. R. Sheikh and E. P. Simoncelli,
%?Image quality assessment: From error visibility to structural similarity,?
%IEEE Transactions on Image Processing, vol. 13, no. 4, pp. 600-612, Apr. 2004
%///////////////////////////////// INITS  ////////////////////////////////
C1 = 6.5025;
C2 = 58.5225;
frameReference=double(frameReference);
frameUnderTest=double(frameUnderTest);
frameReference_2=frameReference.^2;
frameUnderTest_2=frameUnderTest.^2;
frameReference_frameUnderTest=frameReference.*frameUnderTest;
%///////////////////////////////// PRELIMINARY COMPUTING ////////////////////////////////
mu1=medfilt2(frameReference,[3 3]);
mu2=medfilt2(frameUnderTest,[3 3]);
mu1_2=mu1.^2;
mu2_2=mu2.^2;
mu1_mu2=mu1.*mu2;
sigma1_2=medfilt2(frameReference_2,[3 3]);
sigma1_2=sigma1_2-mu1_2;
sigma2_2=medfilt2(frameUnderTest_2,[3 3]);
sigma2_2=sigma2_2-mu2_2;
sigma12=medfilt2(frameReference_frameUnderTest,[3 3]);
sigma12=sigma12-mu1_mu2;
%///////////////////////////////// FORMULA ////////////////////////////////
t3 = ((2*mu1_mu2 + C1).*(2*sigma12 + C2));
t1 =((mu1_2 + mu2_2 + C1).*(sigma1_2 + sigma2_2 + C2));
ssim_map =  t3./t1;
mssim = mean2(ssim_map); mssim=mean(mssim(:));