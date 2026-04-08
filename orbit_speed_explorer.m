function orbit_speed_explorer
clc; close all;

G = 6.67430e-11;   % gravitational constant

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

% -------------------------
% Figure and axes
% -------------------------
f = figure( ...
    'Name','Orbit Speed Explorer', ...
    'NumberTitle','off', ...
    'Color',[0.05 0.06 0.12], ...
    'Position',[100 100 980 700]);

ax = axes( ...
    'Parent',f, ...
    'Position',[0.08 0.29 0.84 0.65], ...
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
title(ax,'Pick a world and press Run Orbit','Color',[0.96 0.96 1.00],'FontWeight','bold');

% -------------------------
% Controls
% -------------------------
uicontrol('Parent',f,'Style','text', ...
    'Position',[70 122 160 22], ...
    'String','Speed Multiplier', ...
    'BackgroundColor',[0.05 0.06 0.12], ...
    'ForegroundColor',[0.92 0.96 1.00], ...
    'FontSize',10, ...
    'FontWeight','bold');

speedSlider = uicontrol('Parent',f,'Style','slider', ...
    'Min',0.5,'Max',2.0,'Value',0.5, ...
    'Position',[70 100 240 24], ...
    'BackgroundColor',[0.12 0.15 0.28], ...
    'Callback',@updateSpeedLabel);

speedSlider.SliderStep = [0.01 0.10];

speedLabel = uicontrol('Parent',f,'Style','text', ...
    'Position',[320 100 90 24], ...
    'String','0.50x', ...
    'BackgroundColor',[0.05 0.06 0.12], ...
    'ForegroundColor',[0.30 0.86 1.00], ...
    'FontSize',11, ...
    'FontWeight','bold');

uicontrol('Parent',f,'Style','text', ...
    'Position',[430 122 130 22], ...
    'String','World', ...
    'BackgroundColor',[0.05 0.06 0.12], ...
    'ForegroundColor',[0.92 0.96 1.00], ...
    'FontSize',10, ...
    'FontWeight','bold');

dropdown = uicontrol('Parent',f,'Style','popupmenu', ...
    'String',planetNames, ...
    'Value',3, ...
    'Position',[430 98 170 30], ...
    'BackgroundColor',[0.12 0.15 0.28], ...
    'ForegroundColor',[0.96 0.96 1.00], ...
    'FontSize',10);

uicontrol('Parent',f,'Style','pushbutton', ...
    'String','Run Orbit', ...
    'Position',[290 40 180 42], ...
    'FontSize',11, ...
    'FontWeight','bold', ...
    'BackgroundColor',[0.20 0.60 1.00], ...
    'ForegroundColor',[1 1 1], ...
    'Callback',@runOrbit);

uicontrol('Parent',f,'Style','pushbutton', ...
    'String','Reset', ...
    'Position',[490 40 100 42], ...
    'FontSize',11, ...
    'FontWeight','bold', ...
    'BackgroundColor',[1.00 0.45 0.55], ...
    'ForegroundColor',[1 1 1], ...
    'Callback',@resetPlot);

updateSpeedLabel();

% =========================
% Nested functions
% =========================
    function updateSpeedLabel(~,~)
        speedLabel.String = sprintf('%.2fx', speedSlider.Value);
    end

    function resetPlot(~,~)
        cla(ax);
        hold(ax,'on');
        grid(ax,'on');
        axis(ax,'equal');
        axis(ax,'padded');
        xlabel(ax,'x (km)','Color',[0.92 0.96 1.00],'FontWeight','bold');
        ylabel(ax,'y (km)','Color',[0.92 0.96 1.00],'FontWeight','bold');
        title(ax,'Pick a world and press Run Orbit','Color',[0.96 0.96 1.00],'FontWeight','bold');
    end

    function runOrbit(~,~)
        cla(ax);
        hold(ax,'on');
        grid(ax,'on');
        axis(ax,'equal');
        axis(ax,'padded');
        xlabel(ax,'x (km)','Color',[0.92 0.96 1.00],'FontWeight','bold');
        ylabel(ax,'y (km)','Color',[0.92 0.96 1.00],'FontWeight','bold');
        title(ax,'Running new orbit...','Color',[0.96 0.96 1.00],'FontWeight','bold');
        drawnow;

        idx = dropdown.Value;
        bodyName   = systems{idx,1};
        M          = systems{idx,2};
        R          = systems{idx,3};
        bodyColor  = systems{idx,4};
        trailColor = systems{idx,5};

        mu = G * M;

        % Start slightly above surface
        r0 = R + 300e3;

        % Circular speed at starting altitude
        vCirc = sqrt(mu / r0);

        % User-selected multiplier
        speedMult = speedSlider.Value;
        v0 = speedMult * vCirc;

        % Draw planet
        theta = linspace(0, 2*pi, 500);
        fill(ax, (R*cos(theta))/1000, (R*sin(theta))/1000, bodyColor, ...
            'EdgeColor','none', 'FaceAlpha',1.0);
        plot(ax, (R*cos(theta))/1000, (R*sin(theta))/1000, '-', ...
            'Color', min(bodyColor+0.15,1), 'LineWidth',1.5);

        % Initial state
        x = r0;
        y = 0;
        vx = 0;
        vy = v0;

        % -------------------------
        % Time settings
        % -------------------------
        % Physics timestep
        dt = 8;

        % Visual update settings
        drawEvery = 8;
        pauseTime = 0.003;

        % Estimate expected orbital period for bound orbits
        vSquared = vx^2 + vy^2;
        specificEnergy = 0.5 * vSquared - mu / r0;

        isBoundCandidate = specificEnergy < 0;

        if isBoundCandidate
            a = -mu / (2 * specificEnergy);            % semi-major axis
            estPeriod = 2*pi*sqrt(a^3 / mu);           % seconds
            maxTime = min(1.35 * estPeriod, 2.0e6);    % enough time for one orbit, capped
        else
            maxTime = 3.0e5;                           % unbound / fast escape case
        end

        maxSteps = max(1000, ceil(maxTime / dt));

        orbitX = nan(1,maxSteps);
        orbitY = nan(1,maxSteps);

        hOrbit = plot(ax, nan, nan, '-', 'Color', trailColor, 'LineWidth', 2.0);
        hCraft = plot(ax, nan, nan, 'o', ...
            'MarkerFaceColor',[1 1 1], ...
            'MarkerEdgeColor',[0.95 0.95 0.95], ...
            'MarkerSize',5);

        halfPassed = false;
        elapsedTime = 0;

        % Require meaningful fraction of orbit before declaring closure
        if isBoundCandidate
            minCloseTime = 0.75 * estPeriod;
        else
            minCloseTime = inf;
        end

        for i = 1:maxSteps
            r = sqrt(x^2 + y^2);

            % Gravity acceleration
            ax_g = -mu * x / r^3;
            ay_g = -mu * y / r^3;

            % Euler-Cromer update
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

            % Crash into body
            if r < R
                set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i), ...
                    'Color', [1.00 0.35 0.35], 'LineWidth', 2.4);
                set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
                title(ax, sprintf('%s: CRASHED', upper(bodyName)), ...
                    'Color',[1.00 0.55 0.55], 'FontWeight','bold');
                return
            end

            % Escape
            if r > 12 * r0
                set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i), ...
                    'Color', [0.35 1.00 0.65], 'LineWidth', 2.4);
                set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
                title(ax, sprintf('%s: ESCAPED', upper(bodyName)), ...
                    'Color',[0.50 1.00 0.70], 'FontWeight','bold');
                return
            end

            % Mark that we made it to far side
            if x < 0
                halfPassed = true;
            end

            % Closed orbit check:
            % only after enough of the estimated period has passed
            if isBoundCandidate && halfPassed && elapsedTime > minCloseTime
                backNearStart = (x > 0) && (abs(y) < 80e3) && (abs(r - r0) < 60e3);
                if backNearStart
                    set(hOrbit, 'XData', orbitX(1:i), 'YData', orbitY(1:i), ...
                        'Color', trailColor, 'LineWidth', 2.4);
                    set(hCraft, 'XData', orbitX(i), 'YData', orbitY(i));
                    title(ax, sprintf('%s: CLOSED ORBIT', upper(bodyName)), ...
                        'Color',[0.96 0.96 1.00], 'FontWeight','bold');
                    return
                end
            end
        end

        % If it ran out of time without obvious crash/escape, show partial result honestly
        set(hOrbit, 'XData', orbitX(~isnan(orbitX)), 'YData', orbitY(~isnan(orbitY)), ...
            'Color', trailColor, 'LineWidth', 2.2);
        set(hCraft, 'XData', orbitX(find(~isnan(orbitX),1,'last')), ...
                    'YData', orbitY(find(~isnan(orbitY),1,'last')));
        title(ax, sprintf('%s: SIMULATION END', upper(bodyName)), ...
            'Color',[0.96 0.96 1.00], 'FontWeight','bold');
    end
end