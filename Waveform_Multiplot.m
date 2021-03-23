clear; clc; close all;
%%
data_path = 'E:\ASA Falcon 9 Analysis\';

plotStyle('FontStyle','classic','FontSize',22,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','standard','PlotSize','large')
%% Parameters
pref = 2e-5;
t_offset = 9.78;
times = [1/51200, 0+t_offset,42+t_offset,100+t_offset,300+t_offset];
spec_duration = 8;
third_octave_multiplot = 1;
fmin = 0.5;
fmax = 20000;
fHighPass = 0.5;
highPass = 0;
fLowPass = 300;
lowPass = 0;

%% Run Calculations
launch = 'RADARSAT Constellation';
site = 'West Field';
data_type = 'Waveform';
[data,CH,mic,config] = loadFalcon9Data(launch,site,data_type,data_path);
x = data.waveformData.p;
fs = data.waveformData.fs;
dt = 1/fs;

if lowPass == 1
    [B,A] = butter(2,fLowPass*2/fs,'low');
    x = filter(B,A,x);
end

if third_octave_multiplot == 1
    for i = 1:length(times)
        % Autospectrum
        [multiGxx(i,:),f,OASPLs(i)] = autospec(x((times(i)*fs):(times(i) + spec_duration)*fs -1),fs,fs*4,spec_duration*fs);
        % Fractional Octave
        [multiSpec(i,:),fc]=FractionalOctave(f,multiGxx(i,:),[fmin fmax],3);
        totalSpec(i,:) = 10.*log10(multiSpec(i,:)./pref^2);
    end
end

if highPass == 1
    [B,A] = butter(2,fHighPass*2/fs,'high');
    x = filter(B,A,x);
end
%%

figure
semilogx(fc,totalSpec,'LineWidth',2);
grid on
xlim([fmin fmax])
xlabel('Frequency (Hz)')
ylabel('SPL (dB re 20\muPa)')
legend(['Ambient, OASPL = ',sprintf('%0.4f',OASPL(1)),' dB'],['I, OASPL = ',sprintf('%0.4f',OASPL(2)),' dB'],...
    ['II, OASPL = ',sprintf('%0.4f',OASPL(3)),' dB'],...
    ['III, OASPL = ',sprintf('%0.4f',OASPL(4)),' dB'],...
    ['IV, OASPL = ',sprintf('%0.4f',OASPL(5)),' dB'],'Location','NorthEast')
title('One-Third Octave Band Spectra')
xlim([1 20000])
% ylim([-30 120])

%%
figure
t = tiledlayout(2,2)
nexttile
plot(dt-0.5:dt:2-0.5,x(1,(t_offset-0.5)*fs:(2+t_offset-0.5)*fs-1))
title('Ignition Overpressure (A)')
yline(0)
nexttile
plot(38+dt:dt:40,x(1,(38+t_offset)*fs:(40+t_offset)*fs-1))
title('Peak Directivity (B)')
yline(0)
nexttile
plot(350+dt:dt:352,x(1,(350+t_offset)*fs:(352+t_offset)*fs-1))
title('Late Launch (C)')
yline(0)
nexttile
plot(433+dt:dt:435,x(1,(433+t_offset)*fs:(435+t_offset)*fs-1))
title('2nd Stage Ignition (E)')
yline(0)
xl = xlabel(t,'Time (s)')
xl.FontName = 'Times New Roman';
xl.FontSize = 22;
yl = ylabel(t,'Amplitude (Pa)')
yl.FontName = 'Times New Roman';
yl.FontSize = 22;
t.TileSpacing = 'compact';
t.Padding = 'compact';