%% Peak Frequency Script;
clear all;
pref = 20e-6;
launch = 'RADARSAT Constellation';
site = 'North Field';
data_type = 'Waveform';
data_path = 'E:\ASA Falcon 9 Analysis\';
[data,CH,mic,config] = loadFalcon9Data(launch,site,data_type,data_path);
x = data.waveformData.p;
fs = data.waveformData.fs;
dt = 1/fs;
t = dt:dt:length(x)*dt; % Time array cooresponding to waveform
specLength = 16; % Block size for each autospec calculation
ns = fs*4;
pct = 90; % Percent overlap between blocks
numBlocks = floor(length(x)/(specLength*fs*(100-pct)/100))-1;
sizeBlocks = floor(length(x)/numBlocks);

De = 2.76; % Equivalent exhasut diameter
Ue = 3100; % Exit (plume) Velocity
c0 = 340; % Ambient Speed of Sound
ce = 910; % Speed of sound in plume

for i = 1:numBlocks-10
    idx1 = 1 + (i-1)*sizeBlocks;
    idx2 = idx1 + specLength*fs;
    meanIdx = round(idx1 + sizeBlocks/2); % Mean index for window
    [Gxx,f,~] = autospec(x(idx1:idx2),fs,ns,specLength*fs); % Compute autospectrum for block
    SPL = 10*log10(Gxx./pref^2);
    [maxSPL,maxIDX] = max(SPL); % Find peak SPL of spectrum
    first = find(SPL > (maxSPL - 3), 1, 'first'); % Find first -3 dB point
    last = find(SPL > (maxSPL - 3), 1, 'last'); % Find last -3 dB point
    meanVal = round(sqrt(first*last)); % Geometric mean
    if maxIDX == 1
        meanVal = 1;
    end
    fpk(i) = f(meanVal); % Assign value for peak frequency
    tpk(i) = t(meanIdx); % Assign cooresponding window time

    fpk1(i) = f(maxIDX);
end
%%

s = fpk*(De/Ue); % Traditional Strouhal Number
c0_scaling = fpk*(De/c0); % Scaling by ambient soundspeed
ce_scaling = fpk*(De/ce); % Scaling by plume soundspeed

fmax = max(fpk);
maxs = max(s);
max_c0_scale = max(c0_scaling);
max_ce_scale = max(ce_scaling);

figure
semilogy(tpk,fpk,tpk,fpk1)
ylabel('Peak Frequency (Hz)')
% yyaxis right
% semilogy(tpk,s)
% ylabel('Strouhal Number')
xlabel('Time (s)')
grid on
title([launch,' ',site])
sprintf(['The peak frequency for the ',launch,' launch, ',site,' location is %0.5f Hz (3 dB Method)'],max(fpk))
sprintf(['The peak frequency for the ',launch,' launch, ',site,' location is %0.5f Hz (Raw Peak Method)'],max(fpk1))
% figure
% yyaxis left
% semilogy(tpk,c0_scaling)
% xlabel('Time (s)')
% ylabel('fd/c_0')
% yyaxis right
% semilogy(tpk,ce_scaling)
% ylabel('fd/c_e')
% grid on