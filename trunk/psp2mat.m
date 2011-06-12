function [st]= psp2mat(dataType,folderName,sHeaderName)
% Synopsis:
%  [st]= psp2mat(dataType,folderName,sHeaderName)
% 
% Input:
% - dataType     defines the data type ('T3', 'C3', 'FREEMAN');
% - folderName   folder where to read the files (optional)
% - sHeaderName  fixed header file (optional)
%
% Output:
% - st    structure containing the data
%
% Description:
%  Read polsarpro files and returns the content in structure
%
% See also
%
% Revisions:
%   S. Foucher: initial version (2011/10/06)
%

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();

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
       try
       st.data(:,:,b)= ReadBand(vFileNames{p},folderName,HEADER_NAME);
       p=p+1;
       catch
           
       end
       
       try
       st.data(:,:,b)= st.data(:,:,b) + j.*ReadBand(vFileNames{p},folderName,HEADER_NAME);
       p=p+1;
       catch
           
       end
      
   else
       try
       st.data(:,:,b)= ReadBand(vFileNames{p},folderName,HEADER_NAME);
       p=p+1;
       catch
           
       end
      
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
data= multibandread([folderName sFileName],[num_lines,num_samples,nBands],'float32',nHeaderOffset,sInterleave,'ieee-le');


