function [stOut] = pspIDAN(stIn, MaxRegionSize, Nlook, FilteringAmount, offsetRow, offsetCol, numRow, numCol)
    
%% Synopsis:
% Intensity Driven Adaptive Neighbourhood (IDAN) polarimetric speckle
% filter
%  [stOut]= pspIDAN(stIn,MaxregionSize, nlook, FilteringAmount, offsetRow, offsetCol, numRow, numCol)
% 
% Input:
% - stIn     structure  .data  [n m 6] data -> [n m (X11,X12,X13,X22,X23,X33)]
%                          .info(.type,.history)
% or
% 
% - data_in     structure  .data(.band1,...,.band6) (X11,X12,X13,X22,X23,X33)
%                          .info(.type,.history)
% - nlook       double  number of looks
% - MaxRegionSize int  Maximum size of the adaptive window for
% computing local estimates. 
% - FilteringAmount bool Amount of filtering low=0 / high=1.
% - offsetRow   double  offset row wise
% - offsetCol   double  offset column wise
% - numRow      double  number of rows required
% - numCol      double  number of columns required
%
% Output:
% - stOut  structure  .data(.band1,...,.band6) (X11,X12,X13,X22,X23,X33)
%                        .info(.name, .type)
%   or  
% - stOut  matrix     [n m 6] data -> [n m (X11,X12,X13,X22,X23,X33)]
% 
% Description:
% polSARproRefinedLee applies a refined Lee filtering over a PolSAR
% matrix. The function used is a PolSARPro function.
% 

% Inputs  : In in_dir directory
% T11.bin, T12_real.bin, T12_imag.bin, T13_real.bin,
% T13_imag.bin, T22.bin, T23_real.bin, T23_imag.bin
% T33.bin
%
% Outputs : In out_dir directory
% config.txt
% T11.bin, T12_real.bin, T12_imag.bin, T13_real.bin,
% T13_imag.bin, T22.bin, T23_real.bin, T23_imag.bin
% T33.bin%
%
% Author: Sovattara Hell, Gregory Farage, Samuel Foucher - Vision team, Dept. of R&D, CRIM
% Created in 2008
%
error(nargchk(4,4,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
parseInputs(stIn, MaxRegionSize, Nlook, FilteringAmount);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir
sType= stIn.info.type;
switch(upper(sType))
    case 'CP_C2'
        sType= 'C2';
    case 'CP_ST'
        sType= 'C3';
end
[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'IDAN Filter in progress, please wait...');
%% Form command
% lee_sigma_filter_T3 in_dir out_dir Nlook sigma NwinFilter NwinTgt
% offset_lig offset_col sub_nlig sub_ncol
sCommand = sprintf('%s/Soft/speckle_filter/idan_filter_%s.exe',POLSARPRO_DIR,upper(sType));
params= strcat(' ');
sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d %d %d %f %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,numRow, numCol, offsetRow, offsetCol, numRow, numCol, MaxRegionSize, Nlook, FilteringAmount);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspIDAN:badData', ...
        result);
end
stOut= psp2mat(stIn.info.type);
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspIDAN';
else
    stOut.info.history{1}= 'pspIDAN';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, NwinFilter, Nlook, FilteringAmount)
if ~isnumeric(Nlook)
  error('MATLAB:pspIDAN:badData', ...
        'Nlook must be numeric.');
end
if ~isnumeric(NwinFilter)
  error('MATLAB:pspIDAN:badData', ...
        'NwinFilter must be numeric.');
end
if ~isnumeric(FilteringAmount)
  error('MATLAB:pspIDAN:badData', ...
        'FilteringAmount must be numeric.');
end
if FilteringAmount ~= 0 & FilteringAmount ~= 1
  error('MATLAB:pspIDAN:badData', ...
        'FilteringAmount must 0 or 1.');
end
if ndims(st.data) > 3
  error('MATLAB:pspIDAN:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspIDAN:badData', ...
        'DATA type missing.');
end


