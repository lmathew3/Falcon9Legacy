%% Run code for I7
plotStyle('FontStyle','classic','FontSize',14,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','medium','Orientation','portrait')
figure
til = tiledlayout(2,1,'TileSpacing','compact','Padding','compact')
xlabel(til,'Effective Sound Speed (m/s)','FontName','Times New Roman',...
    'FontSize',16,'FontWeight','demi')
ylabel(til,'Altitude (km)','FontName','Times New Roman','FontSize',16,...
    'FontWeight','demi')
nexttile
plot(c_tot_NF,grid,'LineWidth',2)
hold on
%% Run code for S1A
plot(c_tot_NF,grid,'--','LineWidth',2)
%% Run code for RC
plot(c_tot_NF,grid,':','LineWidth',2)
hold off
% xlabel('Effective Sound Speed (m/s)')
legend('I7N NF','S1A NF','RC NF')
ylim([0 20])
grid on
%%
nexttile
plot(c_tot_NF,grid,'LineWidth',2)
hold on
plot(c_tot_WF,grid,'--','LineWidth',2)
plot(c_tot_EF,grid,':','LineWidth',2)
plot(c_tot_MG,grid,'-.','LineWidth',2)
hold off

% title({'Atmospheric Soundspeed Profile', [launch,', ',time]})
legend('RC NF','RC WF','RC EF','RC MC')
ylim([0 20])
grid on