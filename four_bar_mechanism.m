% =========================================================================
% FOUR-BAR LINKAGE MECHANISM ANALYSIS
% =========================================================================
%
% DESCRIPTION:
%   This script performs a comprehensive kinematic analysis of a four-bar
%   linkage mechanism. It calculates joint angles, transmission angles,
%   and animates the mechanism motion. The script handles both Grashof
%   and non-Grashof linkage configurations using analytical solution methods.
%
% USAGE:
%   1. Edit the linkage dimensions (link1, link2, link3, link4) below
%   2. Set the angular velocity (omega2) of the input link
%   3. Run the script to see the analysis and animation
%
% LINKAGE CONFIGURATION:
%   - link1: Fixed ground link (distance between pivot points A and D)
%   - link2: Input crank (rotating link from A to B)
%   - link3: Coupler link (connecting link from B to C)
%   - link4: Output follower (rotating link from C to D)
%
% OUTPUTS:
%   - Grashof condition classification
%   - Real-time animation of the mechanism
%   - Plots of theta3, theta4, and transmission angle vs theta2
%
% AUTHOR: Refactored for clarity and maintainability
% DATE: 2025
%
% =========================================================================

%% Clear workspace and close figures
clear; clc; close all;

%% ========================= INPUT PARAMETERS ===========================

% Linkage dimensions (in arbitrary units, e.g., cm or mm)
link1 = 6.0;    % Ground link length (AD)
link2 = 2.0;    % Input crank length (AB)
link3 = 5.0;    % Coupler link length (BC)
link4 = 4.5;    % Output follower length (CD)

% Input link angular velocity (rad/s)
omega2 = 2.0;

% Animation parameters
fps = 30;               % Frames per second
num_frames = 360;       % Total number of frames for complete rotation

%% ======================= GRASHOF CONDITION CHECK ======================

fprintf('========================================\n');
fprintf('FOUR-BAR LINKAGE MECHANISM ANALYSIS\n');
fprintf('========================================\n\n');

fprintf('Linkage Dimensions:\n');
fprintf('  Ground link (link1): %.2f\n', link1);
fprintf('  Input crank (link2): %.2f\n', link2);
fprintf('  Coupler (link3):     %.2f\n', link3);
fprintf('  Follower (link4):    %.2f\n\n', link4);

% Check Grashof condition
[is_grashof, linkage_type] = check_grashof_condition(link1, link2, link3, link4);

fprintf('Grashof Analysis:\n');
fprintf('  Classification: %s\n', linkage_type);
fprintf('  Continuous rotation possible: %s\n\n', mat2str(is_grashof));

%% ==================== MECHANISM ANALYSIS AND ANIMATION ================

% Initialize arrays for storing results
theta2_array = linspace(0, 2*pi, num_frames);
theta3_array = zeros(1, num_frames);
theta4_array = zeros(1, num_frames);
transmission_angle_array = zeros(1, num_frames);

% Initial guesses for Newton-Raphson iteration
theta3_guess = pi/4;
theta4_guess = pi/4;

fprintf('Calculating mechanism positions...\n');

% Calculate positions for all input angles
for i = 1:num_frames
    theta2 = theta2_array(i);
    
    % Solve for theta3 and theta4 using Newton-Raphson method
    [theta3, theta4] = solve_four_bar_angles(link1, link2, link3, link4, ...
                                             theta2, theta3_guess, theta4_guess);
    
    % Store results
    theta3_array(i) = theta3;
    theta4_array(i) = theta4;
    
    % Calculate transmission angle
    transmission_angle_array(i) = calculate_transmission_angle(link2, link3, ...
                                                                link4, theta2, ...
                                                                theta3, theta4);
    
    % Update guesses for next iteration (continuity)
    theta3_guess = theta3;
    theta4_guess = theta4;
end

fprintf('Position calculations complete.\n\n');

%% ========================= PLOTTING RESULTS ============================

fprintf('Generating plots...\n');

% Create figure for angle plots
figure('Name', 'Four-Bar Mechanism Analysis', 'NumberTitle', 'off', ...
       'Position', [100, 100, 1200, 800]);

% Convert angles to degrees for plotting
theta2_deg = rad2deg(theta2_array);
theta3_deg = rad2deg(theta3_array);
theta4_deg = rad2deg(theta4_array);
transmission_angle_deg = rad2deg(transmission_angle_array);

