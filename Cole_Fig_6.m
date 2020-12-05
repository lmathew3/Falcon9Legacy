%% Reproduction of Cole et al. 1957 Fig 6
plotStyle('FontStyle','classic','FontSize',16,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','widescreen','PlotSize','hd','Orientation','landscape')
addpath('C:\Users\logan\Box\ASA Falcon 9 Analysis\Cole et al. Data')
A = readmatrix('A_130k.csv')';
B = readmatrix('B_130k.csv')';
C = readmatrix('C_100k.csv')';
D = readmatrix('D_78k.csv')';
E = readmatrix('E_48k.csv')';
G = readmatrix('G_10k.csv')';
H = readmatrix('H_5k.csv')';
I = readmatrix('I_1k.csv')';

figure
hold on
scatter(A(1,:),A(2,:),'^','LineWidth',3)
scatter(B(1,:),B(2,:),'x','LineWidth',3)
scatter(C(1,:),C(2,:),'o','LineWidth',3)
scatter(D(1,:),D(2,:),'filled','d','LineWidth',3)
scatter(E(1,:),E(2,:),'filled','v','LineWidth',3)
scatter(G(1,:),G(2,:),'v','LineWidth',3)
scatter(G(1,:),G(2,:),'+','LineWidth',3)
scatter(H(1,:),H(2,:),'d','LineWidth',3)
scatter(I(1,:),I(2,:),'<','LineWidth',3)
% 
% plot(A(1,:),A(2,:),'-^')
% plot(B(1,:),B(2,:),'-x')
% plot(C(1,:),C(2,:),'-o')
% plot(D(1,:),D(2,:),'filled','-d')
% plot(E(1,:),E(2,:),'filled','-v')
% plot(G(1,:),G(2,:),'-v')
% plot(G(1,:),G(2,:),'-+')
% plot(H(1,:),H(2,:),'-d')
% plot(I(1,:),I(2,:),'-<')

legend('A, 130,000 LBS','B, 130,000 LBS','C, 100,000 LBS','D, 78,000 LBS',...
    'E, 48,400 LBS','F, 34,000 LBS','G, 10,000 LBS','H, 5,000 LBS',...
    'I, 1,000 LBS','Location','NorthWest')
xlabel('ANGLE \theta IN DEGREES FROM FORWARD END OF ROCKET')
ylabel('OVERALL SOUND PRESSURE LEVEL IN DB RE 0.00002 DYNES/CM^2')
title('OVERALL SOUND PRESSURE LEVELS AT 250 FT')
grid on
