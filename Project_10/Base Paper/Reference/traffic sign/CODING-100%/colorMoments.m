function [rmeanR,rstdR,rmeanG,rstdG,rmeanB,rstdB]= colorMoments(image)
% input: image to be analyzed and extract 2 first moments from each R,G,B
% output: 1x6 vector containing the 2 first color momenst from each R,G,B
% channel

% extract color channels
R = double(image(:, :, 1));
G = double(image(:, :, 2));
B = double(image(:, :, 3));

% compute 2 first color moments from each channel
meanR = mean( R(:) );
stdR  = std( R(:) );
meanG = mean( G(:) );
stdG  = std( G(:) );
meanB = mean( B(:) );
stdB  = std( B(:) );

rmeanR=round(meanR);
rstdR=round(stdR);
rmeanG=round(meanG);
rstdG=round(stdG);
rmeanB=round(meanB);
rstdB=round(stdB);

% construct output vector
colorMoments = zeros(1, 6);
colorMoments(1, :) = [meanR stdR meanG stdG meanB stdB];

% % clear workspace
% clear('R', 'G', 'B', 'meanR', 'stdR', 'meanG', 'stdG', 'meanB', 'stdB');

end