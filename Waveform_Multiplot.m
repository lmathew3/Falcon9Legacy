clear; clc; close all;
path = 'C:\Users\logan\Box\ASA Falcon 9 Analysis\RADARSAT Constellation\North Field\Data';
plotStyle('square','medium',2,2,26,'classic')

%% Parameters
IDnum = 100;
pref = 2e-5;
fs = 102400;
dt = 1/fs;
t_offset = 58;
times = [0+t_offset,38+t_offset,350+t_offset,433+t_offset,49];
spec_duration = 8;
third_octave_multiplot = 1;
fmin = 0.5;
fmax = 20000;
fHighPass = 0.5;
highPass =1;

%% Run Calculations
x = transpose(binfileload(path,'ID',IDnum,9));

if third_octave_multiplot == 1
    for i = 1:length(times)
        % Autospectrum
        [multiGxx(i,:),f,~] = autospec(x((times(i)*fs):(times(i) + spec_duration)*fs -1),fs,fs*4,spec_duration*fs);
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
legend('Ignition Overpressure (A)','Peak Directivity (B)','Late Launch (C)','2nd Stage Ignition (E)','Ambient','Location','SouthEast')
title('One-Third Octave Band Spectra')
xlim([1 20000])
ylim([-30 120])

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