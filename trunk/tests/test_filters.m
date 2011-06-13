function test_filters
% test filtering functions
close all;
clc;
disp('Start test_filters');
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
[stOut]= pspBoxcarFilter(st,9);
[RGB1]= pspCreatePauliRGBFile(stOUT);
RGB0= cat(2,RGB0,RGB1);
figure(1),imshow(RGB0(1:2:end,1:2:end,:),[]);