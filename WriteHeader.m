function success= WriteHeader(num_samples,num_lines,nBands,sName,nDataType,sInterleave,nByteOrder)

if ~exist('nDataType')
   nDataType= 4;
end
if ~exist('sInterleave')
   sInterleave= 'bsq';
end 
if ~exist('nByteOrder')
   nByteOrder= 0;
end 
if ~exist('nBands')
   nBands= 1;
end 
success= 1;
idx= findstr(sName,'.hdr');
if isempty(idx)
fid=fopen([sName '.hdr'], 'w+');
else
    fid=fopen([sName], 'w+');
end
if ~fid
    success= 0;
end
fprintf(fid, 'Envi\n');
fprintf(fid, 'description = {\n');
fprintf(fid, '  File Imported into ENVI.}\n');
fprintf(fid, 'samples = %d\n',num_samples);
fprintf(fid, 'lines   = %d\n',num_lines);
fprintf(fid, 'bands   = %d\n',nBands);
fprintf(fid, 'header offset = 0\n');
fprintf(fid, 'file type = ENVI Standard\n');
fprintf(fid, 'data type = %d\n',nDataType);
fprintf(fid, 'interleave = %s\n',sInterleave);
fprintf(fid, 'sensor type = Unknown\n');
fprintf(fid, 'byte order = %d\n',nByteOrder);
fprintf(fid, 'band names = {\n');
fprintf(fid, ' %s}\n', sName);
fclose(fid);