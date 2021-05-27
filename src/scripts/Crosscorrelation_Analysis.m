%% Falcon 9 Cross-correlation Analysis
% This script performs cross-correlation analysis on datasets from Vandenberg
% AFB Falcon 9 Launches using the MATLAB xcorr function
%% Set Parameters
data_path = 'E:\Rocket Noise\Falcon 9\';
data_type = 'Waveform';
% First site to compare
launch1 = 'RADARSAT Constellation';
site1 = 'West Field';
% Second site to compare
launch2 = 'RADARSAT Constellation';
site2 = 'North Field';
% Option to select portion of time series
selection = 1;
tStart = 1;
tEnd = 50;
%% Load Data
data1 = loadFalcon9Data(launch1,site1,data_type,data_path);
x1 = data1.waveformData.p;
fs1 = data1.waveformData.fs;

data2 = loadFalcon9Data(launch2,site2,data_type,data_path);
x2 = data2.waveformData.p;
fs2 = data2.waveformData.fs;

% If data are not of the same sample rate, resample them to the lesser
% sample rate of the two.
if fs1 > fs2
    x1 = resample(x1,fs2,fs1);
    fs1 = fs2;
elseif fs2 > fs1
    x2 = resample(x2,fs1,fs2);
    fs2 = fs1;
end

if selection
    x1 = x1(tStart*fs1:tEnd*fs1);
    x2 = x2(tStart*fs2:tEnd*fs2);
end

%% Equalize size of data
% Make data the same length by clipping to the size of the shortest time
% series (to allow for a normalized cross-correlation)
if length(x1) < length(x2)
    x2 = x2(1:length(x1));
elseif length(x2) < length(x1)
    x1 = x1(1:length(x2));
end
%% Compute Cross-correlation
[rxy,lags] = xcorr(x1,x2,'normalized');

%% Plotting
figure
plot(lags/fs1,rxy)
xlabel('Time (s)')
ylabel('Normalized Amplitude')
title({'Normalized Cross-correlation between ',[launch1,' ',site1, ' and ',launch2,' ',site2]})