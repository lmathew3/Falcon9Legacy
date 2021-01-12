%% Compute Spectra for Falcon 9 Datasets, save as .mat files

%% Parameters
launch = 'SAOCOM 1A';
site = 'North Field';
data_type = 'Waveform';
data_path = 'E:\ASA Falcon 9 Analysis\';
blockSize = 4 ;% Block size, in seconds.
tStart = 30;
tEnd = 50;
fmin = 1;
fmax = 20000;
save_data = 0;
%% Load data
[data,CH,mic,config] = loadFalcon9Data(launch,site,data_type,data_path);
t = data.waveformData.t;
x = data.waveformData.p;
fs = data.waveformData.fs;
ns = fs*blockSize;
x = x(tStart*fs:tEnd*fs);
%% Compute Autospectrum
[Gxx_PSD,f] = autospec(x,fs,ns,2^floor(log2(length(x))),0);
[Gxx_Autospectrum,f] = autospec(x,fs,ns,2^floor(log2(length(x))),1);
PSD = 10.*log10(Gxx_PSD./pref^2);
Autospectrum = 10.*log10(Gxx_Autospectrum./pref^2);
[spec,fc]=FractionalOctave(f,Gxx_PSD,[fmin fmax],3);
OTO = 10.*log10(spec./pref^2);
%%
figure
semilogx(f,PSD,f,Autospectrum,fc,OTO)
xlim([fmin fmax])
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB)')
legend('PSD (dB re 20\muPa/\surdHz)','Autospectrum (dB re 20\muPa)','OTO (dB re 20\muPa)','Location','SouthWest')
title({['Spectra, ', launch, ' ', site], [' t = ', num2str(tStart), ' to t = ', num2str(tEnd), ' s']})
grid on
%% Save Data in Structure
SpectrumData.f = f;
SpectrumData.Autospectrum = Autospectrum;
SpectrumData.PSD = PSD;
SpectrumData.fc = fc;
SpectrumData.OTO = OTO;
if save_data == 1
    save(fullfile([data_path, launch, filesep, site, filesep, 'MAT Files', filesep, launch, '_', site, ' CH', int2str(CH),' ', mic, '_', config, '_Spectrum_DATA.mat']), 'SpectrumData')
end