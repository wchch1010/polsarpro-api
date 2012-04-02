function [stOut]= pspHAlphaLambdaPlanesClassifier(stIn,stHAAlpha)
% Synopsis:
%  [stOut]= pspHAlphaLambdaPlanesClassifier(stHAAlpha)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% 
% Output:
% - stOut     matrix with 3 channels (H_alpha, H_A, A_alpha)
%
% Description:
% 
%  
% Classification of a SAR image into regions from its
%  • alpha and entropy parameters --> 8 classes
%  • alpha and anisotropy parameters --> 6 classes
%  • anisotropy and entropy parameters --> 6 classes
% Class assignation based on linear boundaries in polar planes.
%
% Note: prior filtering is required
%
% See also
%
% Revisions:
%   S. Foucher: initial version (2011/11/06)
%
error(nargchk(2,2,nargin, 'struct'));
error(nargoutchk(0,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();

sColorMapPlanes27= [POLSARPRO_DIR '/ColorMap/Planes_H_Alpha_Lambda_ColorMap27.pal'];

options= parseInputs(stHAAlpha);
% POLSARPRO_API_OUT_DIR0= POLSARPRO_API_OUT_DIR;
% POLSARPRO_API_OUT_DIR= POLSARPRO_API_IN_DIR;
% stOut= pspHAAlphaDecomposition(stIn, 1); %-- H/A/alpha decomposition required first
% POLSARPRO_API_OUT_DIR= POLSARPRO_API_OUT_DIR0;
stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stHAAlpha);
stHeaderNames= mat2psp(stHAAlpha, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir
mat2psp(stHAAlpha);

[numRow, numCol, nBands] = size(stHAAlpha.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'H/A/Lambda Planes Classification in progress, please wait...');
%% Form command
% h_alpha_lambda_planes_classifier DirInput DirOutput OffsetRow OffsetCol
% FinalNrow FinalNcol ColorMapPlanes27

sCommand = sprintf('%s/Soft/data_process_sngl/h_alpha_lambda_planes_classifier.exe',POLSARPRO_DIR);
sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d "%s"',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,0,0,numRow,numCol,...
    sColorMapPlanes27);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspHAlphaLambdaPlanesClassifier:badData', ...
        result);
end
stOut= psp2mat('H_ALPHA_LAMBDA_CLASS',POLSARPRO_API_IN_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'H_ALPHA_LAMBDA_CLASS';
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspHAlphaLambdaPlanesClassifier';
else
    stOut.info.history{1}= 'pspHAlphaLambdaPlanesClassifier';
end
stOut.info.options= options;
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(stHAAlpha)

if ndims(stHAAlpha.data) > 3
  error('MATLAB:pspHAlphaLambdaPlanesClassifier:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(stHAAlpha.info,'type')
  error('MATLAB:pspHAlphaLambdaPlanesClassifier:badData', ...
        'DATA type missing.');
end
if ~strcmpi(stHAAlpha.info.type,'HAAlpha')
  error('MATLAB:pspHAlphaLambdaPlanesClassifier:badData', ...
        'DATA type missing.');
end
options= [];
