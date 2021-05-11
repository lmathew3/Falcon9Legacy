% Oertel Convective Mach Number as given in Greska et al. (2008) Eq. 4
% U_j = fully expanded jet velocity
% a_j = sound speed in jet
% a_inf = sound speed in ambient medium
Mco = @(U_j,a_j,a_inf) (U_j + 0.5*a_j)./(a_j + a_inf);

gamma = 1.20;
P0 = 0.0032108e6;
rho0 = 0.01;
a_j = sqrt(gamma*P0/rho0);
%%
U_j = 3100; % Approximate Exit Velocity of Merlin 1D, m/s
a_inf = 340;

a_j = [911.1 911.0 910.9 910.7 910.6 910.5 910.4 910.3 910.2 910.1 910.0...
    909.9 909.8 909.7 909.6 909.5 909.5 909.4 909.3 875.6 875.5 875.4...
    875.3 875.2 875.1 875.0 874.9 874.8 874.7 874.6 874.5 874.4 874.3 874.2...
    874.1 874.0 873.9];
M_j = [3.397 3.398 3.399 3.400 3.401 3.402 3.403 3.404 3.405 3.406 3.407...
    3.408 3.409 3.409 3.410 3.411 3.412 3.413 3.414 3.526 3.527 3.528...
    3.529 3.530 3.530 3.530 3.531 3.532 3.533 3.534 3.534 3.535 3.536 3.536...
    3.537 3.538 3.539];
U_j = a_j.*M_j;

Mc = Mco(U_j,a_j,a_inf)