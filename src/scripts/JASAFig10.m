
%% OASPL Comparison Script with Distance Correction
% Compares OASPLs using strucuted variables (structs) containing
% OASPLs from measurement sites created using the Falcon_9_Analysis
% script.

plotStyle('StandardStyle','custom','FontStyle','classic','FontSize',24,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','square','PlotSize','medium')
%%
usePackage Falcon9Legacy
usePackage MatlabPlotting

tStart = 0;
tEnd = 100;

tiled = 0;

addpath('E:\Rocket Noise\Falcon 9')
data_path = 'E:\Rocket Noise\Falcon 9\';

RC_NF_Plot = 1;
RC_WF_Plot = 1;
RC_EF_Plot = 1;
RC_MG_Plot = 1;

numPlots = RC_NF_Plot + RC_WF_Plot + RC_EF_Plot + RC_MG_Plot;

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
r0 = 13685;%6565;%100*d0; % Common distance (in m) to correct for spherical spreading

ax = figure;
hold on
       
arp = struct;
ta = struct;
if RC_NF_Plot == 1

    %% True Distance To Source Calculation
    r = f9IntParams(5,6); % Radius from launch complex to measurement location
    theta = f9IntParams(7,6); % Angle from launch complex to measurement location, relative true North
    [ta.NF,a,distToRocket,~,arp.NF,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('RADARSAT Constellation','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    handles(1,1) = plot(t,OASPL,'-o','MarkerIndices',1:10:length(OASPL),'MarkerSize',8);

end
%%
if RC_WF_Plot == 1

    %% True Distance To Source Calculation
    r = f9IntParams(5,7); % Radius from launch complex to measurement location
    theta = f9IntParams(7,7); % Angle from launch complex to measurement location, relative true North
    [ta.WF,a,distToRocket,~,arp.WF,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('RADARSAT Constellation','West Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    handles(1,2) = plot(t,OASPL,'-s','MarkerIndices',1:10:length(OASPL),'MarkerSize',8);

end
if RC_EF_Plot == 1

    %% True Distance To Source Calculation
    r = f9IntParams(5,8); % Radius from launch complex to measurement location
    theta = f9IntParams(7,8); % Angle from launch complex to measurement location, relative true North
    [ta.EF,a,distToRocket,~,arp.EF,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta);
    
    data = loadFalcon9Data('RADARSAT Constellation','East Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    handles(1,3) = plot(t,OASPL,'-*','MarkerIndices',1:10:length(OASPL),'MarkerSize',8);

end
if RC_MG_Plot == 1

    %% True Distance To Source Calculation
    r = f9IntParams(5,9); % Radius from launch complex to measurement location
    theta = f9IntParams(7,9); % Angle from launch complex to measurement location, relative true North
    [ta.MG,a,distToRocket,~,arp.MG,~] = getRocketTrajectory('RADARSAT Constellation','SoundSpeed',c,'DistFromPad',r,'Angle',theta,'ZeroPad',5);
    
    data = loadFalcon9Data('RADARSAT Constellation','Miguelito','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL + 20.*log10(distToRocket(1:length(data.OASPLData.OASPL))./r0);
    handles(1,4) = plot(t,OASPL,'-+','MarkerIndices',1:10:length(OASPL),'MarkerSize',8);

end

xlabel('Time (s)')
ylabel('OASPL (dB re 20\muPa)')
xlim([tStart-5 tEnd])

yyaxis right

handles(2,1) = plot(ta.NF(1:end-1),arp.NF,'--o','MarkerIndices',1:10:length(arp.NF),'MarkerSize',8,'Color',[0 0.4470 0.7410]);
handles(2,2) = plot(ta.WF(1:end-1),arp.WF,'--s','MarkerIndices',1:10:length(arp.WF),'MarkerSize',8,'Color',[0.8500 0.3250 0.0980]);
handles(2,3) = plot(ta.EF(1:end-1),arp.EF,'--*','MarkerIndices',1:10:length(arp.EF),'MarkerSize',8,'Color',[0.9290 0.6940 0.1250]);
handles(2,4) = plot(ta.MG(1:end-1),arp.MG,'--d','MarkerIndices',1:10:length(arp.MG),'MarkerSize',8,'Color',[0.4940 0.1840 0.5560]);
ax.CurrentAxes.YColor = [0.5 0.5 0.5];
ylabel('Angle re Plume (Degrees)')
grid on
box on
hold off

hlgd = gridlegend(handles',{'NF','WF','EF','MC'},{'OASPL','Angle re Plume'},'Location','South');
hlgd.Position = [150 99 391.0000 197];
