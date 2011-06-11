function SetPSPDir()
global POLSARPRO_API_OUT_DIR;
global POLSARPRO_API_IN_DIR;
global POLSARPRO_DIR;
bExistAll= (exist('POLSARPRO_API_OUT_DIR') & exist('POLSARPRO_API_IN_DIR') & exist('POLSARPRO_DIR'));
if bExistAll
    bNotEmpty= (~isempty(POLSARPRO_API_OUT_DIR) & ~isempty(POLSARPRO_API_IN_DIR) & ~isempty(POLSARPRO_DIR));
    if (bNotEmpty)
        bIsDIR= (isdir(POLSARPRO_API_OUT_DIR) & isdir(POLSARPRO_API_IN_DIR) & isdir(POLSARPRO_DIR));
        return;
    end
end
% Get directory for polSARpro functions
fid = fopen('path.txt', 'r');
if fid==-1
    EnterPolSARProInfo();
    fid = fopen('path.txt', 'r');
end
POLSARPRO_DIR = fgetl(fid);
POLSARPRO_API_IN_DIR = fgetl(fid);
POLSARPRO_API_OUT_DIR = fgetl(fid);
fclose(fid);
