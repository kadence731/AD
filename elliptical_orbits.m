% Define constants: Evector points in i direction
G = 6.67e-11;
M_Moon = 7.35e22; % kg
RadiusMoon = 1737.4e3;
R_periapsis = 2000e3; % m
e_list = [0.25, 0.5, 0.75];
miu = G * M_Moon; % gravitational parameter

% Part 1 -> Semi-major, Apoapsis distance, Orbital eneregy, Orbital period
results = [];
figure ;
hold on;
grid on;
axis equal;
colors = ['r','g', 'b'];
theta = linspace(0,2*pi,1000);
fprintf(' e   a3 (m)   R_apoapsis (m)  E3 (j)   T3(s) \n');
for  i = 1:length(e_list)
e = e_list(i);
a = R_periapsis/(1-e);
R_apoapsis = a*(1+e);
Ep = -miu/(2*a) ;
T = 2*pi*sqrt(a^3/miu);
fprintf('%0.2f %8.2f %8.2f %1.3ef %1.3ef\n', e, a, R_apoapsis, Ep, T);
% Convert to cartesian
r = a*(1-e^2)./(1+e*cos(theta));
x = r.*cos(theta);
y = r.*sin(theta);
plot(x/1000, y/1000, colors(i), 'Linewidth', 1.8);
end
% Plot format
xlabel = ('x(km)');
ylabel = ('y (km) ' );
title = ( 'Elliptical Orbits around moon');
legend('e=0.25', 'e=0.5','e=0.75');
axis equal;



% plan to create separate function to write in command window

% here's how to set up activity
% here's what to write on the board or demonstrate
% here's what kids will need help with
