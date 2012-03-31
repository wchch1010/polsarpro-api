function [stOut]= pspHAAlphaPlanesClassifier(stIn)
% Synopsis:
%  [stOut]= pspHAAlphaPlanesClassifier(stIn)
%
% Input:
% - stIn     structure  .data
%                       .info(.name, .type)
%
% Output:
% - stOut     matrix with 3 channels containing 3 classification results (H_alpha, H_A, A_alpha)
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
error(nargchk(1,1,nargin, 'struct'));
error(nargoutchk(0,1,nargout, 'struct'));

global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
SetPSPDir();
disp('Starting pspHAAlphaPlanesClassifier');tic;
sColorMapPlanes9= [POLSARPRO_DIR '/ColorMap/Planes_H_A_Alpha_ColorMap9.pal'];

options= parseInputs(stIn);

stOut= [];
% Convert matlab data to polSARpro data
mat2psp(stIn);
stHeaderNames= mat2psp(stIn, POLSARPRO_API_OUT_DIR, 0); % necessary in order to create header in the OUT dir

[numRow, numCol, nBands] = size(stIn.data);
offsetRow = 0;
offsetCol = 0;

h = waitbar(0,'H/A/Alpha Wishart Classification in progress, please wait...');
%% Form command
%h_a_alpha_planes_classifier DirInput DirOutput OffsetRow OffsetCol
%FinalNrow FinalNcol flag_H_alpha flag_A_alpha flag_H_A ColorMapPlanes9
for n=1:3
    v= zeros(1,3);
    v(n)=1;
    sCommand = sprintf('%s/Soft/data_process_sngl/h_a_alpha_planes_classifier.exe',POLSARPRO_DIR);
    sCommand= sprintf('"%s" "%s" "%s" %d %d %d %d %d %d %d "%s"',sCommand,POLSARPRO_API_IN_DIR,POLSARPRO_API_OUT_DIR,0,0,numRow,numCol,...
        v(1), v(2), v(3), sColorMapPlanes9);
    
    waitbar(0.3*n);
    
    %% Launch the executable command
    [status,result]= system(sCommand);
    vProgress= str2num(result);
   if n==1
       try
       info = imfinfo([POLSARPRO_API_OUT_DIR '/H_alpha_class.bmp']);
    I1= imread([POLSARPRO_API_OUT_DIR '/H_alpha_class.bmp'],'BMP');
    figure('Name','H/alpha Plane','color','w');subplot(311);imshow(I1);colormap(info.Colormap);
    info = imfinfo([POLSARPRO_API_OUT_DIR '/H_alpha_class.bmp']);

    I2= imread([POLSARPRO_API_OUT_DIR '/H_alpha_occurence_plane.bmp']);
    subplot(312);imshow(I2);colormap(info.Colormap);
    info = imfinfo([POLSARPRO_API_OUT_DIR '/H_alpha_segmented_plane.bmp']);
    I3= imread([POLSARPRO_API_OUT_DIR '/H_alpha_segmented_plane.bmp']);
    subplot(313);imshow(I3);colormap(info.Colormap);
       catch
           disp('Could not read bmp');
       end
   end
   if n==2
       try
       info = imfinfo([POLSARPRO_API_OUT_DIR '/A_alpha_class.bmp']);
    I1= imread([POLSARPRO_API_OUT_DIR '/A_alpha_class.bmp'],'BMP');
    figure('Name','A/alpha Plane','color','w');subplot(311);imshow(I1);colormap(info.Colormap);
    info = imfinfo([POLSARPRO_API_OUT_DIR '/A_alpha_class.bmp']);

    I2= imread([POLSARPRO_API_OUT_DIR '/A_alpha_occurence_plane.bmp']);
    subplot(312);imshow(I2);colormap(info.Colormap);
    info = imfinfo([POLSARPRO_API_OUT_DIR '/A_alpha_segmented_plane.bmp']);
    I3= imread([POLSARPRO_API_OUT_DIR '/A_alpha_segmented_plane.bmp']);
    subplot(313);imshow(I3);colormap(info.Colormap);
       catch
           disp('Could not read bmp');
       end
   end
   if n==3
       try
       info = imfinfo([POLSARPRO_API_OUT_DIR '/H_A_class.bmp']);
    I1= imread([POLSARPRO_API_OUT_DIR '/H_A_class.bmp'],'BMP');
    figure('Name','H_A Plane','color','w');subplot(311);imshow(I1);colormap(info.Colormap);
    info = imfinfo([POLSARPRO_API_OUT_DIR '/H_A_class.bmp']);

    I2= imread([POLSARPRO_API_OUT_DIR '/H_A_occurence_plane.bmp']);
    subplot(312);imshow(I2);colormap(info.Colormap);
    info = imfinfo([POLSARPRO_API_OUT_DIR '/H_A_segmented_plane.bmp']);
    I3= imread([POLSARPRO_API_OUT_DIR '/H_A_segmented_plane.bmp']);
    subplot(313);imshow(I3);colormap(info.Colormap);
       catch
           disp('Could not read bmp');
       end
   end
    if isempty(vProgress)
        error('MATLAB:pspHAAlphaPlanesClassifier:badData', ...
            result);
    end
end
stOut= psp2mat('PLANES_HAALPHA',POLSARPRO_API_IN_DIR,[POLSARPRO_API_IN_DIR '/' stHeaderNames{1}]);
stOut.info.type= 'PLANES_HAALPHA';
if isfield(stIn.info,'history')
    stOut.info.history= stIn.info.history;
    stOut.info.history{end+1}= 'pspHAAlphaPlanesClassifier';
else
    stOut.info.history{1}= 'pspHAAlphaPlanesClassifier';
end
stOut.info.options= options;
waitbar(1);
close(h)
disp(toc);
%=============================================================
function options = parseInputs(st)

if ndims(st.data) > 3
    error('MATLAB:pspHAAlphaPlanesClassifier:badData', ...
        'DATA must have no more than three dimensions.');
end
if ~isfield(st.info,'type')
    error('MATLAB:pspHAAlphaPlanesClassifier:badData', ...
        'DATA type missing.');
end
if ~strcmpi(st.info.type,'HAALPHA')
    error('MATLAB:pspHAAlphaPlanesClassifier:badData', ...
        'DATA type must be HAALPHA, run pspHAAlphaDecomposition first.');
end

options=[];