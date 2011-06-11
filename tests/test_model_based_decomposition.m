function test_model_based_decomposition
% test model based decompositions
close all;
clc;
disp('Start test_model_based_decomposition');
load 'test.mat';
st.info.NLooks= 1;
[stF]= pspLeeRefinedFilter(st, 1, 9);
[stOUT]= pspFreemanDecomposition(stF);
figure('Name','pspFreemanDecomposition'),imagesc([stOUT.data(:,:,1) stOUT.data(:,:,2) stOUT.data(:,:,3)]);axis off image;colorbar;
[stOUT]= pspYamaguchiDecomposition(stF, 3);
figure('Name','pspYamaguchiDecomposition3'),imagesc([stOUT.data(:,:,1) stOUT.data(:,:,2) stOUT.data(:,:,3)]);axis off image;colorbar;
[stOUT]= pspYamaguchiDecomposition(stF, 4);
figure('Name','pspYamaguchiDecomposition4'),imagesc([stOUT.data(:,:,1) stOUT.data(:,:,2) stOUT.data(:,:,3) stOUT.data(:,:,4)]);axis off image;colorbar;

