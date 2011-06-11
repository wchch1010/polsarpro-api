function [vFileNames, vComplex]= FileNames(dataType)
% Synopsis:
%  [vFileNames, vComplex]= FileNames(dataType)
% 
% Input:
% - dataType     defines the data type ('T3', 'C3', 'FREEMAN');
% 
% Output:
% - vFileNames     list of filenames
% - vComplex       data type (complex or real)
%
% Description:
%  Return the list of file names used by PolSARPro for each data type
%
% See also
%
% Revisions:
%   S. Foucher: initial version (2011/10/06)
%
vFileNames= {};
switch(upper(dataType))
    case 'T3'
        vComplex=[0 1 1 0 1 0];
        vFileNames{1} = 'T11.bin';
        vFileNames{2} = 'T12_real.bin';
        vFileNames{3} = 'T12_imag.bin';
        vFileNames{4} = 'T13_real.bin';
        vFileNames{5} = 'T13_imag.bin';
        vFileNames{6} = 'T22.bin';
        vFileNames{7} = 'T23_real.bin';
        vFileNames{8} = 'T23_imag.bin';
        vFileNames{9} = 'T33.bin';
    case 'C3'
        vComplex=[0 1 1 0 1 0];
        vFileNames{1} = 'C11.bin';
        vFileNames{2} = 'C12_real.bin';
        vFileNames{3} = 'C12_imag.bin';
        vFileNames{4} = 'C13_real.bin';
        vFileNames{5} = 'C13_imag.bin';
        vFileNames{6} = 'C22.bin';
        vFileNames{7} = 'C23_real.bin';
        vFileNames{8} = 'C23_imag.bin';
        vFileNames{9} = 'C33.bin';
    case 'FREEMAN'
        vComplex=[0 0 0];
        vFileNames{1} = 'Freeman_Dbl.bin';
        vFileNames{2} = 'Freeman_Vol.bin';
        vFileNames{3} = 'Freeman_Odd.bin';
    case 'HAALPHA'
        vComplex=[0 0 0];
        vFileNames{1} = 'entropy.bin';
        vFileNames{2} = 'anisotropy.bin';
        vFileNames{3} = 'alpha.bin';
    case 'WISHART_HAALPHA'
        vComplex=[0 0];
        vFileNames{1} = 'wishart_H_alpha_class_1.bin';
        vFileNames{2} = 'wishart_H_A_alpha_class_1.bin';
        
    otherwise
        disp(['Unknown format: ' dataType]);
        
end
