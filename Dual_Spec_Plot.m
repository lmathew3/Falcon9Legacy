%% Use in conjunction with Spectrum_Analysis.m
% Run this in the command window
plotStyle('FontStyle','classic','FontSize',14,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','medium','Orientation','portrait')
figure
til = tiledlayout(2,1,'TileSpacing','compact','Padding','compact')
xlabel(til,'Frequency (Hz)','FontName','Times New Roman',...
    'FontSize',16,'FontWeight','demi')
ylabel(til,'SPL (dB re 20\muPa)','FontName','Times New Roman','FontSize',16,...
    'FontWeight','demi')
nexttile
hold on

%% Then run Spectrum_Analysis.m for the first condition

%% Then run this in the command window
grid on
set(gca, 'XScale', 'log')
xlim([fmin fmax])
ylim([20 120])
xticks([1e0, 1e1, 1e2, 1e3, 1e4])
box on
legend('NF','WF','EF','MG','Location','South')
nexttile
hold on
%% Then run Spectrum_Analysis.m for the second condition
%% Then run this in the command window
grid on
set(gca, 'XScale', 'log')
xlim([fmin fmax])
ylim([20 120])
xticks([1e0, 1e1, 1e2, 1e3, 1e4])
box on

%%
[ind]=FracOctMarkerIndices(fc,[fmin fmax],1)