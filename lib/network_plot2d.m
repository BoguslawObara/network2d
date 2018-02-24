function imrgb = network_plot2d(im,imrm,imgm,imbm,imf)
%% setup
if nargin<5; imf = []; end

%% plot
imrgb = zeros(size(im,1),size(im,2),3);

imr = im; img = im; imb = im;
imr(imrm) = 1; img(imrm) = 0; imb(imrm) = 0;
imr(imgm) = 0; img(imgm) = 1; imb(imgm) = 0;
imr(imbm) = 0; img(imbm) = 0; imb(imbm) = 1;

% food
if ~isempty(imf)
    imfb = bwperim(imf);
    imr(imfb) = 1; img(imfb) = 0; imb(imfb) = 1;
end

imrgb(:,:,1) = imr; imrgb(:,:,2) = img; imrgb(:,:,3) = imb;

end