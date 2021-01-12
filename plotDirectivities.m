plotStyle('FontStyle','classic','FontSize',16,'LineWidth',1,'ColorScheme',1,'AspectRatio','square','PlotSize','small')
%%
data_path = 'E:\ASA Falcon 9 Analysis\';
f9IntParams = importdata('f9IntParams.mat');
f9NameParams = importdata('f9NameParams.mat');
locations = [1 3 4 5 6 7 9];
    
polar = 0;
smoothing = 0;
numPoints = 5;

commonDist = 1; % Correct all to common distance
rcomm = 5980; % Number of meters for common correction

labels = {};

for i = 1:length(locations)
    clear data t tj angleRelativePlume distToRocket
    
    LIN = locations(i);

    launch = f9NameParams(1,LIN); % Select Launch
    location = f9NameParams(2,LIN); % Select Location;
    r0 = f9IntParams(5,LIN); % Radius from launch complex to measurement location
    theta = f9IntParams(7,LIN); % Angle from launch complex to measurement location, relative true North

    data = loadFalcon9Data(launch,location,'OASPL',data_path); % Load Waveform Data
    t = data.OASPLData.t; % Load cooresponding time series
    OASPL(i,:) = data.OASPLData.OASPL(1:350);

    [tj,~,distToRocket,~,angleRelativePlume] = getRocketTrajectory(launch,'SoundSpeed',340,'DistFromPad',r0,'Angle',theta,'ZeroPad',abs(t(1)));
    
    switch locations(i)
        case {4,5}
            angleRelativePlume = smooth(angleRelativePlume,30/length(angleRelativePlume));
    end
    
    arp(i,:) = angleRelativePlume(1:350);
    
    if commonDist
        distCorr = rcomm;
    else
        distCorr = r0;
    end

    OASPL(i,:) = OASPL(i,:) + 20.*log10(distToRocket(1:length(OASPL(i,:)))./distCorr); % Distance correct OASPL for spherical spreading to common radius of site at t = 0
    
    if smoothing
        OASPL(i,:) = smooth(OASPL(i,:),numPoints/length(OASPL));
    end
    
%     if polar
%         
%     else
%         
%     end
    
    label = strcat(launch,{' '}, location);
    
    labels = [labels label];
end
%%

OASPLmean = mean(OASPL,1);
OASPLstd = std(OASPL);
OASPLmax = max(OASPL,[],1);
OASPLmin = min(OASPL,[],1);
arpMean = mean(arp,1);

OASPLmedian = median(OASPL,1);
arpMedian = median(arp,1);

labels = [labels,{'Mean'},{'Median'}];
%%
if polar
    figure
    polarplot(deg2rad(arp),OASPL)
    rlim([80 120])
    thetalim([0 90])
else
    figure
%     plot(arp',OASPL')
    hold on
    plot(arpMean,OASPLmean,'k','LineWidth',2,'MarkerSize',10,'MarkerIndices',[10:10:90])
%     patch([arpMean fliplr(arpMean)], [OASPLmin fliplr(OASPLmax)], [.89, 0, .23], 'FaceAlpha',0.5, 'EdgeColor','none')
    patch([arpMean fliplr(arpMean)], [OASPLmean-OASPLstd fliplr(OASPLmean+OASPLstd)], [0, .6, .77], 'FaceAlpha',0.5, 'EdgeColor','none')
    %     plot(arpMedian,OASPLmedian,'o-r','LineWidth',2,'MarkerSize',10,'MarkerIndices',[5:10:85])
        hold off
    xlabel('Angle re Plume (Deg)')
    ylabel('OASPL (dB re 20\muPa)')
    set(gca,'Xdir','reverse')
    xlim([0 90])
    xticks(0:10:90)
    ylim([80 120])
    grid on
    box on
end
% legend(labels,'FontSize',16,'Location','South')
%%

