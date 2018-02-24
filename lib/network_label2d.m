function [imlabelbp,imlabelbr,idxbp,idxbre,idxc,idxci] = network_label2d(imsk)
%% branch points
imbp = bwmorph(imsk,'branchpoints');
imlabelbp = bwlabel(imbp);
sbp = regionprops(imbp,'PixelIdxList');
idxbp = find(imbp>0);

%% branch points index = all neighbors of every pixel: (x,y) -> [3x3]
[m,n] = size(imsk);
k = length(sbp);
idxBPN = cell(k,1);
for i=1:k
    idxbpn = [];
    idx = sbp(i).PixelIdxList;
    for j=1:length(idx)
        [y,x] = ind2sub([m,n],idx(j));
        [xn,yn,idxn] = neighbor8c(m,n,x,y);
        idxbpn = [idxbpn; idxn];
    end
    idxBPN{i} = idxbpn; % all neighbors of every pixel
end

%% end points of every branch attached to branch point 
%     o           o        ####        1
% ooooxxooo   oooo  ooo    ####    0001  100
%      o            o      ####          1
imskbp = imsk;
imskbp(idxbp) = false; % Remove branchpoints
idxskbp = find(imskbp>0);
idxc = [];  % idx of End Points of Every Branch Attached to Branch Point position
idxci = []; % idxci represents the id of to which sbp idexes idxc belongs
for i=1:k
    idxn = idxBPN{i};
    idx = ismember(idxn,idxskbp);
    idxc = [idxc; idxn(idx)];
    idxni = i*ones(length(find(idx==1)),1);
    idxci = [idxci; idxni]; 
end

%% TODO - which idxbre -> idxc -> idxBPN{i} -> idxbp
[idxbre,idxbrei] = unique(idxc); % idxbre - unique ends of branches attached to branching point positions
u = length(idxbre);
% idxbpi = idxci(idxbrei); % index of branch point (idxbp) -> idxbre

%% label only proper branches 
%% without end points of every branch attached to branch point 
idxbpn = cell2mat(idxBPN);
imbr = imsk;
imbr(idxbpn) = false;
imlabel = bwlabel(imbr);
imlabelbr = imlabel;
idxbr = find(imbr>0);

%% reconstruct branch from end point
idxa = [];  idxna = []; idxid = [];
for i=1:u
    idx = idxbre(i);
    [y,x] = ind2sub([m,n],idxbre(i));
    [xn,yn,idxn] = neighbor8c(m,n,x,y);    
    %idxr = ismember(idxn,idxbpn);
    %return
    %idxn(idxr) = [];
    idxn = idxn(ismember(idxn,idxbr));
    if isempty(idxn)
        idxna = [idxna; idx]; 
    elseif length(idxn)==1
        idxid = [idxid; idxn]; 
        idxa = [idxa; idx]; 
    else
        disp('Error');
    end
end

%% re-label end points of every branch attached to branch point 
d = length(idxid);
for i=1:d
    id = imlabel(idxid(i));
    imlabelbr(idxa(i)) = id;
end

%% to which branching point the pixel belongs
idx = ismember(idxbre,idxna); % find not assigned points
idxbrena = idxbre(idx);
NA = {};
for i=1:length(idxbrena)
    idx = ismember(idxc,idxbrena(i));
    NA{i,1} = unique(idxci(idx)); % To which branching point the pixel belongs 
end

%% remove 4-conn object with area > 1
imbrena = zeros(size(imsk))==1;
imbrena(idxna) = 1;
imlabelbrena4c = bwlabel(imbrena,4);
stats = regionprops(imlabelbrena4c,'Area');
idx = find([stats.Area]>1);
im4c = ismember(imlabelbrena4c,idx);

%% re-label not assigned points 4c
% 4c objects
imlabel4c = bwlabel(im4c,4);
% s4c = regionprops(im4c,'PixelIdxList');
s4c = regionprops(imlabel4c,'PixelIdxList');
m = max(imlabelbr(:));
for i=1:length(s4c)
    imlabelbr(s4c(i).PixelIdxList) = m + i;
end

%% remove assigned points
idx4c = find(im4c>0);
idx = ~ismember(idxbrena,idx4c); % find not assigned points
idxbrena = idxbrena(idx);
NA = NA(idx);

%% check if pixels of 8-conn object with area = 2  belond to the same branching point
m = max(imlabelbr(:));
im8c = imbrena;
im8c(idx4c) = false;
imlabelbrena8c = bwlabel(im8c,8);
s8c = regionprops(im8c,'PixelIdxList');
% imt = zeros(size(imsk));
% imt(imsk) = 1;
% imt(idxbp) = 2;
for i=1:max(imlabelbrena8c(:))
    m = m+1;
    idx = s8c(i).PixelIdxList;
    idxm = find(ismember(idxbrena,idx));
    idsp = [];
    idspn = [];
    for j=1:length(idxm)
        na = NA{idxm(j),1};
        idsp = [idsp; na];      
        idspn = [idspn; length(na')]; 
    end
    [idxu,nu,mu]= unique(idsp);
    px = s8c(i).PixelIdxList';
    if length(idxu)==length(idsp) % if each pixel belongs to different intersection       
        imlabelbr(px) = m;
        %imt(px) = 3;
        m = m+1;
    elseif length(idxu)~=length(idsp) && length(idx)>1 %is the second condition it needed
        idx3 = find(idspn>1);
        if ~isempty(idx3)
            for j=1:length(idx3) % if belongs to more than one intersection
                %imt(px(idx3(j))) = 4;
                imlabelbr(px(idx3(j))) = m;
                m = m+1;
            end
            px(idx3) = [];
            if ~isempty(px); m = m+1; end
            for j=1:length(px) %if belongs to one intersection
                imlabelbr(px(j)) = m;
            end
        end
        if isempty(idx3)
            s = -1;
            for j=1:length(mu) 
                if nu(j)~=j
                    s = j;
                    break;
                end
            end
            if s~=-1
                imlabelbr(px(1:s)) = m;
                imlabelbr(px(s+1:end)) = m+1;
                m = m+1;
            end
        end
    else
        disp('EEEEEEE')
    end
end

end