% Plot theta3 vs theta2
subplot(3, 1, 1);
plot(theta2_deg, theta3_deg, 'b-', 'LineWidth', 2);
grid on;
xlabel('Input Angle \theta_2 (degrees)', 'FontSize', 11);
ylabel('Coupler Angle \theta_3 (degrees)', 'FontSize', 11);
title('Coupler Angle vs Input Angle', 'FontSize', 12, 'FontWeight', 'bold');
xlim([0, 360]);

% Plot theta4 vs theta2
subplot(3, 1, 2);
plot(theta2_deg, theta4_deg, 'r-', 'LineWidth', 2);
grid on;
xlabel('Input Angle \theta_2 (degrees)', 'FontSize', 11);
ylabel('Follower Angle \theta_4 (degrees)', 'FontSize', 11);
title('Follower Angle vs Input Angle', 'FontSize', 12, 'FontWeight', 'bold');
xlim([0, 360]);

% Plot transmission angle vs theta2
subplot(3, 1, 3);
plot(theta2_deg, transmission_angle_deg, 'g-', 'LineWidth', 2);
hold on;
% Add reference lines for good transmission angle range (45-135 degrees)
% Using plot instead of yline for Octave compatibility
xlim_vals = xlim();
plot(xlim_vals, [45, 45], 'k--', 'LineWidth', 1);
plot(xlim_vals, [135, 135], 'k--', 'LineWidth', 1);
hold off;
grid on;
xlabel('Input Angle \theta_2 (degrees)', 'FontSize', 11);
ylabel('Transmission Angle \mu (degrees)', 'FontSize', 11);
title('Transmission Angle vs Input Angle (Good range: 45-135°)', ...
      'FontSize', 12, 'FontWeight', 'bold');
xlim([0, 360]);
ylim([0, 180]);

fprintf('Plots generated.\n\n');

%% ========================= MECHANISM ANIMATION =========================

fprintf('Starting animation...\n');
fprintf('Press Ctrl+C to stop the animation.\n\n');

% Create animation figure
fig_anim = figure('Name', 'Four-Bar Mechanism Animation', ...
                  'NumberTitle', 'off', 'Position', [150, 150, 800, 600]);

% Calculate axis limits based on linkage dimensions
max_reach = link2 + link3;
axis_limit = max_reach * 1.2;

% Animation loop
frame_idx = 1;
while true
    % Get current angles
    theta2 = theta2_array(frame_idx);
    theta3 = theta3_array(frame_idx);
    theta4 = theta4_array(frame_idx);
    transmission_angle = transmission_angle_array(frame_idx);
    
    % Calculate joint positions
    point_A = [0, 0];                                    % Fixed point A (origin)
    point_B = [link2*cos(theta2), link2*sin(theta2)];   % Point B
    point_D = [link1, 0];                                % Fixed point D
    point_C = [point_D(1) + link4*cos(theta4), ...
               point_D(2) + link4*sin(theta4)];         % Point C
    
    % Plot mechanism
    clf;
    hold on;
    
    % Draw links
    plot([point_A(1), point_B(1)], [point_A(2), point_B(2)], 'b-', ...
         'LineWidth', 3, 'DisplayName', 'Link 2 (Input Crank)');
    plot([point_B(1), point_C(1)], [point_B(2), point_C(2)], 'g-', ...
         'LineWidth', 3, 'DisplayName', 'Link 3 (Coupler)');
    plot([point_C(1), point_D(1)], [point_C(2), point_D(2)], 'r-', ...
         'LineWidth', 3, 'DisplayName', 'Link 4 (Follower)');
    plot([point_A(1), point_D(1)], [point_A(2), point_D(2)], 'k-', ...
         'LineWidth', 4, 'DisplayName', 'Link 1 (Ground)');
    
    % Draw joints (pivots)
    plot(point_A(1), point_A(2), 'ko', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'k', 'DisplayName', 'Point A (Fixed)');
    plot(point_B(1), point_B(2), 'bo', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'b', 'DisplayName', 'Point B');
    plot(point_C(1), point_C(2), 'go', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'g', 'DisplayName', 'Point C');
    plot(point_D(1), point_D(2), 'ro', 'MarkerSize', 10, ...
         'MarkerFaceColor', 'r', 'DisplayName', 'Point D (Fixed)');
    
    % Draw coupler curve (trace of point C)
    if frame_idx > 1
        plot([point_D(1) + link4*cos(theta4_array(1:frame_idx)), point_C(1)], ...
             [point_D(2) + link4*sin(theta4_array(1:frame_idx)), point_C(2)], ...
             'm.', 'MarkerSize', 2, 'DisplayName', 'Coupler Curve');
    end
    
    % Set axis properties
    axis equal;
    axis([-axis_limit, axis_limit, -axis_limit, axis_limit]);
    grid on;
    
    % Add labels and title
    xlabel('X Position', 'FontSize', 11);
    ylabel('Y Position', 'FontSize', 11);
    title(sprintf('Four-Bar Mechanism Animation\n\\theta_2 = %.1f°, \\theta_3 = %.1f°, \\theta_4 = %.1f°, \\mu = %.1f°', ...
                  rad2deg(theta2), rad2deg(theta3), rad2deg(theta4), ...
                  rad2deg(transmission_angle)), ...
          'FontSize', 12, 'FontWeight', 'bold');
    
    % Add legend
    legend('Location', 'best', 'FontSize', 9);
    
    hold off;
    
    % Update display
    drawnow;
    
    % Control animation speed
    pause(1/fps);
    
    % Update frame index (loop continuously)
    frame_idx = frame_idx + 1;
    if frame_idx > num_frames
        frame_idx = 1;
    end
