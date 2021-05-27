%% Use in conjunction with Spectrum_Analysis.m
%% Spectra
tStart = 36;
tEnd = 44;
usePackage GeneralSignalProcessing
usePackage Falcon9Legacy

f9IntParams = importdata('f9IntParams.mat');
% 
% tStart = 56;
% tEnd = 64;

tbuff = 10;
tStart = tStart+tbuff;
tEnd = tEnd+tbuff; 

fmin = 1;
fmax = 20000;

blockSize = 2; % Block size, in seconds
unitflag = 0; % Units of spectrum, 0 for autospectal density, 1 for autospectrum

r = f9IntParams(5,7);

tiled = 0;

data_path = 'E:\Rocket Noise\Falcon 9\';

pref = 20e-6;

data = loadFalcon9Data('RADARSAT Constellation','West Field','Waveform',data_path);
x = data.waveformData.p;
fs = data.waveformData.fs;
x = x((tStart*fs)+1:tEnd*fs);
N = 2^floor(log2(length(x)));
[Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
[spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
WFlevels = 10.*log10(spec./pref^2);

data = loadFalcon9Data('RADARSAT Constellation','Miguelito','Waveform',data_path);
x = data.waveformData.p;
fs = data.waveformData.fs;
x = x((tStart*fs)+1:tEnd*fs);
N = 2^floor(log2(length(x)));
[Gxx,f,OASPL] = autospec(x,fs,fs*blockSize,N,unitflag); % Compute single sided spectrum
[spec,fc] = FractionalOctave(f,Gxx,[fmin fmax],3); % Set for OTO bands
MIGlevels = 10.*log10(spec./pref^2);
%% Corrections
plotStyle('StandardStyle','custom','FontStyle','classic','FontSize',19,'ColorScheme',1,'AspectRatio','square','PlotSize','small','Orientation','portrait')
N1 = @(rh,rv,c,f) rv^2*f/c/rh;
B1 = @(N1) 5 + 20*log10(sqrt(2*pi*N1)./tanh(sqrt(2*pi*N1)));
c = 340;
rv = 27;
rh = 330;
B = B1(N1(rh,rv,c,fc));
GS = 20*log10(r/13685);
[ind] = fracOctMarkerIndices(fc,[fmin,fmax],1);
figure
semilogx(fc,WFlevels,'-o','MarkerSize',8,'MarkerIndices',ind,'Color',[0.8500 0.3250 0.0980])
hold on
semilogx(fc,MIGlevels','-d','MarkerSize',8,'MarkerIndices',ind,'Color',[0.4940 0.1840 0.5560])
semilogx(fc,WFlevels+GS,'-s','MarkerSize',8,'MarkerIndices',ind,'Color',[0.4660 0.6740 0.1880])
semilogx(fc,WFlevels-B+GS,'-x','MarkerSize',10,'MarkerIndices',ind,'Color',[0.6350 0.0780 0.1840])
% semilogx(fc,levels-B1(N1(600,rv,c,fc))+GS)
% semilogx(fc,levels-B1(N1(rh,50,c,fc))+GS)
legend('WF','MC','WF + GS','WF + GS + Barrier','Location','SouthWest')
xlim([fmin fmax])
ylim([20 110])
grid on
xticks([1,10,100,1000,10000])
yticks([20:10:110])
xlabel('Frequency (Hz)')
ylabel('SPL (dB re 20\muPa)')