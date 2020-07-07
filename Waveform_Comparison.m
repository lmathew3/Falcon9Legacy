%% Waveform Comparison Script
% Compares waveforms using strucuted variables (structs) containing
% waveforms from measurement sites created using the Falcon_9_Analysis
% script.

tStart = 0;
tEnd = 2;

data_path = 'E:\ASA Falcon 9 Analysis\';
I7_NF = open(fullfile([data_path,'IRIDIUM 7\North Field\MAT Files\','IRIDIUM 7_North Field CH0 378A07_COUGAR_Waveform.mat']));
I7_WF1 = open(fullfile([data_path,'IRIDIUM 7\West Field 1\MAT Files\','IRIDIUM 7_West Field 1 CH0 378A07_COUGAR_Waveform.mat']));
I7_WF2 = open(fullfile([data_path,'IRIDIUM 7\West Field 2\MAT Files\','IRIDIUM 7_West Field 2 CH0 378A07_COUGAR_Waveform.mat']));
S1A_NF = open(fullfile([data_path,'SAOCOM 1A\North Field\MAT Files\','SAOCOM 1A_North Field CH3 378A07_COUGAR_Waveform.mat']));
S1A_WF = open(fullfile([data_path,'SAOCOM 1A\West Field\MAT Files\','SAOCOM 1A_West Field CH4 378A07_COUGAR_Waveform.mat']));
RC_NF = open(fullfile([data_path,'RADARSAT Constellation\North Field\MAT Files\','RADARSAT Constellation_North Field CH9 378A07_COUGAR_Waveform.mat']));
RC_WF = open(fullfile([data_path,'RADARSAT Constellation\West Field\MAT Files\','RADARSAT Constellation_West Field CH0 378A07_COUGAR_Waveform.mat']));
RC_EF = open(fullfile([data_path,'RADARSAT Constellation\East Field\MAT Files\','RADARSAT Constellation_East Field CH0 378A07_COUGAR_Waveform.mat']));
RC_MG = open(fullfile([data_path,'RADARSAT Constellation\Miguelito\MAT Files\','RADARSAT Constellation_Miguelito CH0 378A07_COUGAR_Waveform.mat']));

I7_NF_Plot = 1;
I7_WF1_Plot = 1;
I7_WF2_Plot = 1;
S1A_NF_Plot = 1;
S1A_WF_Plot = 1;
RC_NF_Plot = 1;
RC_WF_Plot = 1;
RC_EF_Plot = 1;
RC_MG_Plot = 1;

numPlots = I7_NF_Plot + I7_WF1_Plot + I7_WF2_Plot + S1A_NF_Plot + S1A_WF_Plot + RC_NF_Plot + RC_WF_Plot + RC_EF_Plot + RC_MG_Plot;

%%

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

if I7_NF_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(I7_NF.waveformData.t(tStart*I7_NF.waveformData.fs+1:tEnd*I7_NF.waveformData.fs),I7_NF.waveformData.p(tStart*I7_NF.waveformData.fs+1:tEnd*I7_NF.waveformData.fs))
    title('IRIDIUM 7 NEXT North Field')
end
if I7_WF1_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(I7_WF1.waveformData.t(tStart*I7_WF1.waveformData.fs+1:tEnd*I7_WF1.waveformData.fs),I7_WF1.waveformData.p(tStart*I7_WF1.waveformData.fs+1:tEnd*I7_WF1.waveformData.fs))
    title('IRIDIUM 7 NEXT West Field 1')
end
if I7_WF2_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(I7_WF2.waveformData.t(tStart*I7_WF2.waveformData.fs+1:tEnd*I7_WF2.waveformData.fs),I7_WF2.waveformData.p(tStart*I7_WF2.waveformData.fs+1:tEnd*I7_WF2.waveformData.fs))
    title('IRIDIUM 7 NEXT West Field 1')
end
if S1A_NF_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(S1A_NF.waveformData.t(tStart*S1A_NF.waveformData.fs+1:tEnd*S1A_NF.waveformData.fs),S1A_NF.waveformData.p(tStart*S1A_NF.waveformData.fs+1:tEnd*S1A_NF.waveformData.fs))
    title('SAOCOM 1A North Field')
end
if S1A_WF_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(S1A_WF.waveformData.t(tStart*S1A_WF.waveformData.fs+1:tEnd*S1A_WF.waveformData.fs),S1A_WF.waveformData.p(tStart*S1A_WF.waveformData.fs+1:tEnd*S1A_WF.waveformData.fs))
    title('SAOCOM 1A West Field')
end
if RC_NF_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(RC_NF.waveformData.t(tStart*RC_NF.waveformData.fs+1:tEnd*RC_NF.waveformData.fs),RC_NF.waveformData.p(tStart*RC_NF.waveformData.fs+1:tEnd*RC_NF.waveformData.fs))
    title('RADARSAT Constellation North Field')
end
if RC_WF_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(RC_WF.waveformData.t(tStart*RC_WF.waveformData.fs+1:tEnd*RC_WF.waveformData.fs),RC_WF.waveformData.p(tStart*RC_WF.waveformData.fs+1:tEnd*RC_WF.waveformData.fs))
    title('RADARSAT Constellation West Field')
end
if RC_EF_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(RC_EF.waveformData.t(tStart*RC_EF.waveformData.fs+1:tEnd*RC_EF.waveformData.fs),RC_EF.waveformData.p(tStart*RC_EF.waveformData.fs+1:tEnd*RC_EF.waveformData.fs))
    title('RADARSAT Constellation East Field')
end
if RC_MG_Plot == 1
    if numPlots > 1
        nexttile
    end
    plot(RC_MG.waveformData.t(tStart*RC_MG.waveformData.fs+1:tEnd*RC_MG.waveformData.fs),RC_MG.waveformData.p(tStart*RC_MG.waveformData.fs+1:tEnd*RC_MG.waveformData.fs))
    title('RADARSAT Constellation Miguelito')
end

if numPlots > 1
    xlabel(a,'Time (s)','FontSize',22)
    ylabel(a,'Pressure (Pa)','FontSize',22)
else
    xlabel('Time (s)')
    ylabel('Pressure (Pa)')
end