% =========================================================================
% TEST SCRIPT FOR FOUR-BAR MECHANISM FUNCTIONS
% =========================================================================
%
% This script tests the individual functions of the four-bar mechanism
% analysis without running the full animation. Use this to verify that
% the functions work correctly.
%
% =========================================================================

function test_four_bar()
    % Main test function
    test_main();
end

function test_main()
    fprintf('========================================\n');
    fprintf('FOUR-BAR MECHANISM - FUNCTION TESTS\n');
    fprintf('========================================\n\n');

%% Test 1: Grashof Condition Check
fprintf('Test 1: Grashof Condition Check\n');
fprintf('-------------------------------\n');

% Test case 1: Crank-Rocker (Grashof)
L1 = 6.0; L2 = 2.0; L3 = 5.0; L4 = 4.5;
[is_grashof, linkage_type] = check_grashof_condition(L1, L2, L3, L4);
fprintf('Test Case 1 (Crank-Rocker):\n');
fprintf('  Links: %.1f, %.1f, %.1f, %.1f\n', L1, L2, L3, L4);
fprintf('  Grashof: %s\n', mat2str(is_grashof));
fprintf('  Type: %s\n\n', linkage_type);

% Test case 2: Double-Crank (Grashof)
L1 = 3.0; L2 = 5.0; L3 = 6.0; L4 = 5.5;
[is_grashof, linkage_type] = check_grashof_condition(L1, L2, L3, L4);
fprintf('Test Case 2 (Double-Crank):\n');
fprintf('  Links: %.1f, %.1f, %.1f, %.1f\n', L1, L2, L3, L4);
fprintf('  Grashof: %s\n', mat2str(is_grashof));
fprintf('  Type: %s\n\n', linkage_type);

% Test case 3: Non-Grashof
L1 = 10.0; L2 = 3.0; L3 = 5.0; L4 = 4.0;
[is_grashof, linkage_type] = check_grashof_condition(L1, L2, L3, L4);
fprintf('Test Case 3 (Non-Grashof):\n');
fprintf('  Links: %.1f, %.1f, %.1f, %.1f\n', L1, L2, L3, L4);
fprintf('  Grashof: %s\n', mat2str(is_grashof));
fprintf('  Type: %s\n\n', linkage_type);

%% Test 2: Angle Solver (Newton-Raphson)
fprintf('Test 2: Newton-Raphson Angle Solver\n');
fprintf('------------------------------------\n');

% Use crank-rocker configuration
L1 = 6.0; L2 = 2.0; L3 = 5.0; L4 = 4.5;

% Test at several input angles
test_angles = [0, pi/4, pi/2, 3*pi/4, pi];

for i = 1:length(test_angles)
    theta2 = test_angles(i);
    [theta3, theta4] = solve_four_bar_angles(L1, L2, L3, L4, theta2, pi/4, pi/4);
    
    fprintf('Input angle θ2 = %.4f rad (%.1f°)\n', theta2, rad2deg(theta2));
    fprintf('  Coupler θ3 = %.4f rad (%.1f°)\n', theta3, rad2deg(theta3));
    fprintf('  Follower θ4 = %.4f rad (%.1f°)\n', theta4, rad2deg(theta4));
    
    % Verify closure equations
    x_closure = L2*cos(theta2) + L3*cos(theta3) - L4*cos(theta4) - L1;
    y_closure = L2*sin(theta2) + L3*sin(theta3) - L4*sin(theta4);
    error = sqrt(x_closure^2 + y_closure^2);
    
    fprintf('  Closure error = %.6e\n\n', error);
end

%% Test 3: Transmission Angle
fprintf('Test 3: Transmission Angle Calculation\n');
fprintf('---------------------------------------\n');

L1 = 6.0; L2 = 2.0; L3 = 5.0; L4 = 4.5;

for i = 1:length(test_angles)
    theta2 = test_angles(i);
    [theta3, theta4] = solve_four_bar_angles(L1, L2, L3, L4, theta2, pi/4, pi/4);
    mu = calculate_transmission_angle(L2, L3, L4, theta2, theta3, theta4);
    
    fprintf('θ2 = %.1f°: Transmission angle μ = %.1f°', ...
            rad2deg(theta2), rad2deg(mu));
    
    % Check if in good range (45-135 degrees)
    if rad2deg(mu) >= 45 && rad2deg(mu) <= 135
        fprintf(' [GOOD]\n');
    else
        fprintf(' [POOR]\n');
    end
