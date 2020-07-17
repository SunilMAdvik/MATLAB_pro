function K =Meadian(RGBIMAGE)
% filter each channel separately
r = medfilt2(RGBIMAGE(:, :, 1), [3 3]);
g = medfilt2(RGBIMAGE(:, :, 2), [3 3]);
b = medfilt2(RGBIMAGE(:, :, 3), [3 3]);

% reconstruct the image from r,g,b channels
K = cat(3, r, g, b);
end