clear; clc;
%% Set Plotting Style
plotStyle()
%% Author: Logan Mathews 
%% Created: 26 June 2019
%% Rev. 00.05.01
%% Rev. Date: 22 October 2019
%% Rev. Changes (XX.XX):
% New use of runningstats.m function and implementation.
% Addition of automatic parametizing
% Pseudocolor plot of spectra as a function of time
% Distance-corrected OASPL from trajectory
%% Micro Rev. Changes (XX.XX.XX):
% Restructuring of figures, implementation of time-clock.
% Addition of t/dSk plot and file saving methods.
% Array parametizing launch stations
% Figure producing options
% Total parametizing of launch parameters and data
% Automatic loading of .mat files containing parameters
% Trajectory matrix loading
% Vertical lines denoting -3dB period and peak directivity angles
% 4x Zoom dSk Plot
% Trajectory Information Plot
%% SCRIPT OPERATION INSTRUCTIONS
% Script has been automated. As such, only for parameter categories are
% required to analyze and produce plots from data. Make selections in the
% "Station and Launch, Figure Selection" section. All other parametizing
% will be done automatically by the script.
%***************************************************************************************************
%% Station and Launch, Figure selection
%---Enter Location Identification Number Here---
% 1 - IRIDIUM 7 West Field 1
% 2 - IRIDIUM 7 West Field 2
% 3 - IRIDIUM 7 North Field
% 4 - SAOCOM 1A North Field
% 5 - SAOCOM 1A West Field
% 6 - RADARSAT Constellation North Field
% 7 - RADARSAT Constellation West Field
% 8 - RADARSAT Constellation Miguelito
% 9 - RADARSAT Constellation East Field
LIN = 9;
%---Enter Channel to Analyze---
% IRIDIUM 7 West Field 1: 0,1,2,3,4,5,6,7
% IRIDIUM 7 West Field 2: 0,1,2
% IRIDIUM 7 North Field: 0,1,2 !
% SAOCOM 1A North Field: 0,1,2,3,4,5 !
% SAOCOM 1A West Field: 0,1,3,4,[6]
% RADARSAT Constellation North Field: 0,1,2,3,4,[5,7],9,10 !!!
% RADARSAT Constellation West Field: 0,1,3,4 !!!!
% RADARSAT Constellation Miguelito: 0,1 !!
% RADARSAT Constellation East Field: 0,1 !!
CHnum = 0;
%---Enter What Figures To Produce---
% 0 - Do Not Produce Figure
% 1 - Produce Figure
time_waveform_plot = 1;
OASPL_plot = 0;
OASPL_Dist_Corr_plot = 0;
OASPL_Norm_vs_Dist_Corr_Plot = 0;
OASPL_down_3_dB_plot = 0;
fine_spectra_down_3_dB_plot = 0;
third_octave_down_3_dB_plot = 0;
third_octave_multiplot = 0;
third_octave_multiplot_re_ambient = 0;
dSk_as_func_of_time_plot = 0;
dSk_as_func_of_time_plot_first_First150Sec = 0;
specgram_spectra_as_fc_of_time_plot = 0;
trajectory_information_plot = 0;
%---Save Figures?---
% 0 - Do Not Save Figure
% 1 - Save Figure
save_figs = 0;
%%---ALL SCRIPT BELOW THIS POINT IS RUN AUTOMATICALLY WITH PREIOUS PARAMETERS---
%***************************************************************************************************
%***************************************************************************************************
%% Load in Configuration Matrices
% Naming Parameter Matrix
% Row 1: Launch Campaign
% Row 2: Location Name
f9NameParams = importdata('f9NameParams.mat');
% Integer Parameter Matrix
% Row 1: Sampling Frequency
% Row 2: Sonic Boom (0 if no, 1 if yes)
% Row 3: GPS Time Clock (0 if no, 1 if yes)
% Row 4: Time Clock Channel (0 default)
% Row 5: Station Radius from Launch Site (m)
% Row 6: Offset time (from prebuffer) (s)
% Row 7: Station Angle from Rocket Trajectory (deg)
f9IntParams = importdata('f9IntParams.mat');
% Channel Configuration for Selected Station
% Row 1: Channel Number
% Row 2: Microphone Name
% Row 3: Microphone Configuration
stationChannels = importdata(['s',int2str(LIN),'.mat']);
%% Load in Trajectory Matrix
% Row 1: Correlated T+ Time (0.1s Resolution)
% Row 2: Speed (m/s)
% Row 3: Corrected Altitude (m)
f9Trajectory = importdata('f9Trajectory.mat');
[qtAlt] = tenthToQuarter(f9Trajectory(3,:));
%% Set up variables to load in
launchCampaign = char(f9NameParams(1,LIN)); % Parameters: 'SAOCOM 1A', 'RADARSAT Constellation', 'IRIDIUM 7'
location = char(f9NameParams(2,LIN)); % Parameters: 'North Field', 'West Field', 'East Field', 'Miguelito'
mic = char(stationChannels(2,(CHnum + 1)));
config = char(stationChannels(3,(CHnum + 1)));
path = ['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Data'];
IDname = 'ID';
isBoom = f9IntParams(2,LIN);
n = 1;
IDnum = 100;
isIRIG = f9IntParams(3,LIN);
IRIGCH = f9IntParams(4,LIN);
fs = f9IntParams(1,LIN);
dt = 1/fs;
fmin = 1;
fmax = 2e4;
pref = 2e-5;
r = f9IntParams(5,LIN);
tOffset = f9IntParams(6,LIN);
theta = f9IntParams(7,LIN);
%% Peak Directivity Angle Calculation
% McInerny suggests 70<Peak Directivity Angle<80 degrees
% Calculate Peak Directivity Heights given angle limits and radius
pdh70 = r/tan(deg2rad(70));
pdh80 = r/tan(deg2rad(80));
% Find cooresponding times to heights in Trajectory Matrix
t70 = f9Trajectory(1,find(f9Trajectory(3,:) > pdh70, 1, 'first'));
t80 = f9Trajectory(1,find(f9Trajectory(3,:) > pdh80, 1, 'first'));
%% Read in file
x = binfileload( path, IDname, IDnum, CHnum );
xorig = x;
OASPL = OASPLcalc(x);
%% Remove Boom, if any
if isBoom == 1
    [boomMaxSP, boomIDX] = max(x);
    noBoom = x(1:(boomIDX-5000));
