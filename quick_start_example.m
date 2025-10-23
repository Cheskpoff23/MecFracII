% =========================================================================
% QUICK START EXAMPLE - Four-Bar Mechanism Analysis
% =========================================================================
%
% This script demonstrates several example configurations of four-bar
% linkages. Comment/uncomment different examples to try them.
%
% =========================================================================

function quick_start_example()
    % Main function wrapper
    run_example();
end

function run_example()

%% Select an example configuration (uncomment one)

% EXAMPLE 1: Crank-Rocker Mechanism (DEFAULT)
% Input crank makes full rotations, output rocker oscillates
link1 = 6.0;
link2 = 2.0;
link3 = 5.0;
link4 = 4.5;

% EXAMPLE 2: Double-Crank Mechanism (Drag-Link)
% Both input and output can make full rotations
% link1 = 3.0;
% link2 = 5.0;
% link3 = 6.0;
% link4 = 5.5;

% EXAMPLE 3: Non-Grashof Mechanism (Triple-Rocker)
% No link can make a complete rotation
% link1 = 10.0;
% link2 = 3.0;
% link3 = 5.0;
% link4 = 4.0;

% EXAMPLE 4: Parallel Crank Mechanism
% Special case where coupler remains parallel
% link1 = 5.0;
% link2 = 3.0;
% link3 = 5.0;
% link4 = 3.0;

%% Animation settings
fps = 30;               % Animation speed (frames per second)
num_frames = 180;       % Number of frames (180 = half resolution)

%% Run the analysis

fprintf('========================================\n');
fprintf('FOUR-BAR MECHANISM QUICK START\n');
fprintf('========================================\n\n');

fprintf('Selected Configuration:\n');
fprintf('  Ground link:  %.2f\n', link1);
fprintf('  Input crank:  %.2f\n', link2);
fprintf('  Coupler:      %.2f\n', link3);
fprintf('  Follower:     %.2f\n\n', link4);

% Check Grashof condition
[is_grashof, linkage_type] = check_grashof_condition(link1, link2, link3, link4);

fprintf('Mechanism Type: %s\n', linkage_type);
fprintf('Can input rotate continuously? %s\n\n', mat2str(is_grashof));

% Calculate positions for all angles
theta2_array = linspace(0, 2*pi, num_frames);
theta3_array = zeros(1, num_frames);
theta4_array = zeros(1, num_frames);
mu_array = zeros(1, num_frames);

theta3_guess = pi/4;
theta4_guess = pi/4;

fprintf('Calculating positions... ');
for i = 1:num_frames
    theta2 = theta2_array(i);
    [theta3, theta4] = solve_four_bar_angles(link1, link2, link3, link4, ...
                                             theta2, theta3_guess, theta4_guess);
    mu = calculate_transmission_angle(link2, link3, link4, theta2, theta3, theta4);
    
    theta3_array(i) = theta3;
    theta4_array(i) = theta4;
    mu_array(i) = mu;
    
    theta3_guess = theta3;
    theta4_guess = theta4;
end
fprintf('Done!\n\n');

% Display results summary
fprintf('Results Summary:\n');
fprintf('  Coupler angle range:      %.1f° to %.1f°\n', ...
        min(rad2deg(theta3_array)), max(rad2deg(theta3_array)));
fprintf('  Follower angle range:     %.1f° to %.1f°\n', ...
        min(rad2deg(theta4_array)), max(rad2deg(theta4_array)));
fprintf('  Transmission angle range: %.1f° to %.1f°\n\n', ...
        min(rad2deg(mu_array)), max(rad2deg(mu_array)));

% Check transmission angle quality
mu_min = min(rad2deg(mu_array));
mu_max = max(rad2deg(mu_array));
if mu_min >= 45 && mu_max <= 135
    fprintf('✓ Transmission angle is GOOD (stays within 45-135°)\n\n');
elseif mu_min >= 30 && mu_max <= 150
    fprintf('⚠ Transmission angle is ACCEPTABLE (stays within 30-150°)\n\n');
else
    fprintf('✗ Transmission angle is POOR (goes outside 30-150°)\n');
    fprintf('  Consider redesigning the linkage for better force transmission.\n\n');
end

