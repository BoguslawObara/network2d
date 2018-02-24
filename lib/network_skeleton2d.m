function [imsk,imb,ime] = network_skeleton2d(imsk)

%% skeleton
imsk = bwmorph(imsk,'skel',Inf);

%% fill one pixel holes
imsk = bwmorph(imsk,'fill');
imsk = bwmorph(imsk,'skel',Inf);

%% branch and end points 
imb = bwmorph(imsk,'branchpoints');
ime = bwmorph(imsk,'endpoints');

end