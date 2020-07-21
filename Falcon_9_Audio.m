% Path to Data
path = 'C:\Users\logan\Box\Acoustics\Students\Daniel Novakovich - Gee\SP4-3\LC34\data';
% Path to Matlab Scripts
addpath 'C:\Users\logan\Box\ASA Falcon 9 Analysis\Matlab'


%% Parameters

IDnum = 10604;
CHleft = 1;
CHright = 4;
fs = 51200;
fresample = 51200;

right = binfileload(path,'ID',IDnum,CHright);
left = binfileload(path,'ID',IDnum,CHleft);

fsNew = 10000;
oldfs = fs;
right = resample(right,fsNew,fs);
left = resample(left,fsNew,fs);
fs = fsNew;

dual_channel = [right(:), left(:)];
audiowrite('falconheavy.wav',dual_channel,fs)


% sound(dual_channel, fs);