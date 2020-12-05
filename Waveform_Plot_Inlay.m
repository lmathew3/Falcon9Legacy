ylim([-50 50])
xlim([0 440])
toffset = 10;
pos3 = [0.28 0.18 0.27 0.25];
pos4 = [0.6 0.18 0.27 0.25];
pos2 = [0.6 0.65 0.27 0.25];
pos1 = [0.28 0.65 0.27 0.25];
x = RC_WF.waveformData.t((tStart+toffset)*RC_WF.waveformData.fs+1:tEnd*RC_WF.waveformData.fs);
y = RC_WF.waveformData.p((tStart+toffset)*RC_WF.waveformData.fs+1:tEnd*RC_WF.waveformData.fs);
y = filterData(y,0.5,51200,'high');
y_late = filterData(y,1000,51200,'low');
lim1 = [0.0 0.5];
lim2 = [42 42.5];
lim3 = [100 100.5];
lim4 = [300 300.5];
%%
grid on
hold on
zoomPlot(x,y,lim1,pos1,0)
zoomPlot(x,y,lim2,pos2,0)
zoomPlot(x,y,lim3,pos3,0)
zoomPlot(x,y_late,lim4,pos4,0)
