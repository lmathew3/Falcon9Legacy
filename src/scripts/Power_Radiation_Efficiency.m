% plotStyle('FontStyle','modern','FontSize',22,'LineWidth',1.75,'ColorScheme',1,'AspectRatio','standard','PlotSize','medium','Orientation','landscape')
Wmech = 1e6:1e5:1e11;
n1 = 0.001;
n2 = 0.002;
n3 = 0.005;
n4 = 0.01;
Wref = 1e-12;

figure
semilogx(Wmech,10*log10(Wmech*n1/Wref),Wmech,10*log10(Wmech*n2/Wref),...
    Wmech,10*log10(Wmech*n3/Wref),Wmech,10*log10(Wmech*n4/Wref))
grid on
xlabel('Exhaust Mechanical Power, W_{mech} (W)')
ylabel('OASWL, L_{w,acous} (dB re 10 pw)')
legend('\eta = 0.1%','\eta = 0.2%','\eta = 0.5%','\eta = 1%','Location','SouthEast')