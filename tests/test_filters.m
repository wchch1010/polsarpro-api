function test_filters
% test read and write functions
close all;
clc;
disp('Start test_read_write');
load 'test.mat';
st.info.NLooks= 1;
[stOUT]= pspLeeSigmaFilter(st, st.info.NLooks, 9, 9, 3);
[RGB0]= pspCreatePauliRGBFile(st);
[RGB1]= pspCreatePauliRGBFile(stOUT);
RGB0= cat(2,RGB0,RGB1);
figure(1),imshow(RGB0,[]);
[stOUT]= pspLeeRefinedFilter(st, st.info.NLooks, 9);
[RGB1]= pspCreatePauliRGBFile(stOUT);
RGB0= cat(2,RGB0,RGB1);
figure(1),imshow(RGB0,[]);
[stOUT]= pspPWFFilter(st, st.info.NLooks, 9);
[RGB1]= pspCreatePauliRGBFile(stOUT);
RGB0= cat(2,RGB0,RGB1);
figure(1),imshow(RGB0,[]);