else
    noBoom = x;
end
%% Resample Data to 10 kHz
fsNew = 10000;
oldfs = fs;
newSamp = resample(noBoom,fsNew,fs);
fs = fsNew;

audiowrite('falcon9.wav',newSamp,fs)

%% runningstats Calculation
% Using runningstats function
% [sigma,Cr,Sk,dSk,Kt,dKt,t] = runningstats(x,ns,fs,pct)
% Inputs: [x->data], [ns->block size], [fs->sample freq.], [pct->percent overlap]
% Outputs: [sigma->s.d.], [Cr->crest factor], [Sk->skewness],
% [dSk->derivative skewness], [Kt->kurtosis], [dKt->derivative kurtosis],
% [t->array from 1 to number of blocks]
averagingPeriod = 2; % Period to average blocks over, in seconds.
nsx = fs*averagingPeriod;
dtx = 1/nsx;
pct = 50;
[sigma,Cr,Sk,dSk,Kt,dKt,tx] = runningstats(newSamp,nsx,fs,pct);
maxdSk = max(dSk);
areadSk = trapz(dSk(floor(tOffset):floor(tOffset+250)));
%% Load in 1-s Time Coorelated Altitude and Downrange Distance Matrix
f9AltAndDRD = importdata('f9AltAndDRD.mat');
% Row 1: Correlated T+ Time (1s Resolution)
% Row 2: Downrange Distance (m)
% Row 3: Altitude (m)
[d] = f9AltAndDRD(2,:);
rsD = resample(d,1,averagingPeriod);
[a] = f9AltAndDRD(3,:);
rsA = resample(a,1,averagingPeriod);
%% True Distance To Source Calculation
[s] = distCalc(r,theta,rsD,rsA,averagingPeriod,tOffset);
%% Specgram
if specgram_spectra_as_fc_of_time_plot == 1
% Using specgram function
[sgGxx,sgt,sgf,runOASPL] = specgram(newSamp,nsx,fs,pct);
end
%% OASPL Plot Calculations
OASPLvals = arrayfun(@(c) 20*log10(c/pref),sigma);
OASPLData.t = tx;
OASPLData.OASPL = OASPLvals;
% save(fullfile('C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files\',[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL_DATA.mat']), 'OASPLData')
%% Corrected OASPL Values
if length(sigma) < length(s)
    lesser = length(sigma);
else
    lesser = length(s);
