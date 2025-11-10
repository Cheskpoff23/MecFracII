%% SÍNTESIS ANALÍTICA DE MECANISMO DE CUATRO BARRAS - 5 POSICIONES
% Proyecto: Generador de Trayectoria para Ciclo de Caminar
% Método: Síntesis Analítica de Norton (Capítulo 5, 5ª edición)
% Autor: Cheskpoff23
% Fecha: 2025-01-10

clear; close all; clc;

%% FASE 1: DEFINICIÓN DE PUNTOS DE PRECISIÓN
fprintf('========================================\n');
fprintf('SÍNTESIS DE MECANISMO GENERADOR DE TRAYECTORIA\n');
fprintf('========================================\n\n');

% Puntos del ciclo de caminar (en cm)
% Columnas: [X, Y]
precision_points = [
    0,  0;      % P1: Contacto Inicial (Tacón)
    10, 0;      % P2: Soporte Medio
    40, 0;      % P3: Despegue de Dedos
    50, 5;      % P4: Elevación Inicial
    60, 12;     % P5: Oscilación Media (Máx. Altura)
    70, 0       % P6: Contacto Final (Tacón) - Para verificación
];

% Usar solo los primeros 5 puntos para síntesis
n_synthesis = 5;
P_synthesis = precision_points(1:n_synthesis, :);

fprintf('Puntos de Precisión para Síntesis (n=5):\n');
for i = 1:n_synthesis
    fprintf('  P%d: (%.1f, %.1f) cm\n', i, P_synthesis(i,1), P_synthesis(i,2));
end
fprintf('\nPunto de Verificación:\n');
fprintf('  P6: (%.1f, %.1f) cm\n\n', precision_points(6,1), precision_points(6,2));

%% FASE 2: VECTORES DE DESPLAZAMIENTO (Notación Compleja)
% Establecer P1 como origen
P1 = P_synthesis(1,:);
P_complex = complex(P_synthesis(:,1), P_synthesis(:,2));

% Vectores de desplazamiento P_k1 = P_k - P_1
P_k1 = P_complex - P_complex(1);

fprintf('Vectores de Desplazamiento P_k1 (Notación Compleja):\n');
for k = 2:n_synthesis
    fprintf('  P_%d1 = %.1f + j%.1f\n', k, real(P_k1(k)), imag(P_k1(k)));
end
fprintf('\n');

%% FASE 3: PRESCRIPCIÓN DE ÁNGULOS DEL ACOPLADOR
% ELECCIÓN LIBRE DEL DISEÑADOR: ángulos alpha_k (rotación del acoplador)
% Primera aproximación: mantener el acoplador paralelo (alpha = 0)
% Para explorar: variar estos ángulos produce diferentes mecanismos

alpha_deg = [0, 0, 0, 0];  % Para k=2,3,4,5 (en grados)
alpha_rad = deg2rad(alpha_deg);

fprintf('Ángulos del Acoplador Prescritos (alpha_k):\n');
for k = 2:n_synthesis
    fprintf('  alpha_%d = %.1f° (%.4f rad)\n', k, alpha_deg(k-1), alpha_rad(k-1));
end
fprintf('\n');

%% FASE 4: SÍNTESIS DE DÍADA IZQUIERDA (WZ)
fprintf('--- Síntesis de Díada Izquierda (WZ) ---\n');

% Estimación inicial para [Wx, Wy, Zx, Zy, beta2, beta3, beta4, beta5]
x0_WZ = [-30; -10; 30; 10; deg2rad(20); deg2rad(40); deg2rad(50); deg2rad(60)];

% Resolver sistema no lineal usando Newton-Raphson
[solution_WZ, converged_WZ, iterations_WZ] = newton_raphson_solver(...
    x0_WZ, P_k1(2:5), alpha_rad, 'WZ');

if converged_WZ
    fprintf('✓ Convergencia exitosa en %d iteraciones\n', iterations_WZ);
    
    % Extraer componentes
    W = complex(solution_WZ(1), solution_WZ(2));
    Z = complex(solution_WZ(3), solution_WZ(4));
    beta_rad = solution_WZ(5:8);
    beta_deg = rad2deg(beta_rad);
    
    fprintf('  Vector W: %.4f + j%.4f (|W| = %.4f cm)\n', real(W), imag(W), abs(W));
    fprintf('  Vector Z: %.4f + j%.4f (|Z| = %.4f cm)\n', real(Z), imag(Z), abs(Z));
else
    error('❌ Newton-Raphson no convergió para díada WZ. Intente otra semilla.');
end

%% FASE 5: SÍNTESIS DE DÍADA DERECHA (US)
fprintf('\n--- Síntesis de Díada Derecha (US) ---\n');

% Prescribir ángulos gamma diferentes a beta para evitar pivotes coincidentes
gamma_deg = alpha_deg + 10;  % Offset de 10 grados
gamma_rad = deg2rad(gamma_deg);

% Estimación inicial para [Ux, Uy, Sx, Sy, gamma2, gamma3, gamma4, gamma5]
x0_US = [-20; 15; 20; -15; deg2rad(30); deg2rad(50); deg2rad(60); deg2rad(70)];

% Resolver sistema no lineal
[solution_US, converged_US, iterations_US] = newton_raphson_solver(...
    x0_US, P_k1(2:5), gamma_rad, 'US');