end

%% ======================= HELPER FUNCTIONS =============================

% -------------------------------------------------------------------------
% Function: check_grashof_condition
% -------------------------------------------------------------------------
% Description:
%   Determines whether a four-bar linkage satisfies the Grashof condition
%   and classifies the linkage type.
%
% Inputs:
%   L1, L2, L3, L4 - Link lengths
%
% Outputs:
%   is_grashof    - Boolean indicating if Grashof condition is satisfied
%   linkage_type  - String describing the linkage classification
% -------------------------------------------------------------------------
function [is_grashof, linkage_type] = check_grashof_condition(L1, L2, L3, L4)
    % Find shortest and longest links
    links = [L1, L2, L3, L4];
    s = min(links);  % Shortest link
    l = max(links);  % Longest link
    
    % Calculate sum of other two links
    p = sum(links) - s - l;  % Sum of intermediate links
    
    % Grashof criterion: s + l <= p + q, where p and q are the other links
    % Simplified: s + l <= sum of remaining two
    grashof_sum = s + l;
    other_sum = p;
    
    % Check Grashof condition
    if grashof_sum < other_sum
        is_grashof = true;
        
        % Determine specific type based on shortest link
        if L2 == s
            linkage_type = 'Grashof - Crank-Rocker (Input is shortest)';
        elseif L1 == s
            linkage_type = 'Grashof - Double-Crank (Ground is shortest)';
        elseif L4 == s
            linkage_type = 'Grashof - Rocker-Crank (Output is shortest)';
        else
            linkage_type = 'Grashof - Double-Rocker (Coupler is shortest)';
        end
    elseif grashof_sum == other_sum
        is_grashof = true;
        linkage_type = 'Special Grashof (Change-Point)';
    else
        is_grashof = false;
        linkage_type = 'Non-Grashof (Triple-Rocker)';
    end
end

