function [stOut]= pspHAAlphaDecomposition(stIn, NwinFilter)
% Synopsis:
%  [stOut]= pspHAAlphaDecomposition(stIn,NwinFilter)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - nwin     int  size of the averaging window
% 
% Output:
% - stOut     matrix with three channels (H, A and alpha)
%
% Description:
% 
%  
% PolSARPro Description : Cloude-Pottier eigenvector/eigenvalue based
% decomposition of a 3x3 coherency matrix [T3] (Averaging using a sliding window)
%
% See also
%
% Revisions:
%   
error(nargchk(2,2,nargin, 'struct'));
error(nargoutchk(0,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
alpbetdelgam= 0
lambda= 0;
alpha= 1;
entropy= 1;
anisotropy= 1;
CombHA= 0;
CombH1mA= 0;
Comb1mHA= 0;
Comb1mH1mA= 0;
parseInputs(stIn, NwinFilter);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
stHeaderNames= mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'H/A/Alpha decomposition in progress, please wait...');
%% Form command
% h_a_alpha_decomposition_T3 DirInput DirOutput Nwin OffsetRow OffsetCol
% FinalNrow FinalNcol alpbetdelgam lambda alpha entropy anisotropy CombHA
% CombH1mA Comb1mHA Comb1mH1mA
sCommand = sprintf('%s/Soft/data_process_sngl/h_a_alpha_decomposition_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %f %d %d %d %d %d %d %d %d %d %d %d %d %d',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,NwinFilter,0,0,numRow,numCol,alpbetdelgam,lambda,alpha,entropy,anisotropy,CombHA,CombH1mA,Comb1mHA,Comb1mH1mA);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspHAAlphaDecomposition:badData', ...
        result);
end
stOut= psp2mat('HAAlpha',POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'HAALPHA';
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspHAAlphaDecomposition';
else
    stOut.info.history{1}= 'pspHAAlphaDecomposition';
end
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, NwinFilter)

if ~isnumeric(NwinFilter)
  error('MATLAB:pspHAAlphaDecomposition:badData', ...
        'NwinFilter must be numeric.');
end
if ndims(st.data) > 3
  error('MATLAB:pspHAAlphaDecomposition:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspHAAlphaDecomposition:badData', ...
        'DATA type missing.');
end


