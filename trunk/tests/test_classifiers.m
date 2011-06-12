function test_classifiers
% test classification techniques
close all;
clc;
disp('Start test_classifiers');
load 'test.mat';
stF= pspLeeRefinedFilter(st, 1, 9); %-- filtering first
stHAAlpha= pspHAAlphaDecomposition(stF);  %-- Compute H/A/Alpha decomposition
stCL= pspWishartHAAlphaClassifier(stF, stHAAlpha); %-- Compute Wishart classifications
RGB0= [stCL.data(:,:,1) stCL.data(:,:,2)];
figure('Name','pspWishartHAAlphaClassifier'),imagesc(RGB0);axis image off; colorbar;
%[stOut]= pspClassificationColormapPauli(stF,stCL,'Wishart_Pauli.bmp'); %-- does not work for now

stCL= pspHAAlphaPlanesClassifier(stHAAlpha);  %-- Compute simple H/A/alpha classifications
RGB0= [stCL.data(:,:,1) stCL.data(:,:,2) stCL.data(:,:,3)];
figure('Name','pspHAAlphaPlanesClassifier'),imagesc(RGB0);axis image off; colorbar;title('H/A       H/alpha       A/alpha');