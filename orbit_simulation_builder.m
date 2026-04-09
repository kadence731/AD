% =========================================================
%  ORBIT SIMULATION — Beginner MATLAB Activity
%  For upper-level high school physics / astronomy
% =========================================================
%
%  WHAT THIS DOES:
%    This script simulates a satellite (or planet) orbiting
%    a central body (like Earth or the Sun) using Newton's
%    Law of Gravity. It uses a simple "step-by-step" method
%    called Euler integration to update position and velocity
%    over time.
%
%  HOW TO USE IT:
%    1. Read the "STUDENT PARAMETERS" section below.
%    2. Change the values and re-run the script (press F5 or
%       click "Run") to see how the orbit changes.
%    3. Try the challenge questions at the bottom!
%
% =========================================================


%% ---- STUDENT PARAMETERS (edit these!) ------------------
%
%  TIP: Start by running the script once without changes,
%       then tweak one value at a time to see what happens.

% --- Central body (e.g. Earth) ---
M = 5.972e24;          % Mass of central body (kg)
                       % Earth = 5.972e24, Sun = 1.989e30

% --- Satellite starting position ---
% The satellite starts directly to the RIGHT of the central body.
r0 = 7.0e6;            % Starting distance from center (meters)
                       % Low Earth orbit is about 6.8e6 m
                       % Moon is about 3.84e8 m

% --- Satellite starting velocity ---
% The satellite starts moving UPWARD (perpendicular to the radius).
% Try the circular orbit speed first, then experiment!
%
%   Circular orbit speed formula: v = sqrt(G*M / r0)
%   (This is filled in automatically below — see v0_circular)

G = 6.674e-11;                      % Gravitational constant (do not change)
v0_circular = sqrt(G * M / r0);     % Speed needed for a circular orbit

v0 = 1.0 * v0_circular;   % <--- CHANGE THIS multiplier!
                           %  1.0  = circular orbit
                           %  0.8  = slower → ellipse (satellite falls inward)
                           %  1.2  = faster → ellipse (satellite swings outward)
                           % >1.41 = escape velocity! satellite flies away

% --- Simulation time ---
T_total = 2 * 3600;    % Total simulation time (seconds)
                       % 2*3600 = 2 hours. Increase for longer orbits.
dt      = 1;           % Time step (seconds). Smaller = more accurate.

%% ---- PHYSICS ENGINE (you do not need to edit below here) ---

% --- Set up initial conditions ---
% Position vector: [x, y] in meters
x = r0;   % starts to the right of center
y = 0;

% Velocity vector: [vx, vy] in meters/second
vx = 0;        % no horizontal velocity at start
vy = v0;       % moving upward at start

% --- Storage arrays (to record path for plotting) ---
num_steps = round(T_total / dt);
X  = zeros(1, num_steps);
Y  = zeros(1, num_steps);

% --- Main simulation loop (Euler method) ---
for i = 1:num_steps

    % Save current position
    X(i) = x;
    Y(i) = y;

    % Distance from center
    r = sqrt(x^2 + y^2);

    % Gravitational acceleration (Newton's law: a = G*M / r^2)
    % Direction: always pointing TOWARD the center (hence the minus signs)
    ax = -G * M * x / r^3;
    ay = -G * M * y / r^3;

    % Update velocity (v_new = v_old + a * dt)
    vx = vx + ax * dt;
    vy = vy + ay * dt;

    % Update position (x_new = x_old + v * dt)
    x = x + vx * dt;
    y = y + vy * dt;

    % Stop early if satellite escapes (distance > 100x starting distance)
    if r > 100 * r0
        X = X(1:i);
        Y = Y(1:i);
        disp('Satellite escaped! Try a smaller velocity multiplier.');
        break
    end

end

%% ---- PLOTTING -----------------------------------------------

figure(1);
clf;                    % Clear previous figure

% Plot the orbit path
plot(X, Y, 'b-', 'LineWidth', 2);
hold on;

% Mark the central body (Earth/Sun)
plot(0, 0, 'yo', 'MarkerSize', 20, 'MarkerFaceColor', 'yellow');
text(0, 0, '  Central Body', 'Color', 'yellow', 'FontSize', 10);

% Mark starting position
plot(X(1), Y(1), 'g^', 'MarkerSize', 10, 'MarkerFaceColor', 'green');
text(X(1), Y(1), '  Start', 'Color', 'green', 'FontSize', 10);

% Mark ending position
plot(X(end), Y(end), 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'red');
text(X(end), Y(end), '  End', 'Color', 'red', 'FontSize', 10);

% Formatting
axis equal;             % Keep x and y scales the same (important for orbits!)
grid on;
set(gca, 'Color', [0.05 0.05 0.15]);      % Dark background
set(gcf, 'Color', [0.1  0.1  0.2 ]);
ax = gca;
ax.XColor = 'white';
ax.YColor = 'white';
ax.GridColor = [0.3 0.3 0.5];

title(sprintf('Orbit Simulation  (v₀ = %.2f × circular speed)', v0 / v0_circular), ...
      'Color', 'white', 'FontSize', 13);
xlabel('x position (m)', 'Color', 'white');
ylabel('y position (m)', 'Color', 'white');

% Print some useful info to the Command Window
fprintf('\n--- Orbit Info ---\n');
fprintf('Starting distance:      %.2e m\n', r0);
fprintf('Circular orbit speed:   %.2f m/s\n', v0_circular);
fprintf('Your starting speed:    %.2f m/s  (%.2f x circular)\n', v0, v0/v0_circular);
fprintf('Time step:              %g s\n', dt);
fprintf('Total time simulated:   %.1f minutes\n', T_total/60);
fprintf('------------------\n\n');


%% ---- CHALLENGE QUESTIONS ------------------------------------
%
%  Try these after you get the basic simulation running:
%
%  1. CIRCULAR ORBIT
%     Set v0 = 1.0 * v0_circular. Does the orbit look like a circle?
%     What happens to the orbit shape if you increase dt to 10 or 100?
%     (This shows why small time steps matter!)
%
%  2. ELLIPTICAL ORBITS
%     Set v0 = 0.75 * v0_circular. What shape is the orbit?
%     Now try 1.3 * v0_circular. Is it a different ellipse?
%     Which end of the ellipse is closest to the central body?
%
%  3. ESCAPE VELOCITY
%     The escape velocity is sqrt(2) ≈ 1.414 times the circular speed.
%     Set v0 = 1.41 * v0_circular, then 1.42. What changes?
%
%  4. DIFFERENT ORBITS
%     Change r0 to the Moon's distance: r0 = 3.84e8
%     How long does one orbit take? (Adjust T_total)
%     The real Moon takes ~27 days. How close is your simulation?
%
%  5. ORBIT AROUND THE SUN
%     Set M = 1.989e30 (Sun's mass) and r0 = 1.496e11 (Earth's distance).
%     How long does one orbit take in seconds? Convert to days.
%     (Hint: 1 year ≈ 3.156e7 seconds)
%
% =========================================================
