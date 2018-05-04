%% clear
clc; clear all; close all;

%% path
addpath('./lib');
addpath('../vesselness2d/lib');
addpath('../vesselness_pct2d/lib');

%% load image
filename = './im/fungal_network.png';
im = imread(filename);

[pathstr,name,ext] = fileparts(filename);
filename_sk = fullfile(pathstr,[name '_sk' ext]);
imsk = imread(filename_sk);

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% skeleton points
[imsk,imb,ime] = network_skeleton2d(imsk);

%% network labeling
[imlabelbp,imlabelbr,idxbp,idxbre,idxc,idxci] = network_label2d(imsk);

%% pct vesselness
nscale = 6; 
norient = 6; 
minWaveLength = 2; 
mult = 1.5; 
sigmaOnf = 0.6;
beta = 5.5; 
c = .5;
[imf,vx,vy] = vesselness_pct2d(im,nscale,norient,minWaveLength,mult,sigmaOnf,beta,c);

%% pruning based on skeleton branch cost and area
t = 0.2; 
g = 0.5;
imsk2 = network_skeleton_prune_cost2d(imf,vx,vy,imsk,imlabelbp,imlabelbr,g,t,-1);

%% skeleton points
[imsk2,imb2,ime2] = network_skeleton2d(imsk2);

%% Labeling
[imlabelbp,imlabelbr,idxbp,idxbre,idxc,idxci] = network_label2d(imsk2);

%% pruning small branches
a = 3;
imsk3 = network_skeleton_prune_length2d(im,imsk2,ime,imlabelbp,imlabelbr,t,a);

%% skeleton points
[imsk3,imb3,ime3] = network_skeleton2d(imsk3);

%% plot
imrgb = network_plot2d(im,imsk,imb,ime);
imrgb2 = network_plot2d(im,imsk2,imb2,ime2);
imrgb3 = network_plot2d(im,imsk3,imb3,ime3);

figure; 
imagesc(imrgb); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; 
imagesc(imrgb2); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; 
imagesc(imrgb3); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

%% save image
[pathstr,name,ext] = fileparts(filename);
filename = fullfile(pathstr,[name '_skp' ext]);

imwrite(imsk3,filename);
