plotStyle('FontStyle','classic','FontSize',16,'ColorScheme',1,'AspectRatio','square','PlotSize','small','Orientation','portrait')
LIN = 6;
load('f9NameParams.mat')
load('f9IntParams.mat')
launch = f9NameParams(1,LIN); % Select Launch
location = f9NameParams(2,LIN); % Select Location;
r0 = f9IntParams(5,LIN); % Radius from launch complex to measurement location
theta = f9IntParams(7,LIN); % Angle from launch complex to measurement location, relative true North

[t,a,distToRocket,downrangeFromSite,angleRelativePlume] = getRocketTrajectory(launch,'SoundSpeed',340,'DistFromPad',0,'Angle',0,'ZeroPad',0);
d = downrangeFromSite./1000;
a = a./1000;
figure
plot(d,a)
xlabel('Downrange Distance (km)')
ylabel('Altitude (km)')
xlim([d(1)-2 d(310)])
grid on
zero = d(1)/d(310)
% annotation('textarrow',[d(1)/d(310),d(1)/d(310)+0.2],[a(1)/a(310),a(1)/a(310)+0.2],'String','T = 0 s')
% annotation('textarrow',x,y,'String','T = 42 s')
% annotation('textarrow',x,y,'String','T = 100 s')
% annotation('textarrow',x,y,'String','T = 300 s')
