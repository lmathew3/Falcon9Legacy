plotStyle('FontStyle','classic','FontSize',22,'LineWidth',2,'ColorScheme',1,'AspectRatio','standard','PlotSize','medium')
addpath('E:/ASA Falcon 9 Analysis/Elevation Profiles')
NFWF = readmatrix('NF_WF_Extended_Elevation_Profile.csv');
EF = readmatrix('EF_Extended_Elevation_Profile.csv');
MIG = readmatrix('MIG_Extended_Elevation_Profile.csv');

figure
plot(NFWF(:,1),NFWF(:,2),'-o','MarkerIndices',1:30:length(NFWF(:,1)),'MarkerSize',9)
hold on
plot(EF(:,1),EF(:,2),'-s','MarkerIndices',1:30:length(EF(:,1)),'MarkerSize',9)
plot(MIG(:,1),MIG(:,2),'-d','MarkerIndices',1:30:length(MIG(:,1)),'MarkerSize',9)
scatter(0,158,'*','LineWidth',3)
xlabel('Radial Distance (m)')
ylabel('Elevation (m)')
legend('North/West Field','East Field','Miguelito','Launch Complex','Location','NorthWest')
xlim([0 16000])
xticks([0:3000:16000])
grid on