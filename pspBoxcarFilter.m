function [stOut]= pspBoxcarFilter(stIn,Nwin,Nlook)
% Synopsis:
%  [stOut]= pspBoxcarFilter(stIn)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - Nwin: window size (odd number)
%
% Output:
% - stOut    result of the boxcar filter
%
% Description:
%  
% PolSARPro Description : 
%   BoxCar polarimetric speckle filter
%
% Exemple:
%   stOut= pspBoxcarFilter(stIn,3);
%
% See also
%   
% TODO
%
% Revisions:
%   S. Foucher: initial version (2011/10/06)
%
error(nargchk(2,3,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));
global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
if ~exist('Nlook')
    Nlook= 1;
end

options= parseInputs(stIn,Nwin,Nlook);

stOut= [];
% Convert matlab data to polSARpro data
stHeaderNames= mat2psp(stIn);

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;
if ~exist('vROI')
    vROI= [0 0 numRow numCol];
end

h = waitbar(0,'Boxcar filter, please wait...');
%% Form command
% boxcar_filter_T3 DirInput DirOutput Nlook Nwin OffsetRow OffsetCol
% FinalNrow FinalNcol
sCommand = sprintf('%s/Soft/speckle_filter/boxcar_filter_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,options.Nlook,options.Nwin,...
    0, 0, numRow,numCol);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    close(h);
    error('MATLAB:pspBoxcarFilter:badData', ...
        result);
end
%success= WriteHeader(num_samples,num_lines,nBands,[POLSARPRO_API_OUT_DIR '/' stHeaderNames{1}],nDataType,sInterleave,nByteOrder)
stOut= psp2mat(stIn.info.type,POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);

if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspBoxcarFilter';
else
    stOut.info.history{1}= 'pspBoxcarFilter';
end
waitbar(1);
close(h);

%=============================================================
function options = parseInputs(st,Nwin,Nlook)

if ndims(st.data) > 3
  error('MATLAB:pspBoxcarFilter:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspBoxcarFilter:badData', ...
        'DATA type missing.');
end
if ~mod(Nwin,2) || Nwin < 1 || ~isnumeric(Nwin)
    error('MATLAB:pspBoxcarFilter:badData', ...
        'Nwin must be an odd number.');
end
options.Nwin= Nwin;
options.Nlook= Nlook;

