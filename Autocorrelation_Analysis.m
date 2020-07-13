%% Falcon 9 Autocorrelation Analysis
% This script performs autocorrelation analysis on datasets from Vandenberg
% AFB Falcon 9 Launches using the MATLAB xcorr function
%% Set Parameters
data_path = 'F:\ASA Falcon 9 Analysis\';
data_type = 'Waveform';
launch = 'RADARSAT Constellation';
site = 'North Field';
% Option to select portion of time series
selection = 0;
tStart = 100;
tEnd = 200;
%% Load Data
data = loadFalcon9Data(launch,site,data_type,data_path);

x = data.waveformData.p;
fs = data.waveformData.fs;

if selection
    x = x(tStart*fs:tEnd*fs);
end
%% Compute Autocorrelation
[rxx,lags] = xcorr(x,x,'normalized');

%% Plotting
figure
plot(lags/fs,rxx)
xlabel('Time (s)')
ylabel('Normalized Amplitude')
title(['Normalized Autocorrelation ',launch,' ',site])