end

fprintf('\n');

%% Test 4: Complete Cycle Analysis
fprintf('Test 4: Complete Rotation Cycle\n');
fprintf('--------------------------------\n');

L1 = 6.0; L2 = 2.0; L3 = 5.0; L4 = 4.5;

% Calculate for full rotation
num_points = 36;  % Every 10 degrees
theta2_array = linspace(0, 2*pi, num_points);
theta3_array = zeros(1, num_points);
theta4_array = zeros(1, num_points);
mu_array = zeros(1, num_points);

theta3_guess = pi/4;
theta4_guess = pi/4;

for i = 1:num_points
    theta2 = theta2_array(i);
    [theta3, theta4] = solve_four_bar_angles(L1, L2, L3, L4, theta2, ...
                                             theta3_guess, theta4_guess);
    mu = calculate_transmission_angle(L2, L3, L4, theta2, theta3, theta4);
    
    theta3_array(i) = theta3;
    theta4_array(i) = theta4;
    mu_array(i) = mu;
    
    theta3_guess = theta3;
    theta4_guess = theta4;
end

fprintf('Completed %d position calculations\n', num_points);
fprintf('θ3 range: %.1f° to %.1f°\n', min(rad2deg(theta3_array)), ...
        max(rad2deg(theta3_array)));
fprintf('θ4 range: %.1f° to %.1f°\n', min(rad2deg(theta4_array)), ...
        max(rad2deg(theta4_array)));
fprintf('μ range: %.1f° to %.1f°\n\n', min(rad2deg(mu_array)), ...
        max(rad2deg(mu_array)));

%% Test 5: Plot Results
fprintf('Test 5: Generating Test Plots\n');
fprintf('------------------------------\n');

figure('Name', 'Four-Bar Mechanism Test Results', 'NumberTitle', 'off');

subplot(3, 1, 1);
plot(rad2deg(theta2_array), rad2deg(theta3_array), 'b-', 'LineWidth', 2);
grid on;
xlabel('Input Angle θ_2 (degrees)');
ylabel('Coupler Angle θ_3 (degrees)');
title('Coupler Angle vs Input Angle');

subplot(3, 1, 2);
plot(rad2deg(theta2_array), rad2deg(theta4_array), 'r-', 'LineWidth', 2);
grid on;
xlabel('Input Angle θ_2 (degrees)');
ylabel('Follower Angle θ_4 (degrees)');
title('Follower Angle vs Input Angle');

subplot(3, 1, 3);
plot(rad2deg(theta2_array), rad2deg(mu_array), 'g-', 'LineWidth', 2);
hold on;
% Using plot instead of yline for Octave compatibility
xlim_vals = [0, 360];
plot(xlim_vals, [45, 45], 'k--');
plot(xlim_vals, [135, 135], 'k--');
hold off;
grid on;
xlabel('Input Angle θ_2 (degrees)');
ylabel('Transmission Angle μ (degrees)');
title('Transmission Angle vs Input Angle');

fprintf('Test plots generated successfully.\n\n');

fprintf('========================================\n');
fprintf('ALL TESTS COMPLETED\n');
fprintf('========================================\n');

end  % End of test_main function

%% Helper Functions (copied from main script for standalone testing)

function [is_grashof, linkage_type] = check_grashof_condition(L1, L2, L3, L4)
    links = [L1, L2, L3, L4];
    s = min(links);
    l = max(links);
    p = sum(links) - s - l;
    
    grashof_sum = s + l;
    other_sum = p;
    
    if grashof_sum < other_sum
        is_grashof = true;
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

function [theta3, theta4] = solve_four_bar_angles(L1, L2, L3, L4, theta2, ...
                                                   theta3_init, theta4_init)
    % Use analytical solution method (Freudenstein's equation approach)
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
    
    diff1 = abs(angle_diff(theta4_sol1, theta4_init));
    diff2 = abs(angle_diff(theta4_sol2, theta4_init));
    
    if diff1 < diff2
        theta4 = theta4_sol1;
    else
        theta4 = theta4_sol2;
    end
    
    x_target = L1 + L4*cos(theta4) - L2*cos(theta2);
    y_target = L4*sin(theta4) - L2*sin(theta2);
    
    theta3 = atan2(y_target, x_target);
end

function diff = angle_diff(angle1, angle2)
    diff = angle1 - angle2;
    diff = atan2(sin(diff), cos(diff));
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