if converged_US
    fprintf('✓ Convergencia exitosa en %d iteraciones\n', iterations_US);
    
    % Extraer componentes
    U = complex(solution_US(1), solution_US(2));
    S = complex(solution_US(3), solution_US(4));
    gamma_rad = solution_US(5:8);
    gamma_deg = rad2deg(gamma_rad);
    
    fprintf('  Vector U: %.4f + j%.4f (|U| = %.4f cm)\n', real(U), imag(U), abs(U));
    fprintf('  Vector S: %.4f + j%.4f (|S| = %.4f cm)\n', real(S), imag(S), abs(S));
else
    error('❌ Newton-Raphson no convergió para díada US. Intente otra semilla.');
end

%% FASE 6: DEFINICIÓN DEL MECANISMO PRIMARIO (COGNADO 1)
fprintf('\n========================================\n');
fprintf('MECANISMO PRIMARIO (COGNADO 1)\n');
fprintf('========================================\n');

% Posiciones de pivotes (P1 es el origen)
P1_pos = 0 + 0i;
A1_pos = -Z;
B1_pos = -S;
O2_pos = -Z - W;
O4_pos = -S - U;

% Longitudes de eslabones
a = abs(W);  % Eslabón 2 (Entrada): O2-A1
b = abs(B1_pos - A1_pos);  % Eslabón 3 (Acoplador): A1-B1
c = abs(U);  % Eslabón 4 (Salida): O4-B1
d = abs(O4_pos - O2_pos);  % Eslabón 1 (Bancada): O2-O4

fprintf('\nPivotes Fijos:\n');
fprintf('  O2: (%.4f, %.4f) cm\n', real(O2_pos), imag(O2_pos));
fprintf('  O4: (%.4f, %.4f) cm\n', real(O4_pos), imag(O4_pos));
fprintf('\nPivotes Móviles (Posición 1):\n');
fprintf('  A1: (%.4f, %.4f) cm\n', real(A1_pos), imag(A1_pos));
fprintf('  B1: (%.4f, %.4f) cm\n', real(B1_pos), imag(B1_pos));
fprintf('\nLongitudes de Eslabones:\n');
fprintf('  a (L2, Entrada):   %.4f cm\n', a);
fprintf('  b (L3, Acoplador): %.4f cm\n', b);
fprintf('  c (L4, Salida):    %.4f cm\n', c);
fprintf('  d (L1, Bancada):   %.4f cm\n', d);

%% FASE 7: GUARDAR DATOS DEL MECANISMO
mechanism_data.W = W;
mechanism_data.Z = Z;
mechanism_data.U = U;
mechanism_data.S = S;
mechanism_data.O2 = O2_pos;
mechanism_data.O4 = O4_pos;
mechanism_data.A1 = A1_pos;
mechanism_data.B1 = B1_pos;
mechanism_data.P1 = P1_pos;
mechanism_data.a = a;
mechanism_data.b = b;
mechanism_data.c = c;
mechanism_data.d = d;
mechanism_data.precision_points = precision_points;
mechanism_data.alpha_rad = alpha_rad;

% Guardar en archivo .mat
save('mechanism_primary.mat', 'mechanism_data');
fprintf('\n✓ Datos del mecanismo guardados en "mechanism_primary.mat"\n');

%% FASE 8: VISUALIZACIÓN INICIAL
figure('Name', 'Mecanismo Primario - Posición Inicial', 'Position', [100, 100, 800, 600]);
hold on; grid on; axis equal;

% Dibujar eslabones
plot([real(O2_pos), real(A1_pos)], [imag(O2_pos), imag(A1_pos)], 'b-', 'LineWidth', 3);
plot([real(A1_pos), real(B1_pos)], [imag(A1_pos), imag(B1_pos)], 'r-', 'LineWidth', 3);
plot([real(B1_pos), real(O4_pos)], [imag(B1_pos), imag(O4_pos)], 'g-', 'LineWidth', 3);
plot([real(O2_pos), real(O4_pos)], [imag(O2_pos), imag(O4_pos)], 'k-', 'LineWidth', 4);

% Dibujar pivotes
plot(real(O2_pos), imag(O2_pos), 'ks', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
plot(real(O4_pos), imag(O4_pos), 'ks', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
plot(real(A1_pos), imag(A1_pos), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
plot(real(B1_pos), imag(B1_pos), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot(real(P1_pos), imag(P1_pos), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');

% Dibujar trayectoria deseada
plot(precision_points(:,1), precision_points(:,2), 'mo--', 'LineWidth', 1.5, 'MarkerSize', 8);

% Etiquetas
text(real(O2_pos), imag(O2_pos)-3, 'O_2', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(real(O4_pos), imag(O4_pos)-3, 'O_4', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(real(A1_pos), imag(A1_pos)+3, 'A_1', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(real(B1_pos), imag(B1_pos)+3, 'B_1', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(real(P1_pos)+2, imag(P1_pos), 'P_1', 'FontSize', 12);

xlabel('X (cm)', 'FontSize', 12);
ylabel('Y (cm)', 'FontSize', 12);
title('Mecanismo de Cuatro Barras - Posición Inicial', 'FontSize', 14);
legend('L2 (Entrada)', 'L3 (Acoplador)', 'L4 (Salida)', 'L1 (Bancada)', ...
       'Pivotes Fijos', '', '', '', 'Punto P', 'Trayectoria Deseada', 'Location', 'best');

fprintf('\n========================================\n');
fprintf('SÍNTESIS COMPLETADA\n');
fprintf('Ejecute "cognate_derivation.m" para derivar los cognados.\n');
fprintf('========================================\n');
