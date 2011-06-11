function [stOut]= pspYamaguchiDecomposition(stIn, nc)
% Synopsis:
%  [stOut]= pspYamaguchiDecomposition(stIn,Nlook, nc)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - nc       number of components (3 or 4)
% 
% Output:
% - stOut     matrix (3 or 4 bands)
%
% Description:
%  
% Apply the Freeman 3 Components Decomposition, improved by Y. Yamaguchi, on a (3x3) complex Coherency [T3] matrix. The improvements concern:
% • Choice of the Volume Scattering coefficient according to the ratio VV/HH
% • Alpha and Beta parameters are complex
% (A three-component scattering model for polarimetric SAR data, Freeman, A.; Durden, S.L., IEEE TGRS, Volume 36, Issue 3, May 1998 Page(s):963 - 973)
% (Four-component scattering model for polarimetric SAR image decomposition, Yamaguchi, Y.; Moriyama, T.; Ishido, M.; Yamada, H, IEEE TGRS, Volume 43, Issue 8, Aug. 2005 Page(s):1699 - 1706)
% (A four-component decomposition of POLSAR images based on the coherency matrix, Yamaguchi, Y.; Yajima, Y.; Yamada, H, IEEE GRSL, Volume 3, Issue 3, July 2006 Page(s):292 - 296)
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
options= parseInputs(stIn, nc);

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
if options.nc == 3
    sCommand = sprintf('%s/Soft/data_process_sngl/yamaguchi_3components_decomposition_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
    sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,1,0,0,numRow,numCol);
else
    sCommand = sprintf('%s/Soft/data_process_sngl/yamaguchi_4components_decomposition_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
    sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,1,0,0,numRow,numCol);
end
waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspYamaguchiDecomposition:badData', ...
        result);
end
if options.nc == 3
stOut= psp2mat('YAMAGUCHI3',POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'YAMAGUCHI3';
else
stOut= psp2mat('YAMAGUCHI4',POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'YAMAGUCHI4';    
end
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspYamaguchiDecomposition';
else
    stOut.info.history{1}= 'pspYamaguchiDecomposition';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, nc)

if ~isnumeric(nc)
  error('MATLAB:pspYamaguchiDecomposition:badData', ...
        'NwinFilter must be numeric.');
end
if (nc < 3)
  error('MATLAB:pspYamaguchiDecomposition:badData', ...
        'At least 3 components.');
end
if (nc > 4)
    nc= 4;
end
if ndims(st.data) > 3
  error('MATLAB:pspYamaguchiDecomposition:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspYamaguchiDecomposition:badData', ...
        'DATA type missing.');
end
options.nc= nc;

