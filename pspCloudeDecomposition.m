function [stOut]= pspCloudeDecomposition(stIn, nwin, varargin)
% Synopsis:
%  [stOut]= polSARproCloudeDecomposition(data_in,nwin, dataType, offsetRow, offsetCol, numRow, numCol)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - nwin     int  size of the averaging window
% 
% Output:
% - dPolSAR     matrix    
%
% Description:
% polSARproCloudeDecomposition applies a Cloude decomposition over a
% coherency or covariance matrix. Apply a nwin x nwin boxcar filter then
% compute the first eigenvector/eigenvalue. Return the covariance/coherence
% matrix corresponsing to the largest eigenvector.
%  
% PolSARPro Description :  Lee refined polarimetric speckle filter moving
% window with detection of heterogeneities (directional masks)
%
% See also
%
%
error(nargchk(2,2,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
parseInputs(stIn, nwin);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'Cloude Decomposition in progress, please wait...');
%% Form command
sCommand = sprintf('%s/Soft/data_process_sngl/cloude_decomposition_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,nwin,offsetRow,offsetCol,numRow,numCol);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
stOut= psp2mat(stIn.info.type);
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspCloudeDecomposition';
else
    stOut.info.history{1}= 'pspCloudeDecomposition';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, win)

if ~isnumeric(win)
  error('MATLAB:multibandwrite:badData', ...
        'win must be numeric.');
end
if (win <= 1)
  error('MATLAB:multibandwrite:badData', ...
        'win greater than 1.');
end
if ndims(st.data) > 3
  error('MATLAB:multibandwrite:badData', ...
        'DATA must have no more than three dimensions.');
end



