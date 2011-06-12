function [stOut]= pspCreatePauliRGBFile(stIn)
% Synopsis:
%  [stOut]= pspCreatePauliRGBFile(stIn)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% 
% Output:
% - stOut     RGB matrix (uint8)
%
% Description:
% Creation of the Pauli RGB BMP file from 3 binary files, with:
% • Blue = 10log(T11)
% • Green = 10log(T33)
% • Red = 10log(T22)
%  
% PolSARPro Description : 
%
% See also
%
% Revisions:
%   S. Foucher: initial version (2011/10/06)
%
error(nargchk(1,1,nargin, 'struct'));
error(nargoutchk(1,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
parseInputs(stIn);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'Creation of the Pauli RGB, please wait...');
%% Form command
% create_pauli_rgb_file_T3 RGBDirInput FileOutput Ncol OffsetRow OffsetCol
% FinalNrow FinalNcol
sCommand = sprintf('%s/Soft/bmp_process/create_pauli_rgb_file_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s/out.bmp" %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,numCol,0,0,numRow,numCol);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspCreatePauliRGBFile:badData', ...
        result);
end
stOut= imread([POLSARPRO_API_OUT_DIR '/out.bmp']);

waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st)

if ndims(st.data) > 3
  error('MATLAB:pspCreatePauliRGBFile:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspCreatePauliRGBFile:badData', ...
        'DATA type missing.');
end


