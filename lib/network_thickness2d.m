function [imskd,imskn] = network_thickness2d(im,imsk,t,s)

%% thickness
imskn = imsk;
for i=1:s
    se = strel('disk',1);
    imd = imdilate(imskn,se);
    ims = imsubtract(imd,imskn)==1;
    imv = zeros(size(im));
    imv(ims) = im(ims);
    imv = imv>t;
    imm = max(imskn,imv);
    imskn = imreconstruct(imskn,imm,4);
end
% imskn = imreconstruct(imskn,imsk,4); %% REMOVE/ADD
% imskn = imreconstruct(imsk,imskn,4); %% REMOVE/ADD

%% remove zeros
% imskn(im<t) = 0;

%% add imsk
% imskn(imsk) = 1;

%% distance
imd = bwdist(~imskn);

%% skeleton-based distance
imskd = zeros(size(im)); 
imskd(imsk) = imd(imsk);

end