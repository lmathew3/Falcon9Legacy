%% File Format
% Line 1: Time (s)
% Line 2: Velocity (m/s)
% Line 3: Altitude (km)
% Line 4: Velocity y (m/s)
% Line 5: Velocity x (m/s)
% Line 6: Acceleration (m/s^2)
% Line 7: Downrange distance (km)
% Line 8: Angle relative horizon (deg)
% Line 9: q
plotStyle
iridium7 = transpose(xlsread('IRIDIUM7_Analyzed_Telemetry_Data.xlsx'));
t = iridium7(1,:);
a = iridium7(3,:).*1e3;
d = iridium7(7,:).*1e3;
figure
plot(d,a)
xlabel('Downrange Distance, m')
ylabel('Altitude (m)')
figure
plot(iridium7(1,:),iridium7(8,:))
xlabel('Time (s)')
ylabel('Angle relative Horizon')

%% Finding angle of rocket relative to observation location at North Field.
[distToRocket,downrangeFromSite] = distCalc(8346,133,d,a,1,0);
angleRelativePlume = asind(downrangeFromSite./distToRocket) - (90-iridium7(8,:));
figure
plot(iridium7(1,:),angleRelativePlume,t,(90-iridium7(8,:)))
xlabel('Time (s)')
ylabel('Directivity Angle (Deg)')
%%

c = 340; % Generalized speed of sound
% tMECO = 146;
% tSES = 157;
% tMECOprop = tMECO + distToRocket(tMECO)./c;
% tSESprop = tSES + distToRocket(tSES)./c;
dt0 = distToRocket(1)/c; % Initial time displacement due to propagation, taken out of calculations as data is aligned with IOP
propogatedTime = t + distToRocket./c;
figure
plot(propogatedTime-dt0,distToRocket./1e3,propogatedTime-dt0,iridium7(2,:))

xlabel('Time (s)')
ylabel('Distance (km)')
legend('Distance to Measurement Site w/ prop. time','Velocity')
% xline(tMECOprop)
% xline(tSESprop)
% xlim([0 500])
%%
figure
plot(t,propogatedTime)