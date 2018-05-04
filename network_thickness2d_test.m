%% clear
clc; clear all; close all;

%% path
addpath('./lib');

%% load image
filename = './im/fungal_network.png';
im = imread(filename);

[pathstr,name,ext] = fileparts(filename);
filename_sk = fullfile(pathstr,[name '_skp' ext]);
imsk = imread(filename_sk);

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% thickness
t = 0.4; 
s = 4;
[imskd,imskn] = network_thickness2d(im,imsk,t,s);

%% thickness normalised with image intensity
s = 5; 
se = strel('disk',s);
h = double(se.getnhood);
imsum = imfilter(im,h);
imsum = imsum/sum(h(:));
imthick = imskd.*imsum;

%% thickness: pixels -> microns 
% rxy = 20/270;
% imthick = rxy*imthick;

%% plot
figure; imagesc(im); colormap gray;
set(gca,'xtick',[]);set(gca,'ytick',[]); axis equal; axis tight;

figure; imagesc(log(imthick)); colormap('jet');
set(gca,'xtick',[]);set(gca,'ytick',[]); axis equal; axis tight;
cmap = colormap; cmap(1,:) = [0 0 0]; colormap(cmap);
