plotStyle('StandardStyle','custom','FontStyle','classic','FontSize',24,'LineWidth',2,'ColorScheme',1,'AspectRatio','square','PlotSize','medium')
addpath('E:\Rocket Noise\Falcon 9\Elevation Profiles')
NFWF = readmatrix('NF_WF_Extended_Elevation_Profile.csv');
EF = readmatrix('EF_Extended_Elevation_Profile.csv');
MIG = readmatrix('MIG_Extended_Elevation_Profile.csv');

figure
plot(NFWF(:,1)/1000,NFWF(:,2),'-o','MarkerIndices',1:30:length(NFWF(:,1)),'MarkerSize',9)
hold on
plot(EF(:,1)/1000,EF(:,2),'-s','MarkerIndices',1:30:length(EF(:,1)),'MarkerSize',9)
plot(MIG(:,1)/1000,MIG(:,2),'-d','MarkerIndices',1:30:length(MIG(:,1)),'MarkerSize',9)
s = scatter(0,158,400,'*','LineWidth',2)
xlabel('Radial Distance (km)')
ylabel('Elevation (m)')
legend('NF/WF','EF','MC','Launch Complex','Location','NorthWest')
xlim([0 16])
xticks([0:3:16])
grid on