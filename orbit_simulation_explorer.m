function orbit_student_editor
clc; close all;


%% VARIABLES TO EDIT

bodyName = 'Earth';        % Planet / Central body
speedMult = 1.00;          % Speed Multiplier
startAltitude_km = 300;    % Starting Altitude

dt = 8;                    % Time Step
trailWidth = 2.2;          % Orbit Trail Thickness
pauseTime = 0.003;         % Animation Speed



%% =========================================================

% DO NOT EDIT BELOW

%% =========================================================


G = 6.67430e-11;

systems = {
    'Mercury', 3.3011e23, 2439.7e3, [0.72 0.66 0.57], [1.00 0.78 0.38];
    'Venus',   4.8675e24, 6051.8e3, [0.92 0.76 0.34], [1.00 0.60 0.25];
    'Earth',   5.9724e24, 6371.0e3, [0.20 0.55 1.00], [0.35 0.95 0.65];
    'Moon',    7.3420e22, 1737.4e3, [0.82 0.84 0.92], [1.00 0.84 0.30];
    'Mars',    6.4171e23, 3389.5e3, [0.94 0.38 0.20], [1.00 0.48 0.78];
    'Jupiter', 1.8982e27, 69911e3,  [0.84 0.56 0.30], [0.98 0.88 0.36];
    'Saturn',  5.6834e26, 58232e3,  [0.93 0.84 0.56], [0.82 1.00 0.56];
    'Uranus',  8.6810e25, 25362e3,  [0.42 0.90 0.95], [0.45 1.00 1.00];
    'Neptune', 1.0241e26, 24622e3,  [0.28 0.42 0.96], [0.58 0.78 1.00]
};

planetNames = systems(:,1);
idx = find(strcmpi(bodyName, planetNames), 1);
if isempty(idx)
    error('bodyName must be one of: %s', strjoin(planetNames, ', '));
end

M = systems{idx,2};
R = systems{idx,3};
bodyColor = systems{idx,4};
trailColor = systems{idx,5};
mu = G * M;

r0 = R + startAltitude_km * 1000;
vCirc = sqrt(mu / r0);
v0 = speedMult * vCirc;

f = figure( ...
    'Name','Orbit Explorer — Student Editable Version', ...
    'NumberTitle','off', ...
    'Color',[0.05 0.06 0.12], ...
    'Position',[100 100 980 700]);

ax = axes( ...
    'Parent',f, ...
    'Position',[0.08 0.18 0.84 0.74], ...
    'Color',[0.03 0.04 0.10], ...
    'XColor',[0.86 0.92 1.00], ...
    'YColor',[0.86 0.92 1.00], ...
    'GridColor',[0.35 0.45 0.75], ...
    'LineWidth',1.0);
hold(ax,'on');
grid(ax,'on');
axis(ax,'equal');
axis(ax,'padded');
xlabel(ax,'x (km)','Color',[0.92 0.96 1.00],'FontWeight','bold');
ylabel(ax,'y (km)','Color',[0.92 0.96 1.00],'FontWeight','bold');
title(ax,'Running orbit...','Color',[0.96 0.96 1.00],'FontWeight','bold');

theta = linspace(0, 2*pi, 500);
fill(ax, (R*cos(theta))/1000, (R*sin(theta))/1000, bodyColor, ...
    'EdgeColor','none', 'FaceAlpha',1.0);
plot(ax, (R*cos(theta))/1000, (R*sin(theta))/1000, '-', ...
    'Color', min(bodyColor+0.15,1), 'LineWidth',1.5);

x = r0;
y = 0;
vx = 0;
vy = v0;

vSquared = vx^2 + vy^2;
specificEnergy = 0.5 * vSquared - mu / r0;
isBoundCandidate = specificEnergy < 0;

if isBoundCandidate
    a = -mu / (2 * specificEnergy);
    estPeriod = 2*pi*sqrt(a^3 / mu);
    maxTime = min(1.35 * estPeriod, 2.0e6);
else
    estPeriod = NaN;
    maxTime = 3.0e5;
end

maxSteps = max(1000, ceil(maxTime / dt));
orbitX = nan(1,maxSteps);
orbitY = nan(1,maxSteps);

hOrbit = plot(ax, nan, nan, '-', 'Color', trailColor, 'LineWidth', trailWidth);
hCraft = plot(ax, nan, nan, 'o', ...
    'MarkerFaceColor',[1 1 1], ...
    'MarkerEdgeColor',[0.95 0.95 0.95], ...
    'MarkerSize',5);

