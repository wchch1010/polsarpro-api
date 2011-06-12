function [stOut]= pspFreemanDecomposition(stIn, NwinFilter)
% Synopsis:
%  [stOut]= pspFreemanDecomposition(stIn,Nlook, sigma, NwinFilter, NwinTgt)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - nwin     int  size of the averaging window
% 
% Output:
% - stOut     matrix (same size as stIn)
%
% Description:
% 
%  
% PolSARPro Description : Apply the Freeman Decomposition on a (3x3) complex Coherency [T3] matrix.
% (A three-component scattering model for polarimetric SAR data, Freeman, A.; Durden, S.L., IEEE TGRS, Volume 36, Issue 3, May 1998 Page(s):963 - 973)
%
% See also
%
% Revisions:
%   
error(nargchk(1,2,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
if ~exist('NwinFilter')
    NwinFilter= 1;
end
parseInputs(stIn, NwinFilter);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
stHeaderNames= mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'PWF Filter in progress, please wait...');
%% Form command
% freeman_decomposition_T3 DirInput DirOutput Nwin OffsetRow OffsetCol
% FinalNrow FinalNcol
sCommand = sprintf('%s/Soft/data_process_sngl/freeman_decomposition_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %f %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,NwinFilter,0,0,numRow,numCol);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspFreemanDecomposition:badData', ...
        result);
end
stOut= psp2mat('Freeman',POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'FREEMAN';
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspFreemanDecomposition';
else
    stOut.info.history{1}= 'pspFreemanDecomposition';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, NwinFilter)

if ~isnumeric(NwinFilter)
  error('MATLAB:pspFreemanDecomposition:badData', ...
        'NwinFilter must be numeric.');
end
if ndims(st.data) > 3
  error('MATLAB:pspFreemanDecomposition:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspFreemanDecomposition:badData', ...
        'DATA type missing.');
end