end
OASPLCorrVals = arrayfun(@(c,s) 20*log10(c/pref) + 20*log10(s/r),sigma(1,1:lesser),s(1,1:lesser));
%% XdB Down Time Period Calculation
numdBdown = 3;
[maxOASPL, maxOASPLidx] = max(OASPLvals);
maxOASPLt = maxOASPLidx;
threshold = maxOASPL - numdBdown;
firstDown = find(OASPLvals > threshold, 1, 'first');
lastDown = find(OASPLvals > threshold, 1, 'last');
dXdB = OASPLvals((firstDown):((lastDown)));
dXdBAll = x((firstDown * oldfs):(lastDown * oldfs));
%% Read in IRIG Data
if isIRIG == 1
    IRIG = binfileload(path,'ID',IDnum,IRIGCH);

    num_secs_decode = 0;
    [start_time] = IRIGB(IRIG,oldfs,num_secs_decode,1,2019);
    t0 = start_time.sec_aft_mid;
    [hrs,min,sec] = sec2time(t0)
end
%% Calculate Ambient Spectra
if (fine_spectra_down_3_dB_plot == 1) || (third_octave_down_3_dB_plot == 1) || (third_octave_multiplot == 1)
ns = oldfs*5;
[ambientGxx,f,ambientOASPL] = autospec(x(((floor(tOffset) - 30)*oldfs):((floor(tOffset)-10)*oldfs)),oldfs,ns);
%% Fractional Octave and PSD
[ambientSpec(n,:),fc]=FractionalOctave(f,ambientGxx,[fmin fmax],3);
ambientSpec = 10.*log10(ambientSpec./pref^2);
end
%% Calculate spectrum and Selected Spectrum
if (fine_spectra_down_3_dB_plot == 1) || (third_octave_down_3_dB_plot == 1)
[dXdBGxx,f,X3dBOASPL] = autospec(dXdBAll,oldfs,ns,length(dXdBAll));
%% Fractional Octave and PSD
[dXdBspec(n,:),dXdBfc]=FractionalOctave(f,dXdBGxx,[fmin fmax],3);
dXdBPSD = 10.*log10(dXdBspec./pref^2);
end
%% Third Octave Recursive Multiplot
if third_octave_multiplot == 1
    oldns = oldfs*5;
    start = firstDown;
    tAdv = 50;
    labels = {};
    for i = 0:tAdv:300
        % Autospectrum
        [multiGxx((i/tAdv + 1),:),f,~] = autospec(x(((start + i)*oldfs):((start + i + 20)*oldfs)),oldfs,oldns);
        % Fractional Octave
        [multiSpec((i/tAdv + 1),:),fc]=FractionalOctave(f,multiGxx((i/tAdv + 1),:),[fmin fmax],3);
        totalSpec((i/tAdv + 1),:) = 10.*log10(multiSpec((i/tAdv + 1),:)./pref^2);
        string = strcat('+',int2str(i),' s');
        labels{end + 1} = string;
    end
end
%% Save Metrics in Matrix
% metrics = importdata(fullfile('C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files\metrics.mat'));
% [sizeMet] = size(metrics);
% metricsApp = [string(launchCampaign), string(location), int2str(CHnum), sprintf('%.6f',maxOASPL), int2str(firstDown-tOffset),...
%     int2str(lastDown-tOffset), sprintf('%.6f',maxdSk), sprintf('%.6f',areadSk)];
% metrics(sizeMet(1)+1,:) = metricsApp;
% save(fullfile("C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files\metrics.mat"), 'metrics');
%% Plot the spectra

if time_waveform_plot == 1
    % Time Waveform Plot 
    figure
    t = dt:dt:length(x)*dt-tOffset;
    plot(t,x(tOffset*oldfs:end-1))
    xlabel('Time (s)')
    ylabel('Pressure (Pa)')
    grid on
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Time Waveform All'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Time Waveform All.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Time Waveform All.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Time Waveform All.fig']))
    end
end

if OASPL_plot == 1
    % OASPL Plot (Averaged)
    figure
    plot(tx,OASPLvals,'DisplayName',['CH',int2str(CHnum),' - ', mic])
    xlabel('Time (s)')
    ylabel('OASPL (dB, re 20\muPa)')
    grid on
    xline(firstDown,'r','DisplayName','-3dB','LabelVerticalAlignment','middle')
    xline(lastDown,'r','HandleVisibility','off')
    legend()
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'OASPL Plot'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Plot.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Plot.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Plot.fig']))
    end
    OASPLData.t = tx;
    OASPLData.OASPL = OASPLvals;
    save(fullfile('C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files\',[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL_DATA.mat']), 'OASPLData')
