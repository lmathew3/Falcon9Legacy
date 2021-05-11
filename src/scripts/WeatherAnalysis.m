cd 'C:\Users\logan\Box\ASA Falcon 9 Analysis'

i7nf = transpose(csvread('I7_NF.csv'));
i7wf = transpose(csvread('I7_WF.csv'));
s1nf = transpose(csvread('S1_NF.csv'));
rcnf = transpose(csvread('RC_NF.csv'));
rcwf = transpose(csvread('RC_WF.csv'));
rcef = transpose(csvread('RC_EF.csv'));
rcmig = transpose(csvread('RC_MIG.csv'));
rct = 1:5:600;
i7t = 1:2:594;
s1t = 1:541;
% hold on
% plot(rct,rcnf(5,:),rct,rcwf(5,:),rct,rcef(5,:),rct,rcmig(5,:))
% hold off
% hold on
% plot(rct,rcnf(4,:),rct,rcwf(4,:),rct,rcef(4,:),rct,rcmig(4,:),s1t,s1nf(4,:),i7t,i7nf(4,:),i7wt,i7wf(4,:))
% hold off
v=VideoWriter('RADARSAT Constellation Wind Multi.avi','MPEG-4');
v.Quality = 95;
open(v)
figure;

for i = 1:length(rcnf(5,:))
tiledlayout(2,2)
x = rcnf(4,i)*cos(deg2rad(rcnf(5,i)));
y = rcnf(4,i)*sin(deg2rad(rcnf(5,i)));
compass(x,y);
% Modified compass figure with higher radial limit
figure;
max_lim = 4;
x_fake=[0 max_lim 0 -max_lim];
y_fake=[max_lim 0 -max_lim 0];
h_fake=compass(x_fake,y_fake);
hold on;
nexttile
h=compass(x,y);
set(h_fake,'Visible','off');
title('RADARSAT North Field')
camorbit(0,180);
camroll(90)
x = rcwf(4,i)*cos(deg2rad(rcwf(5,i)));
y = rcwf(4,i)*sin(deg2rad(rcwf(5,i)));
compass(x,y);
% Modified compass figure with higher radial limit
figure;
max_lim = 4;
x_fake=[0 max_lim 0 -max_lim];
y_fake=[max_lim 0 -max_lim 0];
h_fake=compass(x_fake,y_fake);
hold on;
nexttile
h=compass(x,y);
set(h_fake,'Visible','off');
title('RADARSAT West Field')
camorbit(0,180);
camroll(90)
x = rcef(4,i)*cos(deg2rad(rcef(5,i)));
y = rcef(4,i)*sin(deg2rad(rcef(5,i)));
compass(x,y);
% Modified compass figure with higher radial limit
figure;
max_lim = 4;
x_fake=[0 max_lim 0 -max_lim];
y_fake=[max_lim 0 -max_lim 0];
h_fake=compass(x_fake,y_fake);
hold on;
nexttile
h=compass(x,y);
set(h_fake,'Visible','off');
title('RADARSAT Miguelito')
camorbit(0,180);
camroll(90)
x = rcmig(4,i)*cos(deg2rad(rcmig(5,i)));
y = rcmig(4,i)*sin(deg2rad(rcmig(5,i)));
compass(x,y);
% Modified compass figure with higher radial limit
figure;
max_lim = 4;
x_fake=[0 max_lim 0 -max_lim];
y_fake=[max_lim 0 -max_lim 0];
h_fake=compass(x_fake,y_fake);
hold on;
nexttile
h=compass(x,y);
set(h_fake,'Visible','off');
title('RADARSAT Miguelito')
camorbit(0,180);
camroll(90)
F(i)=getframe(gcf);
end

writeVideo(v,F)
close(v)