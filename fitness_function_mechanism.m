function error = fitness_function_mechanism(params, P_desired, alpha_rad)
% FITNESS_FUNCTION_MECHANISM - Función de aptitud para el Algoritmo Genético
% Calcula el error cuadrático entre la trayectoria deseada y la generada
%
% Entradas:
%   params - Vector de parámetros [Wx, Wy, Zx, Zy, beta2, beta3, beta4, beta5]
%   P_desired - Vectores de desplazamiento deseados (P_21, P_31, P_41, P_51)
%   alpha_rad - Ángulos del acoplador prescritos (4x1)
%
% Salida:
%   error - Suma de errores cuadráticos (SSE)

    % Extraer parámetros
    W = complex(params(1), params(2));
    Z = complex(params(3), params(4));
    beta = params(5:8);
    
    % Inicializar error
    error = 0;
    
    % Para cada posición k=2,3,4,5
    for k = 1:4
        % Ecuación de forma estándar de Norton:
        % W*(exp(j*beta_k)-1) + Z*(exp(j*alpha_k)-1) = P_k1
        
        P_generated = W*(exp(1j*beta(k))-1) + Z*(exp(1j*alpha_rad(k))-1);
        
        % Error de posición
        delta_P = P_generated - P_desired(k+1);
        
        % Acumular error cuadrático
        error = error + abs(delta_P)^2;
    end
    
    % Penalización adicional: restricciones geométricas
    % 1. Longitudes mínimas de eslabones
    min_link_length = 1.0;
    if abs(W) < min_link_length
        error = error + 1000;
    end
    if abs(Z) < min_link_length
        error = error + 1000;
    end
    
    % 2. Verificar que los ángulos beta estén en orden creciente
    for i = 1:3
        if beta(i+1) <= beta(i)
            error = error + 1000;
        end
    end
    
end
