plotStyle('FontStyle','classic','FontSize',22,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','hd','Orientation','portrait')
figure
data_path = 'F:\ASA Falcon 9 Analysis\';
til = tiledlayout(2,1)
nexttile
r = f9IntParams(5,7); % Radius from launch complex to measurement location
theta = f9IntParams(7,7); % Angle from launch complex to measurement location, relative true North
[t_traj,a,distToRocket,~,angleRelativePlume] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
data = loadFalcon9Data('RADARSAT Constellation','West Field','OASPL',data_path);
t = data.OASPLData.t;
OASPL = data.OASPLData.OASPL;
OASPLcorr = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./distToRocket(1));
plot(t,OASPL,t,OASPLcorr)
xlim([-5 350])
grid on
xlabel('Time (s)')
ylabel('OASPL (dB re 20\muPa)')
xticks([0:50:350])

[t,a,distToRocket,~,angleRelativePlume] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
colororder({'#7E2F8E'})
yyaxis right
plot(t(1:end-1),angleRelativePlume,'Color','#7E2F8E')
ylim([-10 100])
ylabel('Angle re Plume (Degrees)','Color','#7E2F8E','FontSize',18)
legend('Measured','Corrected','Angle re Plume','Location','NorthEast')

colororder({'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30'})
nexttile
semilogx(fc,totalSpec,'LineWidth',2);
grid on
xlim([fmin fmax])
xlabel('Frequency (Hz)')
ylabel('SPL (dB re 20\muPa)')
legend('Ambient','I','II','III','IV','Location','NorthEast')
xlim([1 20000])
xticks([1e0,1e1,1e2,1e3,1e4])

til.TileSpacing = 'compact';
til.Padding = 'compact';