end

if OASPL_Dist_Corr_plot == 1
    % OASPL Distance-Corrected Plot (Averaged)
    figure
    plot(tx(1,1:lesser),OASPLCorrVals,'DisplayName',['CH',int2str(CHnum),' - ', mic])
    xlabel('Time (s)')
    ylabel('OASPL (dB, re 20\muPa)')
    grid on
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'OASPL Distance Corrected Plot'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Distance Corrected Plot.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Distance Corrected Plot.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Distance Corrected Plot.fig']))
    end
end

if OASPL_Norm_vs_Dist_Corr_Plot == 1
    % OASPL Distance-Corrected Plot (Averaged)
    figure
    plot(tx,OASPLvals,'DisplayName','OASPL Values')
    hold on
    plot(tx(1,1:lesser),OASPLCorrVals,'DisplayName','Distance Corrected OASPL Values')
    hold off
    xlabel('Time (s)')
    ylabel('OASPL (dB, re 20\muPa)')
    grid on
    legend('location','southeast')
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'OASPL vs OASPL Distance Corrected Plot'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL vs OASPL Distance Corrected Plot.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL vs OASPL Distance Corrected Plot.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL vs OASPL Distance Corrected Plot.fig']))
    end
end

if OASPL_down_3_dB_plot == 1
    % OASPL Plot (Averaged, Zoom to 3dB down Time Period)
    figure
    t = dtx:dtx:length(dXdB)*dtx;
    plot(t,dXdB)
    xlabel('Time (s)')
    ylabel('OASPL (dB, re 20\muPa)')
    grid on
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'OASPL Plot of 3dB Down Time Period'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Plot of 3dB Down Time Period.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Plot of 3dB Down Time Period.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OASPL Plot of 3dB Down Time Period.fig']))
    end
end

if fine_spectra_down_3_dB_plot == 1
    % Fine Spectra Plot
    figure
    semilogx(f,10*log10(dXdBGxxAll/pref^2))
    grid on
    xlabel('Frequency (Hz)')
    ylabel('SPL (dB, re 20\muPa)')
    xlim([fmin fmax])
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Fine Spectra Plot of 3dB Down Time Period'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Fine Spectra Plot of 3dB Down Time Period.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Fine Spectra Plot of 3dB Down Time Period.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Fine Spectra Plot of 3dB Down Time Period.fig']))
    end
end

if third_octave_down_3_dB_plot == 1
    % Third-octave Spectra
    figure
    semilogx(dXdBfc,10*log10(dXdBspec/pref^2))
    grid on
    xlabel('Frequency (Hz)')
    ylabel('OTO Level (dB, re 20\muPa)')
    xlim([fmin fmax])
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Third-Octave Spectra Plot of 3dB Down Time Period'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Multiplot.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Multiplot.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Multiplot.fig']))
    end
    OTOData3.t = dXdBfc;
    OTOData3.dSk = 10*log10(dXdBspec/pref^2);
    save(fullfile('C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files\',[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_OTO_Down 3 dB_DATA.mat']), 'OTOData3')
end

if third_octave_multiplot == 1
% Third-octave Spectra Multiplot
    figure
    semilogx(fc,totalSpec,'Linewidth',1.5)
    grid on
    xlabel('Frequency (Hz)')
    ylabel('OTO Level (dB, re 20\muPa)')
    lgd = legend(labels,'location','northeast')
    lgd.Title.String = 'Time Past Maximum SPL'
    lgd.NumColumns = 2;
    xlim([fmin fmax])
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Third-Octave Spectra Plot of 3dB Down Time Period'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Multiplot re Ambient.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Multiplot re Ambient.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Multiplot re Ambient.fig']))
    end
end
if third_octave_multiplot_re_ambient == 1
% Third-octave Spectra Multiplot
    figure
    [numRows,numCols] = size(totalSpec)
    for i = 1:numRows
        reAmb(i,:) = totalSpec(i,:) - ambientSpec;
    end
    semilogx(fc,reAmb,'Linewidth',1.5)
    xlabel('Frequency (Hz)')
    ylabel('OTO Level (dB, re Ambient)')
    grid on
    lgd = legend(labels,'location','northeast')
    lgd.Title.String = 'Time Past Maximum SPL'
    lgd.NumColumns = 2;
    xlim([fmin fmax])
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Third-Octave Spectra Plot Relative to Ambient'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Plot of 3dB Down Time Period_Recurring_Relative Ambient.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Plot of 3dB Down Time Period_Recurring_Relative Ambient.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Third-Octave Spectra Plot of 3dB Down Time Period_Recurring_Relative Ambient.fig']))
    end