infoText = sprintf(['Body: %s\nAltitude: %.0f km\nCircular speed: %.1f m/s\n' ...
    'Start speed: %.1f m/s\nMultiplier: %.2fx'], ...
    bodyName, startAltitude_km, vCirc, v0, speedMult);
text(ax, 0.02, 0.97, infoText, ...
    'Units','normalized', ...
    'VerticalAlignment','top', ...
    'Color',[0.95 0.97 1.00], ...
    'FontSize',10, ...
    'BackgroundColor',[0.08 0.10 0.18], ...
    'Margin',8);

halfPassed = false;
elapsedTime = 0;
drawEvery = max(1, round(8 / max(dt, 1e-6)));

if isBoundCandidate
    minCloseTime = 0.75 * estPeriod;
else
    minCloseTime = inf;
end

for i = 1:maxSteps
    r = sqrt(x^2 + y^2);

    ax_g = -mu * x / r^3;
    ay_g = -mu * y / r^3;

    vx = vx + ax_g * dt;
    vy = vy + ay_g * dt;

    x = x + vx * dt;
    y = y + vy * dt;

    elapsedTime = elapsedTime + dt;

    orbitX(i) = x / 1000;
    orbitY(i) = y / 1000;

    if mod(i, drawEvery) == 0
        set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i));
        set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
        drawnow;
        pause(pauseTime);
    end

    if r < R
        set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i), ...
            'Color', [1.00 0.35 0.35], 'LineWidth', trailWidth + 0.2);
        set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
        title(ax, sprintf('%s: CRASHED', upper(bodyName)), ...
            'Color',[1.00 0.55 0.55], 'FontWeight','bold');
        printSummary(bodyName, startAltitude_km, vCirc, v0, dt, elapsedTime, 'CRASHED');
        return
    end

    if r > 12 * r0
        set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i), ...
            'Color', [0.35 1.00 0.65], 'LineWidth', trailWidth + 0.2);
        set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
        title(ax, sprintf('%s: ESCAPED', upper(bodyName)), ...
            'Color',[0.50 1.00 0.70], 'FontWeight','bold');
        printSummary(bodyName, startAltitude_km, vCirc, v0, dt, elapsedTime, 'ESCAPED');
        return
    end

    if x < 0
        halfPassed = true;
    end

    if isBoundCandidate && halfPassed && elapsedTime > minCloseTime
        backNearStart = (x > 0) && (abs(y) < 80e3) && (abs(r - r0) < 60e3);
        if backNearStart
            set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i), ...
                'Color', trailColor, 'LineWidth', trailWidth + 0.2);
            set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
            title(ax, sprintf('%s: CLOSED ORBIT', upper(bodyName)), ...
                'Color',[0.96 0.96 1.00], 'FontWeight','bold');
            printSummary(bodyName, startAltitude_km, vCirc, v0, dt, elapsedTime, 'CLOSED ORBIT');
            return
        end
    end
end

set(hOrbit, 'XData', orbitX(~isnan(orbitX)), 'YData', orbitY(~isnan(orbitY)), ...
    'Color', trailColor, 'LineWidth', trailWidth);
set(hCraft, 'XData', orbitX(find(~isnan(orbitX),1,'last')), ...
            'YData', orbitY(find(~isnan(orbitY),1,'last')));
title(ax, sprintf('%s: SIMULATION END', upper(bodyName)), ...
    'Color',[0.96 0.96 1.00], 'FontWeight','bold');
printSummary(bodyName, startAltitude_km, vCirc, v0, dt, elapsedTime, 'SIMULATION END');

end

function printSummary(bodyName, startAltitude_km, vCirc, v0, dt, elapsedTime, result)
fprintf('\n--- Orbit Run ---\n');
fprintf('Body:              %s\n', bodyName);
fprintf('Start altitude:    %.0f km\n', startAltitude_km);
fprintf('Circular speed:    %.2f m/s\n', vCirc);
fprintf('Start speed:       %.2f m/s\n', v0);
fprintf('Multiplier:        %.2f x circular\n', v0 / vCirc);
fprintf('Time step:         %.2f s\n', dt);
fprintf('Time simulated:    %.1f min\n', elapsedTime / 60);
fprintf('Result:            %s\n', result);
fprintf('-----------------\n\n');
end
