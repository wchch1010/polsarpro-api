function test_model_based_decomposition
% test read and write functions
close all;
clc;
disp('Start test_model_based_decomposition');
load 'test.mat';
st.info.NLooks= 1;
[stOUT]= pspFreemanDecomposition(st, 5);
[RGB0]= pspCreatePauliRGBFile(st);

figure(1),imshow(RGB0,[]);
figure(2),imagesc([stOUT.data(:,:,1)]);


