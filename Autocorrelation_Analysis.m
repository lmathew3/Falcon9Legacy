%% Falcon 9 Autocorrelation Analysis
% This script performs autocorrelation analysis on datasets from Vandenberg
% AFB Falcon 9 Launches using the MATLAB xcorr function
%% Set Parameters
data_path = 'F:\ASA Falcon 9 Analysis\';
data_type = 'Waveform';
launch = 'RADARSAT Constellation';
site = 'Miguelito';
% Option to select portion of time series
selection = 0;
tStart = 100;
tEnd = 200;
% Option for Hilbert Transform of Autocorrelation/Envelope Function
ht = 1;
%% Load Data
data = loadFalcon9Data(launch,site,data_type,data_path);

x = data.waveformData.p;
fs = data.waveformData.fs;

if selection
    x = x(tStart*fs:tEnd*fs);
end
%% Compute Autocorrelation
[rxx,lags] = xcorr(x,x,'normalized');
%%
if ht == 1
    rxxt = hilbert(rxx);
    axx = sqrt(rxx.^2 + rxxt.^2);
end
%% Plotting
figure
plot(lags/fs,rxx)
xlabel('\tau, s')
ylabel('R_{xx}(\tau) (Norm.)')
title(['Autocorrelation ',launch,' ',site])

if ht == 1
    figure
    semilogy(lags/fs,axx)
    xlabel('\tau, s')
    ylabel('A_{xx}(\tau) (Norm.)')
    title(['Env. Func. of Autocorrelation ',launch,' ',site])
end
    

