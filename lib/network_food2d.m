function [imf,cf] = BOFungalNetworkFood2D(im,s1,s2,t)
if nargin<4; t = 0.2; end
level = graythresh(im);
imth = im>(level-t*level);
%% Filter
imf = imth;
se = strel('disk',s1);
imf = imopen(imf,se);
imf = imclose(imf,se);
se = strel('disk',s2);
imf = imdilate(imf,se);
stats  = regionprops(bwlabel(imf),'Centroid');
cf = cat(1,stats.Centroid);
end