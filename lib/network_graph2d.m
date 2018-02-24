function [graph,imlabelbe] = network_graph2d(imsk,imlabelbp,imlabelbr,idxbre,idxc,idxci)
%% graph analysis
be = [];
idbre = imlabelbr(idxbre);

%% loop
for i=1:length(idxbre)
    idx = ismember(idxc,idxbre(i));
    idxid = idxci(idx);
    for j=1:length(idxid)
       be = [be; [idbre(i) idxid(j)]]; % be = [branch id, branching point id]
    end
end

%% clean up
be = unique(be,'rows');

%% end points 
%% TODO: error here -> look for the 0 values in be
imbe = bwmorph(imsk,'endpoints');

%% correction for bwmorph(imsk,'endpoints'); !!!!
idxbe = find(imbe>0);
idx = ~imsk(idxbe);
imbe(idxbe(idx)) = false; 

%% add branching ends
idxbe = find(imbe>0);
idbe = imlabelbr(idxbe);
m = max(imlabelbp(:));
for i=1:length(idxbe)
    be = [be; [idbe(i) m+i]]; % be = [branch id, branching end point id]
end

%% label end points
imlabelbe = zeros(size(imsk));
for i=1:length(idxbe)
    imlabelbe(idxbe(i)) = m+i;
end

%% graph
graph = [];
beu = unique(be(:,1));
for i=1:length(beu)
    idx = ismember(be(:,1),beu(i));
    idx = find(idx);
    if length(idx)>1 % if less than 1 then it can be the loop 'bp1----bp1'
        if length(idx)>2
            fff = 6;
        end
        nch = nchoosek(1:length(idx),2);
        for j=1:size(nch,1)
            graph = [graph; ...
            [be(idx(nch(j,1)),2) be(idx(nch(j,2)),2) beu(i)]]; 
        end
    else
        graph = [graph; [-1 -1 -1]];
        disp(['EEEE: ' num2str(beu(i))]);
    end
end

end