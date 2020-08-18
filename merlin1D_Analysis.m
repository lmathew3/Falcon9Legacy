% Oertel Convective Mach Number as given in Greska et al. (2008) Eq. 4
% U_j = fully expanded jet velocity
% a_j = sound speed in jet
% a_inf = sound speed in ambient medium
Mco = @(U_j,a_j,a_inf) (U_j + 0.5*a_j)/(a_j + a_inf);

gamma = 1.20;
P0 = 0.0032108e6;
rho0 = 0.01;
a_j = sqrt(gamma*P0/rho0);

U_j = 3100; % Approximate Exit Velocity of Merlin 1D, m/s
a_inf = 340;

Mc = Mco(U_j,a_j,a_inf)