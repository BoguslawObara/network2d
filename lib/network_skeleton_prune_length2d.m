function imsk = network_skeleton_prune_length2d(im,imsk,imbe,imlabelbp,imlabelbr,t,a)
%% find short branches
n = max(imlabelbr(:)); 
sbr = regionprops(imlabelbr,'PixelIdxList');
idxbe0 = find(imbe);
idxbe1 = find(bwmorph(imsk,'endpoints'));
idxbe1(ismember(idxbe1,idxbe0)) = [];
w = zeros(1,n);

for i=1:n
    v = im(sbr(i).PixelIdxList);
    m = median(v);
    ar = length(v);
    isbe = sum(ismember(sbr(i).PixelIdxList,idxbe1));
    if m>t && ar<a && isbe>0
        w(i) = 1;
    elseif ar==1 && isbe>0
        w(i) = 1;
    end
end

%% prune
idx = find(w==1);
for i=1:length(idx)
    imsk(sbr(idx(i)).PixelIdxList) = false;
end
% imlabel = bwlabel(imsk,8);
% s  = regionprops(imlabel,'Area','PixelIdxList');
% area = cat(1,s.Area);
% [m,idx] = max(area);
% imsk(~(imlabel==idx)) = false;

%% filter
imsk = bwmorph(imsk,'skel',Inf);
imsk = bwmorph(imsk,'fill');
imsk = bwmorph(imsk,'skel',Inf);

%% filter
imbp = imlabelbp>0;
imbe = bwmorph(imsk,'endpoints');
imbebp = immultiply(imbe,imbp);
imsk(imbebp) = false;

%% filter
imsk = bwmorph(imsk,'skel',Inf);
imsk = bwmorph(imsk,'fill');
imsk = bwmorph(imsk,'skel',Inf);

end