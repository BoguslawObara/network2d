%% clear
clc; clear all; close all;

%% path
addpath('./libs');

%% load image
filename = './im/fungal_network.png';
im = imread(filename);

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% watershed
s = 1; 
imw = network_watershed2d(im,s);

%% skeleton + skeleton points
imsk = imw==0;
[imsk,imb,ime] = network_skeleton2d(imsk);

%% plot
imrgb = network_plot2d(im,imsk,imb,ime);

figure; 
imagesc(imrgb); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

%% save image
[pathstr,name,ext] = fileparts(filename);
filename = fullfile(pathstr,[name '_sk' ext]);

imwrite(imsk,filename);