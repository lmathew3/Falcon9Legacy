%% Peak Frequency Script
clear tpk fpk;
launch = 'RADARSAT Constellation';
site = 'West Field';
data_type = 'Waveform';
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

for i = 1:numBlocks-10
    idx1 = 1 + (i-1)*sizeBlocks;
    idx2 = idx1 + specLength*fs;
    meanIdx = idx1 + sizeBlocks/2; % Mean index for window
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
end

figure
semilogy(tpk,fpk)
xlabel('Time (s)')
ylabel('Peak Frequency (Hz)')
grid on

