function test_classifiers
% test classification techniques
close all;
clc;
disp('Start test_classifiers');
load 'test.mat';
[stF]= pspLeeRefinedFilter(st, 1, 9);
[stCL]= pspWishartHAAlphaClassifier(stF)
RGB0= [stCL.data(:,:,1) stCL.data(:,:,2)];
figure('Name','pspWishartHAAlphaClassifier'),imagesc(RGB0);axis image off; colorbar;