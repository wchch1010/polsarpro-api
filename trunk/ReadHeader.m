function [num_samples,num_lines,nBands,nHeaderOffset,nDataType,sInterleave,nByteOrder]= ReadHeader(sName)
if isempty(findstr(sName, 'hdr'))
    fid=fopen([sName '.hdr']);
else
  fid=fopen([sName]);  
end
var_hdr = '';
% read number of samples
while ~strcmp(var_hdr, 'samples')&& ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
num_samples = sscanf(line_hdr,'%*s %*s %f');
% read number of lines
while ~strcmp(var_hdr, 'lines') && ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
num_lines = sscanf(line_hdr,'%*s %*s %f');
% read number of lines
while ~strcmp(var_hdr, 'bands') && ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
nBands = sscanf(line_hdr,'%*s %*s %f');
% read number of lines
while ~strcmp(var_hdr, 'header') && ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
nHeaderOffset = sscanf(line_hdr,'%*s %*s = %d');
% read number of lines
while ~strcmp(var_hdr, 'data') && ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
nDataType = sscanf(line_hdr,'%*s %*s = %d');
% read number of lines
while ~strcmp(var_hdr, 'interleave') && ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
sInterleave = sscanf(line_hdr,'%*s %*s %s');
% read number of lines
while ~strcmp(var_hdr, 'byte') && ~feof(fid)
    line_hdr = fgetl(fid);
    var_hdr = strtok(line_hdr, ' ');
end
nByteOrder = sscanf(line_hdr,'%*s %*s = %d');
fclose(fid);
    