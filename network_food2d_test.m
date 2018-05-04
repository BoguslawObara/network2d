%% clear
clc; clear all; close all;

%% path
addpath('./lib');

%% load image
im = imread('./im/fungal_network_food.png');

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% food detection
s1 = 8; 
s2 = 0; 
t = 0.2;
[imth,cf] = network_food2d(im,s1,s2,t);

%% plot
figure; imagesc(im); colormap gray;
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

%% plot
immask = boundarymask(imth);

imr = im; img = im; imb = im;
imr(immask) = 1; img(immask) = 0; imb(immask) = 0;
imrgb = zeros(size(im,1),size(im,2),3);
imrgb(:,:,1) = imr; imrgb(:,:,2) = img; imrgb(:,:,3) = img;

figure; 
imagesc(imrgb); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;
