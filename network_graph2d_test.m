%% clear
clc; clear all; close all;

%% path
addpath('./lib');

%% Load image
filename = './im/fungal_network.png';
im = imread(filename);

[pathstr,name,ext] = fileparts(filename);
filename_sk = fullfile(pathstr,[name '_skp' ext]);
imsk = imread(filename_sk);

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% skeleton points
[imsk,imb,ime] = network_skeleton2d(imsk);

%% labeling
[imlabelbp,imlabelbr,idxbp,idxbre,idxc,idxci] = network_label2d(imsk);

%% graph
[graph,imlabelbe] = network_graph2d(imsk,imlabelbp,imlabelbr,idxbre,idxc,idxci);

%% plot
imrgb = network_plot2d(im,imsk,imb,ime);

figure; 
imagesc(imrgb); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

figure; 
network_graph_plot2d(imsk,imlabelbp,imlabelbe,graph)
