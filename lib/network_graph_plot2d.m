function network_graph_plot2d(imsk,imlabelbp,imlabelbe,graph)
%% plot
imlabelbpbe = max(imlabelbp,imlabelbe);
s  = regionprops(imlabelbpbe,'Centroid');
c = cat(1,s.Centroid);
imt = 255*ones(size(imsk));
image(imt); colormap gray; hold on;

for i=1:size(graph,1)
    if sum(find(graph(i,:)==-1))==0
        g = graph(i,1:2);
        plot(c(g,1),c(g,2),'k-','LineWidth',1);
    else
        % disp('EEEE');
    end
end
set(gca,'xtick',[]);set(gca,'ytick',[]); axis equal; axis tight;

end