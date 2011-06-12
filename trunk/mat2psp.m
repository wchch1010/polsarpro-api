function stHeaderName= mat2psp(inPolSAR, folderName, bWriteBin)
% Synopsis:
%  stHeaderName= mat2psp(inPolSAR, folderName, bWriteBin)
%
% Input:
% - inPolSAR     data to be written
% - folderName   folder where to write the files (optional)
% - bWriteBin    flag to write the bin files (optional, default at true)
%
% Output:
% - stHeaderName   names of the header files
%
% Description:
%  Write the matlab data in polsarpro format
%
% See also:
%   psp2mat
% Revisions:
%   S. Foucher: initial version (2011/10/06)
%

error(nargchk(1,3,nargin, 'struct'));
error(nargoutchk(0,1,nargout, 'struct'));
global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();

try,
    dataType = inPolSAR.info.type;
catch,
    error('MATLAB:mat2psp:badData', ...
        'Unknown data format, field info.type missing.');
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

[vFileNames vComplex]= FileNames(dataType);

config = strtrim([folderName 'config.txt']);
p= 1;
for b=1:num_bands
    if vComplex(b)
        WriteBand(real(inPolSAR.data(:,:,b)),vFileNames{p},folderName,bWriteBin);
        stHeaderName{p}= [ vFileNames{p} '.hdr'];
        p=p+1;
        WriteBand(imag(inPolSAR.data(:,:,b)),vFileNames{p},folderName,bWriteBin);
        stHeaderName{p}= [ vFileNames{p} '.hdr'];
        p=p+1;
        
    else
        WriteBand(real(inPolSAR.data(:,:,b)),vFileNames{p},folderName,bWriteBin);
        stHeaderName{p}= [ vFileNames{p} '.hdr'];
        p=p+1;
        
    end
end

% Write the config.txt
WriteConfigFile(config,num_lines,num_samples);

%msgbox('Done.','Convert *.mat to *.bin PolSARpro');




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

