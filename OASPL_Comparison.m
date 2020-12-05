clear;

%% OASPL Comparison Script
% Compares OASPLs using strucuted variables (structs) containing
% OASPLs from measurement sites created using the Falcon_9_Analysis
% script.

plotStyle('FontStyle','classic','FontSize',22,'ColorScheme',1,'AspectRatio','standard','PlotSize','medium','Orientation','portrait')

tStart = 0;
tEnd = 120;%440;

tiled = 0;

data_path = 'F:\ASA Falcon 9 Analysis\';

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

%%
if tiled == 1
    switch numPlots
        case 1
            figure
        case 2
            a = tiledlayout(1,2)
        case 3
            a = tiledlayout(1,3)
        case 4
            a = tiledlayout(2,2)
        case {5,6}
            a = tiledlayout(2,3)
        case {7,8}
            a = tiledlayout(2,4)
        case 9
            a = tiledlayout(3,3)
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
    data = loadFalcon9Data('IRIDIUM 7','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
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
    data = loadFalcon9Data('IRIDIUM 7','West Field 1','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
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
    data = loadFalcon9Data('IRIDIUM 7','West Field 2','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
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
    data = loadFalcon9Data('SAOCOM 1A','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
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
    data = loadFalcon9Data('SAOCOM 1A','West Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
    plot(t,OASPL)
    if tiled == 1
        title('SAOCOM 1A West Field')
    else
        labels(length(labels) + 1) = "SAOCOM 1A West Field";
    end
end
if RC_NF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    data = loadFalcon9Data('RADARSAT Constellation','North Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
    plot(t,OASPL)
    if tiled == 1
        title('RADARSAT Constellation North Field')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation North Field";
    end
end
if RC_WF_Plot == 1
    if numPlots > 1 && tiled == 1
        nexttile
    end
    data = loadFalcon9Data('RADARSAT Constellation','West Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
    plot(t,OASPL)
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
    data = loadFalcon9Data('RADARSAT Constellation','East Field','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
    plot(t,OASPL)
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
    data = loadFalcon9Data('RADARSAT Constellation','Miguelito','OASPL',data_path);
    t = data.OASPLData.t;
    OASPL = data.OASPLData.OASPL;
    plot(t,OASPL)
    if tiled == 1
        title('RADARSAT Constellation Miguelito')
    else
        labels(length(labels) + 1) = "RADARSAT Constellation Miguelito";
    end
end

if numPlots > 1 && tiled == 1
    xlabel(a,'Time (s)','Fontlength',22)
    ylabel(a,'OASPL (dB re 20\muPa)','Fontlength',22)
    title(a,'Running OASPL')
elseif numPlots == 1
    xlabel('Time (s)')
    ylabel('OASPL (dB re 20\muPa)')
    title('Running OASPL')
    xlim([tStart tEnd])
    maxOASPL = max(OASPL);
    down3dB = [t(find(OASPL > (maxOASPL-3),1,'first')) t(find(OASPL > (maxOASPL-3),1,'last'))]
    xline(down3dB(1),'r','LineWidth',1.5)
    xline(down3dB(2),'r','LineWidth',1.5)
    yline(maxOASPL-3,'b','LineWidth',1.5)
else
    xlabel('Time (s)')
    ylabel('OASPL (dB re 20\muPa)')
    title('Running OASPL')
    xlim([tStart tEnd])
    if tiled == 0
        legend(labels,'Location','NorthEast')
    end
end

grid on