plotStyle('StandardStyle','custom','FontStyle','classic','FontSize',22,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','square','PlotSize','medium')
usePackage Falcon9Legacy
addpath('E:\Rocket Noise\Falcon 9')


c = 340;
theta = 0;
[t,a,distToRocket,downrange,arp,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',0,'Angle',theta,'ZeroPad',5);
a = a/1000;
downrange = downrange/1000;
ax = figure;
plot(downrange,a)
ylim([0 60])
xlim([-2 28])
xlabel('Downrange Distance (km)')
ylabel('Altitude (km)')
grid on

arrow1 = annotation('textarrow','String','t = 0 s','FontSize',20,'Color',[0.8500 0.3250 0.0980],'TextColor','k');
arrow1.Parent = ax.CurrentAxes;
arrow1.X = [downrange(0+6)+15 downrange(0+6)];
arrow1.Y = [a(0+6)+10 a(0+6)];

arrow2 = annotation('textarrow','String','t = 0 s','FontSize',20,'Color',[0.9290 0.6940 0.1250],'TextColor','k');
arrow2.Parent = ax.CurrentAxes;
arrow2.X = [downrange(44+6)+10 downrange(44+6)];
arrow2.Y = [a(44+6)+10 a(44+6)];

arrow3 = annotation('textarrow','String','t = 0 s','FontSize',20,'Color',[0.4940 0.1840 0.5560],'TextColor','k');
arrow3.Parent = ax.CurrentAxes;
arrow3.X = [downrange(100+6)+1 downrange(100+6)];
arrow3.Y = [a(100+6)+15 a(100+6)];

arrow4 = annotation('textarrow','String','t = 0 s','FontSize',20,'Color',[0.4660 0.6740 0.1880],'TextColor','k');
arrow4.Parent = ax.CurrentAxes;
arrow4.X = [downrange(300+6)-10 downrange(300+6)];
arrow4.Y = [a(300+6)+1 a(300+6)];