function [stOut]= pspDataConversion(stIn,sOutputDataFormat,vROI,bSymmetrisation,nSubSamplingCol,nSubSamplingRow)
% Synopsis:
%  [stOut]= pspDataConversion(stIn)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - sOutputDataFormat: 'C3', 'T3'
%
% Output:
% - stOut    same structure with converted format
%
% Description:
%  
% PolSARPro Description : 
%   Convert a Coherency or Covariance matrix Raw Binary Data Files
%
% Exemple:
%   stOut= pspDataConversion(stIn,'C3');
% See also
%   
% TODO
%   does not support the ROI or subsampling for now.
%
% Revisions:
%   S. Foucher: initial version (2011/10/06)
%
error(nargchk(2,6,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));
global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
if ~exist('bSymmetrisation')
    bSymmetrisation= 1;
end
if ~exist('sOutputDataFormat')
    sOutputDataFormat= 'T3';
end
if ~exist('nSubSamplingCol')
    nSubSamplingCol= 1;
end
if ~exist('nSubSamplingRow')
    nSubSamplingRow= 1;
end


options= parseInputs(stIn,bSymmetrisation,sOutputDataFormat,nSubSamplingCol,nSubSamplingRow);

stOut= [];
% Convert matlab data to polSARpro data
stHeaderNames= mat2psp(stIn);

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;
if ~exist('vROI')
    vROI= [0 0 numRow numCol];
end

h = waitbar(0,'Data conversion, please wait...');
%% Form command
% data_convert_T3 DirInput DirOutput Ncol OffsetRow OffsetCol FinalNrow
% FinalNcol Symmetrisation (0/1) OutputDataFormat (C3, T3) SubSamplingCol SubSamplingRow
sCommand = sprintf('%s/Soft/data_convert/data_convert_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d %d "%s" %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,numCol,vROI(1),vROI(2),vROI(3),vROI(4),...
    options.bSymmetrisation, options.sOutputDataFormat,options.nSubSamplingCol,options.nSubSamplingRow);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    close(h);
    error('MATLAB:pspDataConversion:badData', ...
        result);
end
%success= WriteHeader(num_samples,num_lines,nBands,[POLSARPRO_API_OUT_DIR '/' stHeaderNames{1}],nDataType,sInterleave,nByteOrder)
stOut= psp2mat(options.sOutputDataFormat,POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= options.sOutputDataFormat;
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspDataConversion';
else
    stOut.info.history{1}= 'pspDataConversion';
end
waitbar(1);
close(h);

%=============================================================
function options = parseInputs(st,bSymmetrisation,sOutputDataFormat,nSubSamplingCol,nSubSamplingRow)

if ndims(st.data) > 3
  error('MATLAB:pspDataConversion:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspDataConversion:badData', ...
        'DATA type missing.');
end
bSymmetrisation= (bSymmetrisation > 0);
if ~ischar(sOutputDataFormat)
  error('MATLAB:pspDataConversion:badData', ...
        'OutputDataFormat must be char.');
end
if strcmpi(st.info.type,'T3') || strcmpi(st.info.type,'C3')
    if ~strcmpi(sOutputDataFormat,'T3') & ~strcmpi(sOutputDataFormat,'C3')
        error('MATLAB:pspDataConversion:badData', ...
        'Conversion toward T3 or C3 only.');
    end
elseif strcmpi(st.info.type,'T4') || strcmpi(st.info.type,'C4')
    if ~strcmpi(sOutputDataFormat,'T3') & ~strcmpi(sOutputDataFormat,'C3')  & ~strcmpi(sOutputDataFormat,'C4')  & ~strcmpi(sOutputDataFormat,'T4')
        error('MATLAB:pspDataConversion:badData', ...
        'Conversion toward T3, T4, C4 or C3 only.');
    end
else
    error('MATLAB:pspDataConversion:badData', ...
        sprintf('Conversion not supported (%s to %s).',st.info.type,sOutputDataFormat));
end
options.sOutputDataFormat= sOutputDataFormat;
options.bSymmetrisation= bSymmetrisation;
options.nSubSamplingCol= nSubSamplingCol;
options.nSubSamplingRow= nSubSamplingRow;
