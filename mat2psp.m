function mat2psp(inPolSAR, folderName, bWriteBin)
%% Synopsis:
%  mat2psp(inPolSAR, folderName)
% 
% Input:
% - inPolSAR     structure  .data  [n m 6] data -> [n m (X11,X12,X13,X22,X23,X33)]
%                           .info(.type,.history)
% or
% 
% - inPolSAR     structure  .data(.band1,...,.band6) (X11,X12,X13,X22,X23,X33)
%                           .info(.type,.history)
% - folderName  string  path directory of PolSARpro data output folder  
% 
% Output:
% 
% Description:
% mat2polSARpro convert a coherency or covariance matrix file .mat of 
% Matlab PolSARTools into the coherency matrix file .bin of PolSARPro.
% 

% Inputs  : In in_dir directory
% T11.bin, T12_real.bin, T12_imag.bin, T13_real.bin,
% T13_imag.bin, T22.bin, T23_real.bin, T23_imag.bin
% T33.bin
%
%
% Author: Samuel Foucher
% Created in 2011
%
%
global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();

try,
    dataType = inPolSAR.info.type;
catch,
    disp('The data has no type info, inPolSAR.info.type missing');
    return;
end
if ~exist('bWriteBin','var')
    bWriteBin= 1;
end
if ~exist('folderName','var')
    folderName= [POLSARPRO_API_IN_DIR];
end
if folderName(end) ~= '/'
    folderName= [folderName '/'];
end
vSize= size(inPolSAR.data);
num_samples= vSize(2);
num_lines= vSize(1);
num_bands= vSize(3);
%% Coherency case T3
if strcmpi(upper(dataType), 'T3')
    [vFileNames vComplex]= FileNames(dataType);
    
    config = strtrim([folderName 'config.txt']);
    p= 1;
    for b=1:num_bands
       if vComplex(b)
           WriteBand(real(inPolSAR.data(:,:,b)),vFileNames{p},folderName,bWriteBin);
           p=p+1;
           WriteBand(imag(inPolSAR.data(:,:,b)),vFileNames{p},folderName,bWriteBin);
           p=p+1;
       else
           WriteBand(real(inPolSAR.data(:,:,b)),vFileNames{p},folderName,bWriteBin);
           p=p+1;
       end
    end
   
    % Write the config.txt
    WriteConfigFile(config,num_lines,num_samples);
    
    %msgbox('Done.','Convert *.mat to *.bin PolSARpro');
end



function WriteConfigFile(config,num_lines,num_samples)
    fid=fopen(config, 'w+');
    fprintf(fid, 'Nrow\n');
    fprintf(fid, '%d\n',num_lines);
    fprintf(fid, '---------\n');
    fprintf(fid, 'Ncol\n');
    fprintf(fid, '%d\n',num_samples);
    fprintf(fid, '---------\n');
    fprintf(fid, 'PolarCase\n');
    fprintf(fid, 'monostatic\n');
    fprintf(fid, '---------\n');
    fprintf(fid, 'PolarType\n');
    fprintf(fid, 'full\n');
    fclose(fid);
    
function success= WriteBand(data,sFileName,folderName,bWriteBin)
num_samples= size(data,2);
num_lines= size(data,1);
success= WriteHeader(num_samples,num_lines,1,[folderName sFileName]);
if ~success
    return;
end
sucess= 1;
if ~bWriteBin
    return;
end
multibandwrite(data, [folderName sFileName],'bsq','PRECISION','float32', 'machfmt','ieee-le');

