function imw = network_watershed2d(im,s)
%% filter
if s>0
    h = fspecial('gaussian',3*s,s);
    im = imfilter(im,h,'same');
end

%% watershed
imw = watershed(im,8); %4

end