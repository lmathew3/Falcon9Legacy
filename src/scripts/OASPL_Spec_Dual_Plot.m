plotStyle('FontStyle','classic','FontSize',22,'LineWidth',2,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','large','Orientation','portrait')
figure
data_path = 'E:\ASA Falcon 9 Analysis\';
c = 340;
til = tiledlayout(2,1)
nexttile
r = f9IntParams(5,7); % Radius from launch complex to measurement location
theta = f9IntParams(7,7); % Angle from launch complex to measurement location, relative true North
[t_traj,a,distToRocket,~,angleRelativePlume] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);

data = loadFalcon9Data('RADARSAT Constellation','West Field','OASPL',data_path);
t = data.OASPLData.t;
OASPL = data.OASPLData.OASPL;
OASPLcorr = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./distToRocket(1));
plot(t,OASPL,'-k',t,OASPLcorr,'-r')
xlim([-10 350])
grid on
xlabel('Time (s)')
ylabel('OASPL (dB re 20\muPa)')
xticks([0:50:350])
ylim([50 120])

[t,a,distToRocket,~,angleRelativePlume] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
colororder({'#7E2F8E'})
yyaxis right
plot(t(1:end-1),angleRelativePlume,'--','Color','#808080')
ax = gca;
ax.YColor = '#808080';
ylim([-10 100])
ylabel('Angle re Plume (Degrees)','Color','#808080','FontSize',18)
legend('Measured','Corrected','Angle re Plume','Location','NorthEast','FontSize',18)

[ind] = FracOctMarkerIndices(fc,[1 20000],1);

colororder({'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30'})
nexttile
semilogx(fc,totalSpec(1,:),'LineWidth',2)
hold on
plot(fc,totalSpec(2,:),'-o','MarkerIndices',ind,'MarkerSize',10)
semilogx(fc,totalSpec(3,:),'-s','MarkerIndices',ind,'MarkerSize',10)
semilogx(fc,totalSpec(4,:),'-d','MarkerIndices',ind,'MarkerSize',10)
semilogx(fc,totalSpec(5,:),'-x','MarkerIndices',ind,'MarkerSize',10)
hold off
grid on
xlim([fmin fmax])
xlabel('Frequency (Hz)')
ylabel('SPL (dB re 20\muPa)')
legend(['Amb, ',sprintf('%0.0f',OASPLs(1)),' dB'],...
    ['a, ',sprintf('%0.0f',OASPLs(2)),' dB'],...
    ['b, ',sprintf('%0.0f',OASPLs(3)),' dB'],...
    ['c, ',sprintf('%0.0f',OASPLs(4)),' dB'],...
    ['d, ',sprintf('%0.0f',OASPLs(5)),' dB'],...
    'Location','northeast','FontSize',18)
xlim([1 20000])
ylim([20 110])
xticks([1e0,1e1,1e2,1e3,1e4])

til.TileSpacing = 'compact';
til.Padding = 'compact';