function [stOut]= pspPWFFilter(stIn, Nlook, NwinFilter)
% Synopsis:
%  [stOut]= pspPWFFilter(stIn,Nlook, sigma, NwinFilter, NwinTgt)
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
% polSARproCloudeDecomposition applies a Cloude decomposition over a
% coherency or covariance matrix. Apply a nwin x nwin boxcar filter then
% compute the first eigenvector/eigenvalue. Return the covariance/coherence
% matrix corresponsing to the largest eigenvector.
%  
% PolSARPro Description :  Cloude Decomposition of a coherency matrix
%
% See also
%
% Revisions:
%   
error(nargchk(3,3,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
parseInputs(stIn, Nlook, NwinFilter);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'PWF Filter in progress, please wait...');
%% Form command
% PWF_filter_T3 DirInput DirOutput Nlook Nwin OffsetRow OffsetCol FinalNrow
% FinalNcol
sCommand = sprintf('%s/Soft/speckle_filter/PWF_filter_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %f %f %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,Nlook,NwinFilter,0,0,numRow,numCol);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspPWFFilter:badData', ...
        result);
end
stOut= psp2mat(stIn.info.type);
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspPWFFilter';
else
    stOut.info.history{1}= 'pspPWFFilter';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, Nlook,NwinFilter)
if ~isnumeric(Nlook)
  error('MATLAB:pspPWFFilter:badData', ...
        'Nlook must be numeric.');
end
if ~isnumeric(NwinFilter)
  error('MATLAB:pspPWFFilter:badData', ...
        'NwinFilter must be numeric.');
end
if ndims(st.data) > 3
  error('MATLAB:pspPWFFilter:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspPWFFilter:badData', ...
        'DATA type missing.');
end


