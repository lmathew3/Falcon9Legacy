% Path to Data
% path = 'F:\ASA Falcon 9 Analysis\RADARSAT Constellation\North Field\Data';
% path = 'F:\ASA Falcon 9 Analysis\IRIDIUM 7\West Field 1\Data';
path = 'F:\ASA Falcon 9 Analysis\SAOCOM 1A\North Field\Data';
% Path to Matlab Scripts
% addpath 'C:\Users\logan\Box\ASA Falcon 9 Analysis\Matlab'


%% Parameters

IDnum = 100;
CHleft = 3;
CHright = 4;
fs = 51200;
fresample = 44100;

tstart = 60;
tend = 160;

% tstart = 502;
% tend = 512;

f_filter = 1e4;

right = binfileload(path,'ID',IDnum,CHright);
left = binfileload(path,'ID',IDnum,CHleft);

fsNew = fresample;
oldfs = fs;
% right = resample(right,fsNew,fs);
% left = resample(left,fsNew,fs);
% fs = fsNew;
%%
% right = filterData(right,f_filter,fs,'low','FilterOrder',6);
% left = filterData(left,f_filter,fs,'low','FilterOrder',6);

dual_channel = [right(tstart*fs:tend*fs), left(tstart*fs:tend*fs)];
% dual_channel = dual_channel./max(dual_channel);
% audiowrite('falcon9_rocket_noise.wav',dual_channel,fs)


sound(dual_channel, fs);