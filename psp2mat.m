function [st]= psp2mat(dataType,folderName,sHeaderName)

%% Synopsis:
%  [stPolSAR]= psp2mat(dataType, folderName)
% 
% Input:
% - folderName  string  path directory of PolSARpro data input folder 
% - dataType    string  'Covariance' or 'Coherency'
% - dataSave    boolean to save data or not
%
% Output:
% - stPolSAR     structure  .data  [n m 6] data -> [n m (X11,X12,X13,X22,X23,X33)]
%                           .info(.type,.history)
% or
% 
% - stPolSAR     structure  .data(.band1,...,.band6) (X11,X12,X13,X22,X23,X33)
%                           .info(.type,.history)
% 
% Description:
% polSARpro2mat convert the coherency matrix file .bin of PolSARPro into  
% a coherency or covariance matrix file .mat of Matlab.
% 
% Inputs  : In in_dir directory
% T11.bin, T12_real.bin, T12_imag.bin, T13_real.bin,
% T13_imag.bin, T22.bin, T23_real.bin, T23_imag.bin
% T33.bin
%
%
% Author: Sovattara Hell, Gregory Farage, Samuel Foucher - Vision team, Dept. of R&D, CRIM
% Created in 2008
%
%

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;

if exist('sHeaderName')
    HEADER_NAME= sHeaderName;
else
    HEADER_NAME= [];
end
if ~exist('folderName','var')
    folderName= POLSARPRO_API_OUT_DIR;
end
if folderName(end) ~= '/'
    folderName= [folderName '/'];
end
[vFileNames, vComplex]= FileNames(dataType);
num_bands= numel(vComplex);
p= 1;
for b=1:num_bands
   if vComplex(b)
       st.data(:,:,b)= ReadBand(vFileNames{p},folderName,HEADER_NAME);
       p=p+1;
       st.data(:,:,b)= st.data(:,:,b) + j.*ReadBand(vFileNames{p},folderName,HEADER_NAME);
       p=p+1;
   else
       st.data(:,:,b)= ReadBand(vFileNames{p},folderName,HEADER_NAME);
       p=p+1;
   end
end
    



%% Format data
st.info.type = dataType;
st.info.vComplex= vComplex;

function data= ReadBand(sFileName,folderName,HEADER_NAME)

if isempty(HEADER_NAME)
    [num_samples,num_lines,nBands,nHeaderOffset,nDataType,sInterleave,nByteOrder]= ReadHeader([folderName sFileName]);
else
    [num_samples,num_lines,nBands,nHeaderOffset,nDataType,sInterleave,nByteOrder]= ReadHeader([HEADER_NAME]);
end
data= multibandread([folderName sFileName],[num_samples,num_lines,nBands],'float32',nHeaderOffset,sInterleave,'ieee-le');


