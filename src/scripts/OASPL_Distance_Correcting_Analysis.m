
%% OASPL Comparison Script with Distance Correction
% Compares OASPLs using strucuted variables (structs) containing
% OASPLs from measurement sites created using the Falcon_9_Analysis
% script.

plotStyle('StandardStyle','custom','FontStyle','classic','FontSize',22,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','square','PlotSize','medium')
%%

tStart = 0
tEnd = 120;%476;

tiled = 0;

addpath('E:\Rocket Noise\Falcon 9')
data_path = 'E:\Rocket Noise\Falcon 9\';
% I7_NF = open(fullfile([data_path,'IRIDIUM 7\North Field\MAT Files\','IRIDIUM 7_North Field CH0 378A07_COUGAR_OASPL.mat']));
% I7_WF1 = open(fullfile([data_path,'IRIDIUM 7\West Field 1\MAT Files\','IRIDIUM 7_West Field 1 CH0 378A07_COUGAR_OASPL.mat']));
% I7_WF2 = open(fullfile([data_path,'IRIDIUM 7\West Field 2\MAT Files\','IRIDIUM 7_West Field 2 CH0 378A07_COUGAR_OASPL.mat']));
% S1A_NF = open(fullfile([data_path,'SAOCOM 1A\North Field\MAT Files\','SAOCOM 1A_North Field CH3 378A07_COUGAR_OASPL.mat']));
% S1A_WF = open(fullfile([data_path,'SAOCOM 1A\West Field\MAT Files\','SAOCOM 1A_West Field CH4 378A07_COUGAR_OASPL.mat']));
% RC_NF = open(fullfile([data_path,'RADARSAT Constellation\North Field\MAT Files\','RADARSAT Constellation_North Field CH9 378A07_COUGAR_OASPL.mat']));
% RC_WF = open(fullfile([data_path,'RADARSAT Constellation\West Field\MAT Files\','RADARSAT Constellation_West Field CH0 378A07_COUGAR_OASPL.mat']));
% RC_EF = open(fullfile([data_path,'RADARSAT Constellation\East Field\MAT Files\','RADARSAT Constellation_East Field CH0 378A07_COUGAR_OASPL.mat']));
% RC_MG = open(fullfile([data_path,'RADARSAT Constellation\Miguelito\MAT Files\','RADARSAT Constellation_Miguelito CH0 378A07_COUGAR_OASPL.mat']));

I7_NF_Plot = 0;
I7_WF1_Plot = 0;
I7_WF2_Plot = 0;
S1A_NF_Plot = 0;
S1A_WF_Plot = 0;
RC_NF_Plot = 1;
RC_WF_Plot = 1;
RC_EF_Plot = 1;
RC_MG_Plot = 1;

numPlots = I7_NF_Plot + I7_WF1_Plot + I7_WF2_Plot + S1A_NF_Plot + S1A_WF_Plot + RC_NF_Plot + RC_WF_Plot + RC_EF_Plot + RC_MG_Plot;

%% Load in 1-s Time Coorelated Altitude and Downrange Distance Matrix
f9IntParams = importdata('f9IntParams.mat');
f9AltAndDRD = importdata('f9AltAndDRD.mat');
% Row 1: Correlated T+ Time (1s Resolution)
% Row 3: Downrange Distance (m)
% Row 2: Altitude (m)
[t0] = f9AltAndDRD(1,:);
[a] = f9AltAndDRD(2,:);
[d] = f9AltAndDRD(3,:);
c = 330;
d0 = 2.76; % Equivalent single-nozzle diameter of Falcon 9, m.
r0 = 6565;%100*d0; % Common distance (in m) to correct for spherical spreading
%%
if tiled == 1
    switch numPlots
        case 1
            ax = figure
        case 2
            ax = tiledlayout(1,2)
        case 3
            ax = tiledlayout(1,3)
        case 4
            ax = tiledlayout(2,2)
        case {5,6}
            ax = tiledlayout(2,3)
        case {7,8}
            ax = tiledlayout(2,4)
        case 9
            ax = tiledlayout(3,3)
    end
else
    figure 
    hold on
    labels = string.empty;
end
%%

if I7_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,1); % Radius from launch complex to measurement location
    theta = f9IntParams(7,1); % Angle from launch complex to measurement location, relative true North
    [t,a,distToRocket,~,~] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('IRIDIUM 7','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL)
    if tiled == 1
        title('IRIDIUM 7 NEXT North Field')
    else
        labels(length(labels) + 1) = "IRIDIUM 7 NEXT North Field";
    end
end
if I7_WF1_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,2); % Radius from launch complex to measurement location
    theta = f9IntParams(7,2); % Angle from launch complex to measurement location, relative true North
    [t,a,distToRocket,~,~] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('IRIDIUM 7','West Field 1','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL)
    if tiled == 1
        title('IRIDIUM 7 NEXT West Field 1')
    else
        labels(length(labels) + 1) = "IRIDIUM 7 NEXT West Field 1";
    end
end
if I7_WF2_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,3); % Radius from launch complex to measurement location
    theta = f9IntParams(7,3); % Angle from launch complex to measurement location, relative true North
    [t,a,distToRocket,~,~] = getRocketTrajectory('IRIDIUM 7','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('IRIDIUM 7','West Field 2','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL)
    if tiled == 1
        title('IRIDIUM 7 NEXT West Field 2')
    else
        labels(length(labels) + 1) = "IRIDIUM 7 NEXT West Field 2";
    end
end
if S1A_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,4); % Radius from launch complex to measurement location
    theta = f9IntParams(7,4); % Angle from launch complex to measurement location, relative true North
    [t,a,distToRocket,~,~] = getRocketTrajectory('SAOCOM 1A','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('SAOCOM 1A','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL)
    if tiled == 1
        title('SAOCOM 1A North Field')
    else
        labels(length(labels) + 1) = "SAOCOM 1A North Field";
    end
end
if S1A_WF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,5); % Radius from launch complex to measurement location
    theta = f9IntParams(7,5); % Angle from launch complex to measurement location, relative true North
    [t,a,distToRocket,~,~] = getRocketTrajectory('SAOCOM 1A','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('SAOCOM 1A','West Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL)
    if tiled == 1
        title('SAOCOM 1A West Field')
    else
        labels(length(labels) + 1) = "SAOCOM 1A West Field";
    end
end
%%
arp = struct;
ta = struct;
if RC_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,6); % Radius from launch complex to measurement location
    theta = f9IntParams(7,6); % Angle from launch complex to measurement location, relative true North
    [ta.NF,a,distToRocket,~,arp.NF,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('RADARSAT Constellation','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL,'-o','MarkerIndices',1:10:length(OASPL),'MarkerSize',8)
    if tiled == 1
        title('RADARSAT Constellation North Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation North Field";
    end
end
%%
if RC_WF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,7); % Radius from launch complex to measurement location
    theta = f9IntParams(7,7); % Angle from launch complex to measurement location, relative true North
    [ta.WF,a,distToRocket,~,arp.WF,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('RADARSAT Constellation','West Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL,'-s','MarkerIndices',1:10:length(OASPL),'MarkerSize',8)
    if tiled == 1
        title('RADARSAT Constellation West Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation West Field";
    end
end
if RC_EF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,8); % Radius from launch complex to measurement location
    theta = f9IntParams(7,8); % Angle from launch complex to measurement location, relative true North
    [ta.EF,a,distToRocket,~,arp.EF,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('RADARSAT Constellation','East Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL,'-*','MarkerIndices',1:10:length(OASPL),'MarkerSize',8)
    if tiled == 1
        title('RADARSAT Constellation East Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation East Field";
    end
end
if RC_MG_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    %% True Distance To Source Calculation
    r = f9IntParams(5,9); % Radius from launch complex to measurement location
    theta = f9IntParams(7,9); % Angle from launch complex to measurement location, relative true North
    [ta.MG,a,distToRocket,~,arp.MG,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta,'ZeroPad',5);
    
    data = loadFalcon9Data('RADARSAT Constellation','Miguelito','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    plot(t,OASPL,'-+','MarkerIndices',1:10:length(OASPL),'MarkerSize',8)
    if tiled == 1
        title('RADARSAT Constellation Miguelito')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation Miguelito";
    end
end

% [t,a,distToRocket,~,~] = getRocketTrajectory('IRIDIUM 7',varargin)

if numPlots > 1 && tiled == 1
    xlabel(ax,'Time (s)','Fontlength',22)
    ylabel(ax,'OASPL (dB re 20\muPa)','Fontlength',22)
    title({[ax,'Running OASPL,'], 'Amplitude Corrected for Spherical Spreading'})
else
    xlabel('Time (s)')
    ylabel('OASPL (dB re 20\muPa)')
    title({'Running OASPL,', 'Amplitude Corrected for Spherical Spreading'})
    xlim([tStart-5 tEnd])
    if tiled == 0
        legend(labels,'Location','NorthEast')
    end
end
yyaxis right
hold on
plot(ta.NF(1:end-1),arp.NF,'--o','MarkerIndices',1:10:length(arp.NF),'MarkerSize',8,'Color',[0 0.4470 0.7410])
plot(ta.WF(1:end-1),arp.WF,'--s','MarkerIndices',1:10:length(arp.WF),'MarkerSize',8,'Color',[0.8500 0.3250 0.0980])
plot(ta.EF(1:end-1),arp.EF,'--*','MarkerIndices',1:10:length(arp.EF),'MarkerSize',8,'Color',[0.9290 0.6940 0.1250])
plot(ta.MG(1:end-1),arp.MG,'--d','MarkerIndices',1:10:length(arp.MG),'MarkerSize',8,'Color',[0.4940 0.1840 0.5560])
grid on
box on
% hlgd = gridlegend('RowNames',['NF','WF','EF','MG'],'ColumnNames',['Location','OASPL','Angle re Plume'])
hlgd = gridlegend({"NF","WF","EF","MG"},{"Location","OASPL","Angle re Plume"})
% legend('NF','WF','EF','MG')