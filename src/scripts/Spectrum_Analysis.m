% clear; clc;

%% Spectra Comparison Script
% Compares spectra using strucuted variables (structs) containing
% time series data from measurement sites created using the Falcon_9_Analysis
% script.

plotStyle('FontStyle','classic','FontSize',16,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','medium','Orientation','portrait')
%%
% tStart = 38;
% tEnd = 46;

tStart = 56;
tEnd = 64;

tbuff = 10;
tStart = tStart+tbuff;
tEnd = tEnd+tbuff; 

fmin = 1;
fmax = 20000;

blockSize = 2; % Block size, in seconds
unitflag = 0; % Units of spectrum, 0 for autospectal density, 1 for autospectrum
proportional = 1; % Proportional (OTO) band spectra option, 0 for narrowband, 1 for proportional band

c = 340;

corrToCommonDist = 0;
r = f9IntParams(5,7);
theta = f9IntParams(7,7); % Relative angle from pad to site
[t,~,dtr] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
commonr = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.


tiled = 0;

data_path = 'E:\ASA Falcon 9 Analysis\';

pref = 20e-6;

I7_NF_Plot = 0;
I7_WF1_Plot = 0;
I7_WF2_Plot = 0;
S1A_NF_Plot = 0;
S1A_WF_Plot = 0;
RC_NF_Plot = 1;
RC_WF_Plot = 1;
RC_EF_Plot = 1;
RC_MG_Plot = 1;

numPlots = I7_NF_Plot + I7_WF1_Plot + I7_WF2_Plot + S1A_NF_Plot + S1A_WF_Plot + RC_NF_Plot + RC_WF_Plot + RC_EF_Plot + RC_MG_Plot;

f9IntParams = importdata('f9IntParams.mat');

%%
if tiled == 1
    switch numPlots
        case 1
            figure
        case 2
            a = tiledlayout(1,2)
        case 3
            a = tiledlayout(1,3)
        case 4
            a = tiledlayout(2,2)
        case {5,6}
            a = tiledlayout(2,3)
        case {7,8}
            a = tiledlayout(2,4)
        case 9
            a = tiledlayout(3,3)
    end
else
%     figure 
    hold on
    labels = string.empty;
end
%%

if I7_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    r = f9IntParams(5,3); % Radius from pad to site
    theta = f9IntParams(7,3); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    data = loadFalcon9Data('IRIDIUM 7','North Field','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('IRIDIUM 7 NEXT North Field')
    else
        labels(length(labels) + 1) = "IRIDIUM 7 NEXT North Field";
    end
end
if I7_WF1_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,1);
    theta = f9IntParams(7,1); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('IRIDIUM 7','West Field 1','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('IRIDIUM 7 NEXT West Field 1')
    else
        labels(length(labels) + 1) = "IRIDIUM 7 NEXT West Field 1";
    end
end
if I7_WF2_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,2);
    theta = f9IntParams(7,2); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('IRIDIUM 7','West Field 2','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('IRIDIUM 7 NEXT West Field 2')
    else
        labels(length(labels) + 1) = "IRIDIUM 7 NEXT West Field 2";
    end
end
if S1A_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,4);
    theta = f9IntParams(7,4); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('SAOCOM 1A','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('SAOCOM 1A','North Field','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('SAOCOM 1A North Field')
    else
        labels(length(labels) + 1) = "SAOCOM 1A North Field";
    end
end
if S1A_WF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,5);
    theta = f9IntParams(7,5); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('SAOCOM 1A','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('SAOCOM 1A','West Field','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('SAOCOM 1A West Field')
    else
        labels(length(labels) + 1) = "SAOCOM 1A West Field";
    end
end
if RC_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,6);
    theta = f9IntParams(7,6); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('RADARSAT Constellation','North Field','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('RADARSAT Constellation North Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation North Field";
    end
end
if RC_WF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,7);
    theta = f9IntParams(7,7); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('RADARSAT Constellation','West Field','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('RADARSAT Constellation West Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation West Field";
    end
end
if RC_EF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,9);
    theta = f9IntParams(7,9); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('RADARSAT Constellation','East Field','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('RADARSAT Constellation East Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation East Field";
    end
end
if RC_MG_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    % Distance Correcting
    r = f9IntParams(5,8);
    theta = f9IntParams(7,8); % Relative angle from pad to site
    [t,~,dtr] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta); % Load in trajectory for distance to the rocket
    r = dtr((tEnd-tStart)/2 + 1); % Distance to the rocket at the mean time value of the spectrum window.
    corrFactor = 20*log10(r/commonr); % Factor to correct for distance.
    % Load Data
    data = loadFalcon9Data('RADARSAT Constellation','Miguelito','Waveform',data_path);
    x = data.waveformData.p;
    fs = data.waveformData.fs;
    x = x((tStart*fs)+1:tEnd*fs);
    N = 2^floor(log2(length(x)));
    [Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
    if proportional % If proportional band spectra, compute center frequencies and band levels
        [spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
        levels = 10.*log10(spec./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(fc,levels)
    else
        levels = 10.*log10(Gxx./pref^2);
        if corrToCommonDist
            levels = levels + corrFactor;
        end
        semilogx(f,levels)
    end
    if tiled == 1
        title('RADARSAT Constellation Miguelito')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation Miguelito";
    end
end
%%
if numPlots > 1 && tiled == 1
    xlabel(a,'Frequency (Hz)','Fontlength',22)
    ylabel(a,'SPL (dB re 20\muPa/\surdHz)','Fontlength',22)
    title(a,'Spectra')
    xlim([fmin fmax])
else
%     xlabel('Frequency (Hz)')
%     ylabel('SPL (dB re 20\muPa/\surdHz)')
%     title('Spectrum')
    xlim([fmin fmax])
    set(gca, 'XScale', 'log')
    if tiled == 0
        legend(labels,'Location','SouthWest')
    end
end

grid on