% -------------------------------------------------------------------------
% Function: solve_four_bar_angles
% -------------------------------------------------------------------------
% Description:
%   Solves for the coupler (theta3) and follower (theta4) angles given
%   the input crank angle (theta2) using an analytical method based on
%   Freudenstein's equation. This method is more robust than iterative
%   Newton-Raphson for four-bar linkages.
%
% Inputs:
%   L1, L2, L3, L4 - Link lengths
%   theta2         - Input crank angle (radians)
%   theta3_init    - Initial guess for theta3 (used for branch selection)
%   theta4_init    - Initial guess for theta4 (used for branch selection)
%
% Outputs:
%   theta3 - Solved coupler angle (radians)
%   theta4 - Solved follower angle (radians)
% -------------------------------------------------------------------------
function [theta3, theta4] = solve_four_bar_angles(L1, L2, L3, L4, theta2, ...
                                                   theta3_init, theta4_init)
    % Use analytical solution method (Freudenstein's equation approach)
    % This is more reliable than Newton-Raphson for four-bar linkages
    
    % Calculate constants for Freudenstein's equation
    K1 = L1 / L2;
    K2 = L1 / L4;
    K3 = (L2^2 - L3^2 + L4^2 + L1^2) / (2 * L2 * L4);
    
    % Solve for theta4 using Freudenstein's equation
    % K1 + K2*cos(theta4) - K3 = cos(theta2 - theta4) + cos(theta2)*cos(theta4)
    % This reduces to: A*cos(theta4) + B*sin(theta4) + C = 0
    
    A = cos(theta2) - K1 - K2*cos(theta2) + K3;
    B = -2 * sin(theta2);
    C = K1 - (K2 + 1)*cos(theta2) + K3;
    
    % Solve using the formula: theta4 = 2*atan((−B ± sqrt(B^2 − 4*A*C))/(2*A))
    discriminant = B^2 - 4*A*C;
    
    if discriminant < 0
        % No real solution - use previous values or initial guess
        theta3 = theta3_init;
        theta4 = theta4_init;
        return;
    end
    
    % Two possible solutions - choose the one closest to initial guess
    sqrt_disc = sqrt(discriminant);
    
    if abs(A) > 1e-10
        theta4_sol1 = 2 * atan((-B + sqrt_disc) / (2*A));
        theta4_sol2 = 2 * atan((-B - sqrt_disc) / (2*A));
    else
        % Special case when A is close to zero
        if abs(B) > 1e-10
            theta4_sol1 = asin(-C / B);
            theta4_sol2 = pi - theta4_sol1;
        else
            theta4_sol1 = theta4_init;
            theta4_sol2 = theta4_init;
        end
    end
    
    % Choose solution closest to initial guess
    diff1 = abs(angle_diff(theta4_sol1, theta4_init));
    diff2 = abs(angle_diff(theta4_sol2, theta4_init));
    
    if diff1 < diff2
        theta4 = theta4_sol1;
    else
        theta4 = theta4_sol2;
    end
    
    % Now solve for theta3 using the loop closure equations
    % L2*cos(theta2) + L3*cos(theta3) = L1 + L4*cos(theta4)
    % L2*sin(theta2) + L3*sin(theta3) = L4*sin(theta4)
    
    x_target = L1 + L4*cos(theta4) - L2*cos(theta2);
    y_target = L4*sin(theta4) - L2*sin(theta2);
    
    % theta3 = atan2(y_target, x_target)
    theta3 = atan2(y_target, x_target);
end

% Helper function to calculate the angular difference
function diff = angle_diff(angle1, angle2)
    % Calculate the shortest angular difference between two angles
    diff = angle1 - angle2;
    diff = atan2(sin(diff), cos(diff));
end

% -------------------------------------------------------------------------
% Function: calculate_transmission_angle
% -------------------------------------------------------------------------
% Description:
%   Calculates the transmission angle (angle between coupler and follower).
%   The transmission angle indicates the effectiveness of force transmission.
%   Optimal range is 45-135 degrees.
%
% Inputs:
%   L2, L3, L4     - Link lengths
%   theta2         - Input crank angle (radians)
%   theta3         - Coupler angle (radians)
%   theta4         - Follower angle (radians)
%
% Outputs:
%   mu - Transmission angle (radians)
% -------------------------------------------------------------------------
function mu = calculate_transmission_angle(L2, L3, L4, theta2, theta3, theta4)
    % Calculate the angle between links 3 and 4
    % The transmission angle is the angle at point C between links 3 and 4
    
    % Vector from B to C (along link 3)
    vec_BC = [L3*cos(theta3), L3*sin(theta3)];
    
    % Vector from C to D (opposite direction of link 4)
    vec_CD = [-L4*cos(theta4), -L4*sin(theta4)];
    
    % Calculate angle between vectors using dot product
    dot_product = dot(vec_BC, vec_CD);
    mag_BC = norm(vec_BC);
    mag_CD = norm(vec_CD);
    
    % Transmission angle
    mu = acos(dot_product / (mag_BC * mag_CD));
    
    % Ensure angle is in [0, pi]
    if mu < 0
        mu = mu + pi;
    end
end
