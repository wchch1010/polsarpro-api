function test_read_write
% test read and write functions
close all;
clc;
disp('Start test_read_write');
load 'test.mat';
disp('Writing test set');
base_dir = [fileparts(which('test_read_write')) '/'];
figure,imagesc(sum(st.data(:,:,[1 4 6]),3)); axis off square;
mat2psp(st, base_dir);
disp('Loading test set');
st2= psp2mat('T3',base_dir);
figure,imagesc(sum(st2.data(:,:,[1 4 6]),3)); axis off square;
disp('Data Conversion');
[RGB0]= pspCreatePauliRGBFile(st);
[stC3]= pspDataConversion(st,'C3'); %-- conversion toward C3
[RGB1]= pspCreatePauliRGBFile(stC3);
figure,imagesc([st.data(:,:,1)-stC3.data(:,:,1)]);
[stT3]= pspDataConversion(stC3,'T3'); %-- conversion back
sum(st.data(:)-stT3.data(:))