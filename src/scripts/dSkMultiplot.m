cd 'C:\Users\logan\Box\ASA Falcon 9 Analysis\MAT Files'
I7dSk = open('IRIDIUM 7_North Field CH0 378A07_COUGAR_dSk as a Function of Time_DATA.mat');
S1AdSk = open('SAOCOM 1A_North Field CH0 378A07_COUGAR_dSk as a Function of Time_DATA.mat');
RCdSk = open('RADARSAT Constellation_North Field CH9 378A07_COUGAR_dSk as a Function of Time_DATA.mat');

NFdSk = open('RADARSAT Constellation_North Field CH9 378A07_COUGAR_dSk as a Function of Time_DATA.mat');
WFdSk = open('RADARSAT Constellation_West Field CH0 378A07_COUGAR_dSk as a Function of Time_DATA.mat');
EFdSk = open('RADARSAT Constellation_East Field CH0 378A07_COUGAR_dSk as a Function of Time_DATA.mat');
MIGdSk = open('RADARSAT Constellation_Miguelito CH0 378A07_COUGAR_dSk as a Function of Time_DATA.mat');

save_figs = 0;
fs = 10000;
dt = 1/fs

Modern_Plots


% offsetTimes = [52.23,63.61,57.72];
% for i = 1:3
%     switch i
%         case 1
%             newdSk(i,:) = I7dSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
%         case 2
%             newdSk(i,:) = S1AdSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
%         case 3
%             newdSk(i,:) = RCdSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
%     end
% end

offsetTimes = [58,52,51,22];
for i = 1:4
    switch i
        case 1
            newdSk(i,:) = NFdSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
        case 2
            newdSk(i,:) = WFdSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
        case 3
            newdSk(i,:) = EFdSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
        case 4
            newdSk(i,:) = MIGdSk.dSkData.dSk(offsetTimes(i):offsetTimes(i) + 200);
    end
end

figure
[rows,columns] = size(newdSk);
t = 1:1:columns;
plot(t,newdSk,'Linewidth',2.5)
grid on
xlim([0 150])
xlabel('Time (s)')
ylabel('dSk (Sk[\partial p/\partial t])')
% legend('North Field','West Field','East Field','Miguelito')
legend('IRIDIUM 7 NEXT','SAOCOM 1A','RADARSAT Constellation')
set(gcf,'Position',[0 0 800 600])
set(gca,'fontsize', 22)

if save_figs == 1
    saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 North Field dSk Comparison.svg'))
    saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 North Field dSk Comparison.png'))
    saveas(gcf,fullfile(['C:\Users\logan\Box\ASA Falcon 9 Analysis\'],'Falcon 9 North Field dSk Comparison.fig'))
end