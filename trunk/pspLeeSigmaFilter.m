function [stOut]= pspLeeSigmaFilter(stIn, Nlook, sigma, NwinFilter, NwinTgt)
% Synopsis:
%  [stOut]= pspLeeSigmaFilter(stIn,Nlook, sigma, NwinFilter, NwinTgt)
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
% Source: "Improved Sigma Filter for Speckle Filtering of SAR imagery"
% J.S. Lee, J.H Wen, T. Ainsworth, K.S Chen, A.J Chen
% IEEE GRS Letters - 2008
% See also
%
% Revisions:
%   
error(nargchk(5,5,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
parseInputs(stIn, Nlook, sigma, NwinFilter, NwinTgt);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'Sigma Filter in progress, please wait...');
%% Form command
% lee_sigma_filter_T3 in_dir out_dir Nlook sigma NwinFilter NwinTgt
% offset_lig offset_col sub_nlig sub_ncol
sCommand = sprintf('%s/Soft/speckle_filter/lee_sigma_filter_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %f %f %d %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,Nlook,sigma,NwinFilter,NwinTgt,0,0,numRow,numCol);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspLeeSigmaFilter:badData', ...
        result);
end
stOut= psp2mat(stIn.info.type);
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspLeeSigmaFilter';
else
    stOut.info.history{1}= 'pspLeeSigmaFilter';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, Nlook,sigma,NwinFilter,NwinTgt)
if ~isnumeric(Nlook)
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'Nlook must be numeric.');
end
if ~isnumeric(NwinFilter)
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'NwinFilter must be numeric.');
end
if ~isnumeric(NwinTgt)
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'NwinFilter must be numeric.');
end
if (NwinFilter <= 1)
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'NwinFilter greater than 1.');
end
if (NwinTgt <= 1)
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'NwinFilter greater than 1.');
end
if (sigma < 5 || sigma > 9)
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'sigma must be between 5 and 9 inclusive.');
end
if ndims(st.data) > 3
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspLeeSigmaFilter:badData', ...
        'DATA type missing.');
end


