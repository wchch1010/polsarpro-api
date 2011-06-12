function [stOut]= pspWishartHAAlphaClassifier(stIn, stHAAlpha, pct_min,nb_it_max,Bmp_flag)
% Synopsis:
%  [stOut]= pspWishartHAAlphaClassifier(stIn, stHAAlpha, pct_min,nb_it_max,Bmp_flag)
% 
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
% - stHAAlpha  structure containing H/A/Alpha data
%
% Output:
% - stOut     matrix with 2 channels (8 and 16 classe classification, wishart_H_A_alpha_class and wishart_H_alpha_class)
%
% Description:
% 
% PolSARPro Description : Unsupervised maximum likelihood classification of a polarimetric image from the Wishart PDF of its coherency matrices. Two classsifcation are avaliable :
% • Initialisation using the H and alpha parameters -> 8 classes
% • Same classification followed by another initialisation using the anisotropy A -> 16 classes
%
% Note: prior filtering is required and the computation of H/A/alpha
% decomposition (see pspHAAlphaDecomposition)
%
% See also
%
% Revisions:
%   S. Foucher: initial version (2011/11/06)
%
error(nargchk(2,5,nargin, 'struct'));
error(nargoutchk(0,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
if ~exist('NwinFilter')
    NwinFilter= 1;
end
if ~exist('pct_min')
    pct_min= 0.1;
end
if ~exist('nb_it_max')
    nb_it_max= 10;
end 
if ~exist('Bmp_flag')
    Bmp_flag= 0; %-- value 1 does not work
end
sColorMapWishart8= [POLSARPRO_DIR '/ColorMap/ColorMapWishart8.pal'];
sColorMapWishart16= [POLSARPRO_DIR '/ColorMap/ColorMapWishart16.pal'];
options= parseInputs(stIn, stHAAlpha, NwinFilter, pct_min, nb_it_max, Bmp_flag);
%stOut= pspHAAlphaDecomposition(stIn, 1); %-- H/A/alpha decomposition required first
stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
stHeaderNames= mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir
mat2psp(stHAAlpha);

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'H/A/Alpha Wishart Classification in progress, please wait...');
%% Form command
%wishart_h_a_alpha_classifier_T3 DirInput DirOutput Nwin OffsetRow
%OffsetCol FinalNrow FinalNcol pct_min nb_it_max Bmp_flag ColorMapWishart8 ColorMapWishart16
sCommand = sprintf('%s/Soft/data_process_sngl/wishart_h_a_alpha_classifier_%s.exe',POLSARPRO_DIR,upper(stIn.info.type));
sCommand= sprintf('"%s" "%s" "%s" %f %d %d %d %d %f %f %d "%s" "%s" "%s" "%s" "%s"',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,1,0,0,numRow,numCol,...
    options.pct_min,options.nb_it_max,options.Bmp_flag,sColorMapWishart8,sColorMapWishart16,[POLSARPRO_API_IN_DIR '/entropy.bin'],[POLSARPRO_API_IN_DIR '/anisotropy.bin'],[POLSARPRO_API_IN_DIR '/alpha.bin']);

waitbar(0.3);

%% Launch the executable command 
[status,result]= system(sCommand);
vProgress= str2num(result);
if isempty(vProgress)
    error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        result);
end
stOut= psp2mat('WISHART_HAALPHA',POLSARPRO_API_OUT_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'WISHART_HAALPHA';
if Bmp_flag
    
end
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspWishartHAAlphaClassifier';
else
    stOut.info.history{1}= 'pspWishartHAAlphaClassifier';
end
stOut.info.options= options;
waitbar(1);
close(h)

%=============================================================
function options = parseInputs(st, stHAAlpha, NwinFilter, pct_min, nb_it_max, Bmp_flag)

if ~isnumeric(NwinFilter)
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'NwinFilter must be numeric.');
end
if ndims(st.data) > 3
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'DATA type missing.');
end
if ~isfield(stHAAlpha.info,'type')
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'DATA type missing.');
end
if ~strcmpi(stHAAlpha.info.type,'HAALPHA')
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'Input argument 2 must be of HAALPHA type.');
end
if ~isnumeric(pct_min)
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'pct_min must be numeric.');
end
if pct_min > 1.0
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'pct_min must be lower than 1.');
end
if ~isnumeric(nb_it_max)
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'nb_it_max must be numeric.');
end
nb_it_max= floor(nb_it_max);
if nb_it_max <= 0
  error('MATLAB:pspWishartHAAlphaClassifier:badData', ...
        'nb_it_max must be greater than one.');
end
Bmp_flag= (Bmp_flag>0);
options.NwinFilter= NwinFilter;
options.pct_min= pct_min;
options.nb_it_max= nb_it_max;
options.Bmp_flag= Bmp_flag;