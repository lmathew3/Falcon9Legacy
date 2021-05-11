%% Falcon 9 Coherence Analysis
% This script performs coherence analysis on datasets from Vandenberg
% AFB Falcon 9 Launches using the MATLAB xcorr function
plotStyle('FontStyle','classic','FontSize',22,'LineWidth',1.75,'ColorScheme',1)
%% Set Parameters
data_path = 'F:\ASA Falcon 9 Analysis\';
data_type = 'Waveform';
% First site to compare
launch1 = 'RADARSAT Constellation';
site1 = 'Miguelito';
% Second site to compare
launch2 = 'RADARSAT Constellation';
site2 = 'East Field';
% Option to select portion of time series
selection = 0;
tStart = 100;
tEnd = 200;
% Frequency Limits
fmin = 0.13;
fmax = 20e3;
%% Load Data
data1 = loadFalcon9Data(launch1,site1,data_type,data_path);
x = data1.waveformData.p;
fsx = data1.waveformData.fs;

data2 = loadFalcon9Data(launch2,site2,data_type,data_path);
y = data2.waveformData.p;
fsy = data2.waveformData.fs;

% If data are not of the same sample rate, resample them to the lesser
% sample rate of the two.
if fsx > fsy
    x = resample(x,fsy,fsx);
    fs = fsy;
elseif fsy > fsx
    y = resample(y,fsx,fsy);
    fs = fsx;
else
    fs = fsx;
end

if selection
    x = x(tStart*fs:tEnd*fs);
    y = y(tStart*fs:tEnd*fs);
end

%% Compute Autospectra and Crosspectrum
ns = fs*2;
N = fs*20;
[Gxx,f,~] = autospec(x,fs,ns,N,1);
[Gyy,f,~] = autospec(y,fs,ns,N,1);
[Gxy,f] = crossspec(x,y,fs,ns,N,1);
% Compute Coherence
gamma2xy = abs(Gxy).^2./Gxx./Gyy;
%% Plotting
figure
semilogx(f,gamma2xy)
xlabel('Frequency (Hz)')
ylabel('\gamma_{xy}^2')
title({'Coherence between ',[launch1,' ',site1, ' and '],[launch2,' ',site2]})
xlim([fmin fmax])