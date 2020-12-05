%% IOP Delays
% I7 NF: 52.23
% S1A NF: 63.61
% RC NF: 57.72
%
% RC WF: 52.04
% RC EF: 51.47
% RC MIG: 25.76
%
%% Code
% plotStyle('standard','medium',3,1.75,22,'classic')

set(0,'DefaultAxesFontName','Arial');

set(0,'DefaultAxesFontSize',10);

set(0,'DefaultTextFontSize',10);

set(0,'DefaultAxesFontWeight','demi');

set(0,'DefaultAxesLineWidth',1);

set(0,'DefaultLineLineWidth',1);

set(0,'DefaultLineMarkersize',4);

set(0,'DefaultFigureUnits','inches');

set(0,'DefaultFigurePosition',[1.5 1.5 4.5 4]);

set(0,'DefaultAxesGridLineStyle',':');

set(0,'DefaultFigureColor', [1,1,1]);

colvect=[0,0,0; 1,0,0; 0,0,1; 0,.8,0;.7,.3,.3;.9,.7,.1;];  % black,

%red, blue, dark green, brown, dark yellow

set(0,'DefaultAxesColorOrder',colvect);

set(0,'DefaultAxesLineStyleOrder',{'-','--'});  %plots all solid lines, and then dashed

 

 

 

 


cd 'C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files'
I7OASPL = open('IRIDIUM 7_North Field CH0 378A07_COUGAR_OASPL_DATA.mat');
S1AOASPL = open('SAOCOM 1A_North Field CH0 378A07_COUGAR_OASPL_DATA.mat');
RCOASPL = open('RADARSAT Constellation_North Field CH9 378A07_COUGAR_OASPL_DATA.mat');

save_figs = 0;

figure

plot(I7OASPL.OASPLData.t(1:end-50),I7OASPL.OASPLData.OASPL(51:end),S1AOASPL.OASPLData.t(1:end-62),S1AOASPL.OASPLData.OASPL(63:end),RCOASPL.OASPLData.t(1:end-56),RCOASPL.OASPLData.OASPL(57:end),'LineWidth',2.5)
grid on
ylabel('OASPL (dB re 20\muPa)')
xlabel('Time (s)')
xlim([0 475])
yyaxis right
plot(propogatedTime-dt0,angleRelativePlume)
ylabel('Angle re Plume (Degrees)')
legend('IRIDIUM 7 NEXT','SAOCOM 1A','RADARSAT Constellation','Angle re Plume')
% title({'OASPL Across Launches','at North Field Location'})

print(gcf,'Falcon9','-dtiff','-r600');
% if save_figs == 1
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 North Field Site OASPL Comparison.svg'))
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 North Field Site OASPL Comparison.png'))
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 North Field Site OASPL Comparison.fig'))
% end
% 
% NFOASPL = open('RADARSAT Constellation_North Field CH9 378A07_COUGAR_OASPL_DATA.mat');
% WFOASPL = open('RADARSAT Constellation_West Field CH0 378A07_COUGAR_OASPL_DATA.mat');
% EFOASPL = open('RADARSAT Constellation_East Field CH0 378A07_COUGAR_OASPL_DATA.mat');
% MOASPL = open('RADARSAT Constellation_Miguelito CH0 378A07_COUGAR_OASPL_DATA.mat');
% 
% figure
% plot(NFOASPL.OASPLData.t(1:end-56),NFOASPL.OASPLData.OASPL(57:end),WFOASPL.OASPLData.t(1:end-51),WFOASPL.OASPLData.OASPL(52:end),EFOASPL.OASPLData.t(1:end-50),EFOASPL.OASPLData.OASPL(51:end),MOASPL.OASPLData.t(1:end-24),MOASPL.OASPLData.OASPL(25:end),'LineWidth',2.5)
% grid on
% % xline(6.2,'Label','North and West Field LofS','LabelHorizontalAlignment','left','LineWidth',2,'FontSize',14,'Color','r')
% % xline(8.5,'Label','East Field LofS','LineWidth',2,'FontSize',14,'Color','r')
% % xline(40.5,'Label','Miguelito LofS','LineWidth',2,'FontSize',14,'Color','r','LabelVerticalAlignment','bottom')
% title('RADARSAT Constellation Launch')
% legend('North Field','West Field','East Field','Miguelito')
% ylabel('OASPL (dB re 20\muPa)')
% xlabel('Time (s)')
% xlim([0 440])
% set(gca,'fontsize', 22)
% set(gcf,'Position',[0 0 800 600])

% 
% if save_figs == 1
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 RADARSAT Site OASPL Comparison.svg'))
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 RADARSAT Site OASPL Comparison.png'))
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 RADARSAT Site OASPL Comparison.fig'))
% end
% 
% figure
% plot(I7OASPL.OASPLData.t(1:end-50),I7OASPL.OASPLData.OASPL(51:end),'LineWidth',2.5)
% grid on
% ylabel('OASPL (dB re 20\muPa)')
% xlabel('Time (s)')
% xlim([0 475])
% % xline(392,'Label','Approximated Cutoff','LineWidth',2,'FontSize',24,'Color','r')
% % xline(459,'Label','Approximated Second Stage Ignition','LineWidth',2,'FontSize',24,'Color','r')
% set(gca,'fontsize', 22)
% set(gcf,'Position',[0 0 800 600])
% 
% if save_figs == 1
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 IRIDIUM 7 Second Stage OASPL.svg'))
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 IRIDIUM 7 Second Stage OASPL.png'))
%     saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 IRIDIUM 7 Second Stage OASPL.fig'))
% end
% 
% NFOASPL = open('RADARSAT Constellation_North Field CH9 378A07_COUGAR_OASPL_DATA.mat');
% WFOASPL = open('RADARSAT Constellation_West Field CH0 378A07_COUGAR_OASPL_DATA.mat');
% EFOASPL = open('RADARSAT Constellation_East Field CH0 378A07_COUGAR_OASPL_DATA.mat');
% MOASPL = open('RADARSAT Constellation_Miguelito CH0 378A07_COUGAR_OASPL_DATA.mat');