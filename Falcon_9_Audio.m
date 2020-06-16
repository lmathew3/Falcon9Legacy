% Path to Data
path = 'E:\ASA Falcon 9 Analysis\RADARSAT Constellation\North Field\Data';
% Path to Matlab Scripts
addpath 'C:\Users\logan\Box\ASA Falcon 9 Analysis\Matlab'


%% Parameters

IDnum = 100;
CHleft = 1;
CHright = 2;
fs = 102400;
fresample = 51200;

right = binfileload(path,'ID',IDnum,CHright);
left = binfileload(path,'ID',IDnum,CHleft);

% fsNew = 10000;
% oldfs = fs;
% right = resample(right,fsNew,fs);
% left = resample(left,fsNew,fs);
% fs = fsNew;
% 
% audiowrite('falcon9.wav',newSamp,fs)

dual_channel = [right(:), left(:)];
sound(dual_channel, fs);