% Plot results
figure('Name', 'Four-Bar Analysis', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
plot(rad2deg(theta2_array), rad2deg(theta3_array), 'b-', 'LineWidth', 2);
grid on;
xlabel('Input Angle (degrees)');
ylabel('Coupler Angle (degrees)');
title('Coupler Motion');

subplot(1, 3, 2);
plot(rad2deg(theta2_array), rad2deg(theta4_array), 'r-', 'LineWidth', 2);
grid on;
xlabel('Input Angle (degrees)');
ylabel('Follower Angle (degrees)');
title('Follower Motion');

subplot(1, 3, 3);
plot(rad2deg(theta2_array), rad2deg(mu_array), 'g-', 'LineWidth', 2);
hold on;
plot([0, 360], [45, 45], 'k--', 'LineWidth', 1);
plot([0, 360], [135, 135], 'k--', 'LineWidth', 1);
hold off;
grid on;
xlabel('Input Angle (degrees)');
ylabel('Transmission Angle (degrees)');
title('Transmission Angle');
xlim([0, 360]);
ylim([0, 180]);

fprintf('Plots generated. Close plot windows to start animation.\n');
fprintf('Press Ctrl+C to stop animation.\n\n');

% Wait for user to view plots
pause(2);

% Simple animation (one complete cycle)
figure('Name', 'Mechanism Animation', 'NumberTitle', 'off', 'Position', [150, 150, 600, 600]);

max_reach = link2 + link3;
axis_limit = max_reach * 1.2;

for i = 1:num_frames
    theta2 = theta2_array(i);
    theta3 = theta3_array(i);
    theta4 = theta4_array(i);
    
    % Calculate joint positions
    A = [0, 0];
    B = [link2*cos(theta2), link2*sin(theta2)];
    D = [link1, 0];
    C = [D(1) + link4*cos(theta4), D(2) + link4*sin(theta4)];
    
    % Plot mechanism
    clf;
    hold on;
    
    % Draw links
    plot([A(1), B(1)], [A(2), B(2)], 'b-', 'LineWidth', 3);
    plot([B(1), C(1)], [B(2), C(2)], 'g-', 'LineWidth', 3);
    plot([C(1), D(1)], [C(2), D(2)], 'r-', 'LineWidth', 3);
    plot([A(1), D(1)], [A(2), D(2)], 'k-', 'LineWidth', 4);
    
    % Draw joints
    plot(A(1), A(2), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    plot(B(1), B(2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    plot(C(1), C(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
    plot(D(1), D(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    % Draw coupler trace
    if i > 1
        C_trace = [D(1) + link4*cos(theta4_array(1:i)); ...
                   D(2) + link4*sin(theta4_array(1:i))];
        plot(C_trace(1,:), C_trace(2,:), 'm.', 'MarkerSize', 2);
    end
    
    axis equal;
    axis([-axis_limit, axis_limit, -axis_limit, axis_limit]);
    grid on;
    xlabel('X Position');
    ylabel('Y Position');
    title(sprintf('Frame %d/%d - θ2=%.1f°', i, num_frames, rad2deg(theta2)));
    
    hold off;
    drawnow;
    pause(1/fps);
end

fprintf('\nAnimation complete!\n');
fprintf('To run with different configuration, edit the link lengths and run again.\n');

end  % End of run_example function

%% Helper Functions (must be at end of file)

function [is_grashof, linkage_type] = check_grashof_condition(L1, L2, L3, L4)
    links = [L1, L2, L3, L4];
    s = min(links);
    l = max(links);
    p = sum(links) - s - l;
    
    if s + l < p
        is_grashof = true;
        if L2 == s
            linkage_type = 'Grashof - Crank-Rocker';
        elseif L1 == s
            linkage_type = 'Grashof - Double-Crank';
        elseif L4 == s
            linkage_type = 'Grashof - Rocker-Crank';
        else
            linkage_type = 'Grashof - Double-Rocker';
        end
    elseif s + l == p
        is_grashof = true;
        linkage_type = 'Special Grashof (Change-Point)';
    else
        is_grashof = false;
        linkage_type = 'Non-Grashof (Triple-Rocker)';
    end
end

function [theta3, theta4] = solve_four_bar_angles(L1, L2, L3, L4, theta2, theta3_init, theta4_init)
    K1 = L1 / L2;
    K2 = L1 / L4;
    K3 = (L2^2 - L3^2 + L4^2 + L1^2) / (2 * L2 * L4);
    
    A = cos(theta2) - K1 - K2*cos(theta2) + K3;
    B = -2 * sin(theta2);
    C = K1 - (K2 + 1)*cos(theta2) + K3;
    
    discriminant = B^2 - 4*A*C;
    
    if discriminant < 0
        theta3 = theta3_init;
        theta4 = theta4_init;
        return;
    end
    
    sqrt_disc = sqrt(discriminant);
    
    if abs(A) > 1e-10
        theta4_sol1 = 2 * atan((-B + sqrt_disc) / (2*A));
        theta4_sol2 = 2 * atan((-B - sqrt_disc) / (2*A));
    else
        if abs(B) > 1e-10
            theta4_sol1 = asin(-C / B);
            theta4_sol2 = pi - theta4_sol1;
        else
            theta4_sol1 = theta4_init;
            theta4_sol2 = theta4_init;
        end
    end
    
    % Calculate angular differences
    diff1_val = theta4_sol1 - theta4_init;
    diff1 = abs(atan2(sin(diff1_val), cos(diff1_val)));
    
    diff2_val = theta4_sol2 - theta4_init;
    diff2 = abs(atan2(sin(diff2_val), cos(diff2_val)));
    
    if diff1 < diff2
        theta4 = theta4_sol1;
    else
        theta4 = theta4_sol2;
    end
    
    x_target = L1 + L4*cos(theta4) - L2*cos(theta2);
    y_target = L4*sin(theta4) - L2*sin(theta2);
    
    theta3 = atan2(y_target, x_target);
end

function mu = calculate_transmission_angle(L2, L3, L4, theta2, theta3, theta4)
    vec_BC = [L3*cos(theta3), L3*sin(theta3)];
    vec_CD = [-L4*cos(theta4), -L4*sin(theta4)];
    
    dot_product = dot(vec_BC, vec_CD);
    mag_BC = norm(vec_BC);
    mag_CD = norm(vec_CD);
    
    mu = acos(dot_product / (mag_BC * mag_CD));
    
    if mu < 0
        mu = mu + pi;
    end
end
