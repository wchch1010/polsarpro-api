function EnterPolSARProInfo()
% Synopsis:
%  EnterPolSARProInfo()
% 
% Description:
% EnterPolSARProInfo create the input, output folders, and generate a 
% text file path.txt including the path of these foders as well as the path
% of the polSARpro directory. 
%
%
% Author: Samuel Foucher
%

%% Create a directory for PolSARpro data
sPSP_Path = uigetdir('C:\','Browse for the PolSARpro root folder. Example: C:\PolSARpro_v3.0');
c= filesep;
k = strfind(sPSP_Path,c);
sPSP_Path(k)= '/';

%mkdir(strtrim([sPSP_Path '/in']));
%mkdir(strtrim([sPSP_Path '/out']));

inputDir = [sPSP_Path '/in'];
outputDir = [sPSP_Path '/out'];

FID = fopen('path.txt', 'w+','n','US-ASCII');
fprintf(FID, '%s\n',sPSP_Path);
fprintf(FID, '%s\n',inputDir);
fprintf(FID, '%s\n',outputDir);
fclose(FID);
global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
if ~exist('POLSARPRO_API_OUT_DIR','var') || isempty(POLSARPRO_API_OUT_DIR),
    POLSARPRO_DIR= sPSP_Path;
    POLSARPRO_API_OUT_DIR= outputDir;
    POLSARPRO_API_IN_DIR= inputDir;
else
    POLSARPRO_DIR= sPSP_Path;
    POLSARPRO_API_IN_DIR= inputDir;
    POLSARPRO_API_OUT_DIR= outputDir;
end