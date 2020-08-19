theta = [0 20 22 24 27 29 32 34 37 40 42 44 47 49 52 54 58 76 80 84 86 88 92 97 102 109 117 123 129 136 142 148 155 162 169];
oaspl = [105 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 127 126 125 124 123 122 121 120 119 118 117 116 115 114 113 112 111 110];

figure
plot(theta(2:end),oaspl(2:end))
xlabel('Angle re Plume (Deg)')
ylabel('OASPL (dB re 20\muPa)')
grid on
title('RSRM OASPL at d \approx 570 D_e, DSM-1 Model Correction')
dth = 5;
grid = 0:dth:180;
oaspl_interp = interp1(theta,oaspl,grid,'spline');

figure
plot(theta,oaspl,grid,oaspl_interp)
xlabel('Angle re Plume (Deg)')
ylabel('OASPL (dB re 20\muPa)')
grid on
title('RSRM OASPL at d \approx 570 D_e, DSM-1 Model Correction')
legend('Measured OASPL','Interpolated')

%% Plot on sphere assuming azimuthal axisymmetry
oaspl_vals = transpose(oaspl_interp);
oaspl = oaspl_vals;
for i = 2:37
    oaspl(:,i) = oaspl_vals;
end
ZZ = cosd(theta);
figure
[x,y,z] = sphere(36)
a=[0 0 0 1]
s1=surf(x*a(1,4)+a(1,1),y*a(1,4)+a(1,2),z*a(1,4)+a(1,3),oaspl);
colormap jet
colorbar
daspect([1 1 1])
view(30,10)
title('RSRM OASPL at d \approx 570 D_e, DSM-1 Model Correction')