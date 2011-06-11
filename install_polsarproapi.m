% install_polsarproapi.M install the package
% add the following locations to Matlab's path:
% <PSPAPI_BASEDIR>
%
% where <PSPAPI_BASEDIR> is the directory containing install_emd.m
%
% and compiles the C codes
%
% IMPORTANT: After running install_polsarproapi you must run the "savepath" command to save the installation
% but be careful that if you previously removed parts of the path (using e.g. the "rmpath" command) 
% these will be permanently removed after you run "savepath"

function install_polsarproapi

base_dir = fileparts(which('install_polsarproapi'));
disp(['Base dir:' base_dir])
addpath(base_dir)
cd(base_dir);
EnterPolSARProInfo();
disp('Installation complete. Run index_pspapi for a list of functions.')
fprintf('\n')
disp('IMPORTANT: After running install_polsarproapi you must run the "savepath" command to save the installation')
disp('but be careful that if you previously removed parts of the path (using e.g. the "rmpath" command)')
disp('these will be permanently removed after you run "savepath"')
