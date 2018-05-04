function [imsk,imc] = network_skeleton_prune_cost2d(im,imvx,imvy,imsk,imlabelbp,imlabelbr,g,t,a)
%% loop
n = max(imlabelbr(:)); 
sbr = regionprops(imlabelbr,'PixelIdxList');
w = zeros(1,n);
c = zeros(1,n);
[xn,yn] = size(im);

for i=1:n
    [x,y] = ind2sub([xn,yn],sbr(i).PixelIdxList);
    cc = [];
    k = length(x);
    if k>1
        for j=1:k
            if j<k
                x1 = x(j); 
                x2 = x(j+1); 
                y1 = y(j);
                y2 = y(j+1);
                cc(j) = path_cost2d(im,imvx,imvy,x1,y1,x2,y2,g);
            else
                x1 = x(end); 
                x2 = x(end-1); 
                y1 = y(end);
                y2 = y(end-1);
                cc(j) = path_cost2d(im,imvx,imvy,x1,y1,x2,y2,g);
            end
        end
    else
        cc = im(sbr(i).PixelIdxList);
    end
    %C = sum(C)/k;
    %C = median(C);
    cc = mean(cc);
    c(i) = cc;
    if cc<t
        w(i) = 1;
    end
end

%% prune
idx = find(w==1);
for i=1:length(idx)
    imsk(sbr(idx(i)).PixelIdxList) = false;
end

%% cost map
imc = zeros(xn,yn);
for i=1:n
    imc(sbr(i).PixelIdxList) = c(i);
end

%% area
if a==-1
    
    %% filter
    imsk = bwmorph(imsk,'skel',Inf);
    imsk = bwmorph(imsk,'thin',Inf);        
    imsk = bwmorph(imsk,'skel',Inf);
    imsk = bwmorph(imsk,'fill');
    imsk = bwmorph(imsk,'skel',Inf);
    
    %% max area
    imlabel = bwlabel(imsk,8);
    s  = regionprops(imlabel,'Area','PixelIdxList');
    area = cat(1,s.Area);    
    [m,idx] = max(area);
    imsk(~(imlabel==idx)) = false;
else
    idx = 1;
    while ~isempty(idx)
        
        % filter
        imsk = bwmorph(imsk,'skel',Inf);
        imsk = bwmorph(imsk,'thin',Inf);        
        imsk = bwmorph(imsk,'skel',Inf);
        imsk = bwmorph(imsk,'fill');
        imsk = bwmorph(imsk,'skel',Inf);
        
        % prune
        imlabel = bwlabel(imsk,8);
        s  = regionprops(imlabel,'Area','PixelIdxList');
        area = cat(1,s.Area);
        idx = find(area<a);
        for i=1:length(idx)
            imsk(s(idx(i)).PixelIdxList) = false;
        end
    end
end

%% filter
imsk = bwmorph(imsk,'skel',Inf);
imsk = bwmorph(imsk,'fill');
imsk = bwmorph(imsk,'skel',Inf);

%% filter
% imbp = imlabelbp>0;
% imbe = bwmorph(imsk,'endpoints');
% imbebp = immultiply(imbe,imbp);
% imsk(imbebp) = false;

%% filter
imsk = bwmorph(imsk,'skel',Inf);
imsk = bwmorph(imsk,'fill');
imsk = bwmorph(imsk,'skel',Inf);

end