end


if dSk_as_func_of_time_plot == 1
    % Derivative Skewness vs Time
    figure
    plot(tx,dSk,'DisplayName',['CH',int2str(CHnum),' - ', mic])
    grid on
    xlabel('Time (s)')
%     xline(firstDown,'r','DisplayName','-3dB','LabelVerticalAlignment','middle')
%     xline(lastDown,'r','HandleVisibility','off')
%     xline(t80 + tOffset,'-.b','DisplayName','80 DEG')
%     xline(t70 + tOffset,'--g','DisplayName','70 DEG')
    ylabel('dSk (Sk[\partial p/\partial t])')
    legend()
    xlim([50 300])
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Derivative Skewness vs Time'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Derivative Skewness vs Time.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Derivative Skewness vs Time.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Derivative Skewness vs Time.fig']))
    end
    dSkData.t = tx;
    dSkData.dSk = dSk;
    save(fullfile('C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files\',[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_dSk as a Function of Time_DATA.mat']), 'dSkData')
end

if dSk_as_func_of_time_plot_first_First150Sec == 1
    % Derivative Skewness vs Time (First 150 sec)
    figure
    plot(tx,dSk,'DisplayName',['CH',int2str(CHnum),' - ', mic])
    grid on
    xlabel('Time (s)')
%     xline(firstDown,'r','DisplayName','-3dB','LabelVerticalAlignment','middle')
%     xline(lastDown,'r','HandleVisibility','off')
    xlim([firstDown-50 lastDown+50])
    ylabel('dSk (Sk[\partial p/\partial t])')
    legend('Location', 'northeast')
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Derivative Skewness vs Time (First 150 sec)'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Derivative Skewness vs Time (First 150 sec).svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Derivative Skewness vs Time (First 150 sec).png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Derivative Skewness vs Time (First 150 sec).fig']))
    end
end

if specgram_spectra_as_fc_of_time_plot == 1
    % Spectra as Function of Time Plot
    figure
    sgGxxT=transpose(sgGxx);
    pcolor(sgt*averagingPeriod,sgf,10*log10(sgGxxT/pref^2))
    set(gca,'yscale','log');
    shading interp
    colorbar
    colormap jet
    ylabel('Frequency (Hz)');
    xlabel('Time (s)');
    title({[launchCampaign, ' ', location, ' CH', int2str(CHnum),' ', mic, ' ', config], 'Spectra as a Function of time'})
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Spectra as a Function of time.svg']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Spectra as a Function of time.png']))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Spectra as a Function of time.fig']))
    end
    % Save Data
    specgramData.t = sgt*averagingPeriod;
    specgramData.f = sgf;
    specgramData.dB = 10*log10(sgGxxT/pref^2);
    save(fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures\CH', int2str(CHnum)],[launchCampaign, '_', location, ' CH', int2str(CHnum),' ', mic, '_', config, '_Spectra as a Function of time_DATA.mat']), 'specgramData')
    
end

if trajectory_information_plot == 1
    % Falcon 9 Velocity and Altitude vs Time
    figure
    hold on
    grid on
    xlabel('Time (s)')
    xline(2,'r','Full Thrust','LineWidth',2,'FontSize',24)
    xline(60,'Color',[0 0.4470 0.7410],'Label','Max Q','LineWidth',2,'FontSize',24)
    xline(137,'Color',[0.8500 0.3250 0.0980],'Label','MECO','LabelHorizontalAlignment','left','LineWidth',2,'FontSize',24)
    xline(140,'Color',[0.9290 0.6940 0.1250],'Label','Stage Separation','LineWidth',2,'FontSize',24)
    yyaxis left
    plot(f9Trajectory(1,:), f9Trajectory(2,:),"LineWidth",2)
    ylabel('Velocity (m/s)')
    yyaxis right
    plot(f9Trajectory(1,:), f9Trajectory(3,:),"LineWidth",2)
    ylabel('Altitude (m)')
    title('Falcon 9 Velocity and Altitude vs Time')
    hold off
    if save_figs == 1
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures'],'Falcon 9 Velocity and Altitude vs Time.svg'))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures'],'Falcon 9 Velocity and Altitude vs Time.png'))
        saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\', launchCampaign, '\', location, '\Figures'],'Falcon 9 Velocity and Altitude vs Time.fig'))
    end
end
