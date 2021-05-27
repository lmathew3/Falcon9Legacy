%% Use in conjunction with Spectrum_Analysis.m
% Run this in the command window
plotStyle('StandardStyle','custom','FontStyle','classic','FontSize',14,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','medium','Orientation','portrait')
figure
til = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
xlabel(til,'Frequency (Hz)','FontName','Times New Roman',...
    'FontSize',16,'FontWeight','demi')
ylabel(til,'SPL (dB re 20\muPa)','FontName','Times New Roman','FontSize',16,...
    'FontWeight','demi')
til1 = nexttile;
hold on
[ind] = fracOctMarkerIndices(fc,[fmin fmax],1);

%% Then run Spectrum_Analysis.m for the first condition
tStart = 36;
tEnd = 44;
%% Then run this in the command window
grid on
set(gca, 'XScale', 'log')
xlim([fmin fmax])
ylim([20 110])
xticks([1e0, 1e1, 1e2, 1e3, 1e4])
box on
legend('NF','WF','EF','MC','Location','South')
NF.Marker = 'o';
NF.MarkerSize = 8;
NF.MarkerIndices = ind;
WF.Marker = 's';
WF.MarkerSize = 8;
WF.MarkerIndices = ind;
EF.Marker = 'd';
EF.MarkerSize = 8;
EF.MarkerIndices = ind;
MG.Marker = '^';
MG.MarkerSize = 8;
MG.MarkerIndices = ind;
annotation('textbox',[0.8 0.85 0.1 0.1],'String','(a)','FontName','Times New Roman','FontSize',26,'FontWeight','demi','EdgeColor','none')
til2 = nexttile;
hold on
%% Then run Spectrum_Analysis.m for the second condition
tStart = 56;
tEnd = 64;
%% Then run this in the command window
grid on
set(gca, 'XScale', 'log')
xlim([fmin fmax])
ylim([20 110])
xticks([1e0, 1e1, 1e2, 1e3, 1e4])
box on
NF.Marker = 'o';
NF.MarkerSize = 8;
NF.MarkerIndices = ind;
WF.Marker = 's';
WF.MarkerSize = 8;
WF.MarkerIndices = ind;
EF.Marker = 'd';
EF.MarkerSize = 8;
EF.MarkerIndices = ind;
MG.Marker = '^';
MG.MarkerSize = 8;
MG.MarkerIndices = ind;
annotation('textbox',[0.8 0.375 0.1 0.1],'String','(b)','FontName','Times New Roman','FontSize',26,'FontWeight','demi','EdgeColor','none')
%%
savePlots('titles',"Figure11",'fileTypes',"svg")
