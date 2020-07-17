function [I rows columns]=Con_ADJ(K)
I = imadjust(K,stretchlim(K));
[rows columns]=size(K);
end