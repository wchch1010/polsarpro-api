function test_pspCloudeDecomposition
% test read and write functions
close all;
clc;
disp('Start test_read_write');
load 'test.mat';
[stOUT]= pspCloudeDecomposition(st, 7);
[RGB0]= pspCreatePauliRGBFile(st);
[RGB1]= pspCreatePauliRGBFile(stOUT);
RGB0= cat(2,RGB0,RGB1);
figure('Name','pspCloudeDecomposition'),imshow(RGB0,[]);

[stOut]= pspHAAlphaDecomposition(stOUT, 7);
RGB0= [stOut.data(:,:,1) stOut.data(:,:,2) stOut.data(:,:,3)./90.0];
figure('Name','pspHAAlphaDecomposition'),imagesc(RGB0);axis image off; colorbar;