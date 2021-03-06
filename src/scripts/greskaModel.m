% plotStyle('FontStyle','classic','FontSize',22,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','standard','PlotSize','medium','Orientation','landscape')
plotStyle('FontStyle','classic','FontSize',16,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','square','PlotSize','small','Orientation','landscape')
addpath('C:\Users\logan\Box\ASA Falcon 9 Analysis\JASA Falcon 9 Paper');
addpath('E:\ASA Falcon 9 Analysis\Greska Curves');
%%
% Mc = [0.4, 0.426, 0.441, 0.465, 0.485, 0.513, 0.539, 0.554, 0.586, ...
%   0.602, 0.621, 0.638, 0.656, 0.68, 0.708, 0.74, 0.771, 0.799, 0.821, ...
%   0.846, 0.883, 0.909, 0.948, 0.974, 1.011, 1.052, 1.107, 1.159, 1.2, ...
%   1.267, 1.31, 1.47, 1.386, 1.536, 1.596, 1.655, 1.716, 1.772, 1.828, ...
%   1.885, 1.943, 2.004, 2.064, 2.116, 2.16, 2.223, 2.277, 2.338, 2.396, ...
%    2.446, 2.5];
% OASPL = [65.0, 68.642, 71.629, 75.271, 78.439, 82.737, 86.191, ...
%    88.431, 91.697, 93.937, 95.898, 97.67, 99.728, 101.78, 105.234, ...
%   107.753, 110.837, 113.258, 115.128, 117.459, 119.887, 122.594, ...
%   125.392, 127.542, 129.223, 130.437, 131.652, 132.866, 133.982, ...
%   135.106, 136.222, 137.715, 137.066, 138.371, 139.118, 139.585, ...
%   140.053, 140.143, 140.799, 141.267, 141.546, 142.104, 142.383, ...
%   142.572, 143.039, 143.318, 143.597, 143.974, 144.344, 144.532, 145];
data = readmatrix('GreskaCurves.csv');
data = sort(data);
Mc = data(:,1);
OASPL = data(:,2);

data = readmatrix('newModel.csv');
data = sort(data);
Mcnew = data(:,1);
OASPLnew = data(:,2);

figure
plot(Mc,OASPL,'-.')
grid on

% Approximate Falcon 9 Parameters
Mc_min = 2.8;
Mc_max = 2.9;
M = 0.55;
Mc = (Mc_min + Mc_max)/2;
Mceff = Mc-M;
OASPL_100d = [141.7 141.5 143.1 143.1 143.4 143.4 143.4 144.7];
avg = mean(OASPL_100d);
err = std(OASPL_100d);
hold on
% plot(Mcnew,OASPLnew)
% errorbar(Mc,avg,err,err,Mc-Mc_min,Mc_max-Mc,'o','LineWidth',1.5)

% scatter([0.423, 0.428, 0.432, 0.451, 0.442, 0.454, 0.454, 0.459, 0.462, 0.503,...
%    0.5, 0.491, 0.491, 0.503, 0.501, 0.532, 0.533, 0.533, 0.554, 0.549,...
%    0.575, 0.603, 0.59, 0.569, 0.576, 0.607, 0.603, 0.616, 0.631, ...
%   0.655, 0.654, 0.648, 0.637, 0.676, 0.654, 0.664, 0.705, 0.711, ...
%   0.747, 0.731, 0.763, 0.775, 0.798, 0.804, 0.785, 0.825, 0.865, ...
%   0.854, 0.842, 0.83, 0.856, 0.892, 0.924, 0.961, 0.975, 1.017, 1.019,...
%    1.05, 1.065, 1.115, 1.152, 1.188, 1.246, 1.341, 1.304], [69.192, ...
%   71.331, 72.608, 72.733, 74.604, 75.763, 76.731, 77.569, 78.086, ...
%   80.474, 81.371, 82.405, 83.373, 83.955, 84.793, 90.591, 89.433, ...
%   88.464, 88.274, 87.757, 95.748, 94.393, 94.334, 94.524, 93.3, ...
%   98.201, 99.425, 98.974, 98.843, 100.001, 99.425, 101.938, 102.776, ...
%   103.423, 103.358, 103.81, 104.647, 105.485, 110.19, 112.061, ...
%   111.414, 112.965, 114.123, 115.281, 116.184, 116.701, 119.024, ...
%   119.084, 119.149, 119.28, 119.987, 122.244, 125.143, 127.401, ...
%   127.597, 128.821, 129.593, 131.464, 131.209, 131.078, 134.429, ...
%   132.171, 132.171, 133.205, 136.425],100,'s','MarkerEdgeColor','k','LineWidth',1.5)
% scatter([1.101, 1.253, 1.39, 1.454, 1.522, 1.588, 1.617], [133.249, 135.21,...
% 135.234, 137.136, 137.903, 137.291, 136.15],100,'d','filled','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',1.5)
% scatter([0.999, 1.004, 1.036, 1.064, 1.069, 1.121, 1.119, 1.109, 1.137,...
% 1.163, 1.177, 1.178, 1.212, 1.226, 1.253, 1.236, 1.281, 1.281, 1.309,...
% 1.335, 1.329, 1.347, 1.375, 1.376, 1.397, 1.406, 1.421, 1.425, 1.458,...
% 1.484, 1.516, 1.534], [127.546, 128.555, 128.644, 131.801, 130.318,...
% 130.513, 131.671, 132.834, 131.03, 131.416, 132.122, 133.155,...
% 132.769, 132.769, 133.541, 134.573, 134.312, 135.927, 136.764,...
% 136.888, 135.41, 136.372, 137.405, 136.182, 136.437, 135.6, 136.051,...
% 136.568, 137.019, 137.215, 137.215, 137.274],100,'o','MarkerEdgeColor','b','LineWidth',1.5)
scatter([2.129, 2.405, 2.391, 2.237], [141.987, 141.987, 143.116, 142.581],100,'^','MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',1.5)
errorbar(Mceff,avg,err,err,Mceff-Mc_min+M,Mc_max-Mceff-M,'o','LineWidth',1.5)
scatter(2.30,142,160,'*','MarkerEdgeColor','y','LineWidth',1.5)
legend('Greska Curve','Suggested Fit for M_c > 1.3','Falcon 9 (2018-19)','Tanna et al (1976)','Seiner et al (1992)','Greska (2005)','Rocket Data (1963)','SRB','Location','SouthEast')
legend('Greska et al. Curve','Rocket Data (1963)','Falcon 9 Effective','RSRM (2009)','Location','SouthEast')
xlim([0.8 2.6])
xlabel('M_c')
ylabel('OASPL (dB re 20\muPa)')
ylim([125 146])
xticks([0.4:0.1:3])
yticks([70:10:150])

% title('OASPL at 100D, Greska et al. Model with Falcon 9 Data')
% set(gca, 'XScale', 'log')
%%
% 
% cftool(Mc,OASPL)
% pause;
data = readmatrix('All_Curves.csv');
data = sort(data);
Mc = data(:,1);
OASPL = data(:,2);

data = readmatrix('Suggested_Fit.csv');
data = sort(data);
Mcnew = data(:,1);
OASPLnew = data(:,2);

figure
plot(Mc,OASPL,'-.')
grid on

% Approximate Falcon 9 Parameters
M = 0.55;
Mc = 2.81;
Mceff = Mc-M;
OASPL_100d = [141.7 141.5 143.1 143.1 143.4 143.4 143.4 144.7];
avg = mean(OASPL_100d);
err = std(OASPL_100d);
hold on
% plot(Mcnew,OASPLnew)
% errorbar(Mc,avg,err,err,'o','LineWidth',1.5)
scatter([2.129, 2.405, 2.391, 2.237], [141.987, 141.987, 143.116, 142.581],100,'^','MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',1.5)
errorbar(Mceff,avg,err,err,'o','LineWidth',1.5)
scatter(2.30,142,160,'*','MarkerEdgeColor','y','LineWidth',1.5)
legend('Greska et al.','Rocket Data (1963)','Falcon 9 Eff. (M_{co}-M)','RSRM (2009)','Location','SouthEast')
xlabel('M_co')
ylabel('OASPL (dB re 20\muPa)')
xticks([0.4:0.2:3])
yticks([125:5:145])
xlim([0.8 2.6])
ylim([125 146])
% title('OASPL at 100D, Greska et al. Model with Falcon 9 Data')
% set(gca, 'XScale', 'log')
