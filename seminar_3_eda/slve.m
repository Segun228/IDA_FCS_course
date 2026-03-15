% Исходные данные
V1 = 73;
V2 = 259;
I1 = 2.16;
I2 = 2.29;
R1 = 98;
R2 = 43;
R3 = 64;
R4 = 63;
Rl = 219.8i;      % комплексное сопротивление
Rc = -43.7i;       % комплексное сопротивление

fprintf('Исходные данные:\n');
fprintf('V1 = %d, V2 = %d\n', V1, V2);
fprintf('I1 = %.2f, I2 = %.2f\n', I1, I2);
fprintf('R1 = %d, R2 = %d, R3 = %d, R4 = %d\n', R1, R2, R3, R4);
fprintf('Rl = %.1fi, Rc = %.1fi\n\n', imag(Rl), imag(Rc));

% Система уравнений:
% 1) I5 = I6 + I2
% 2) I2 + I3 = I4
% 3) I6 = I1 + I3
% 4) I5*R4 + I6*R1 + I3*Rl + I3*R3 + I4*Rc = V1 + V2

% Неизвестные: I3, I4, I5, I6
% Выразим всё через I3 из первых трех уравнений

% Из уравнения (3): I6 = I1 + I3
% Из уравнения (1): I5 = I6 + I2 = (I1 + I3) + I2 = I1 + I2 + I3
% Из уравнения (2): I4 = I2 + I3

% Подставляем в уравнение (4):
% (I1 + I2 + I3)*R4 + (I1 + I3)*R1 + I3*Rl + I3*R3 + (I2 + I3)*Rc = V1 + V2

fprintf('Уравнение относительно I3:\n');
fprintf('(I1 + I2 + I3)*R4 + (I1 + I3)*R1 + I3*Rl + I3*R3 + (I2 + I3)*Rc = V1 + V2\n\n');

% Группируем коэффициенты
% Коэффициент при I3
a = R4 + R1 + Rl + R3 + Rc;

% Свободный член (все что без I3)
b = R4*(I1 + I2) + R1*I1 + Rc*I2;

% Правая часть
c = V1 + V2;

% Решаем относительно I3: a*I3 + b = c  =>  I3 = (c - b)/a
I3 = (c - b) / a;

% Находим остальные токи
I6 = I1 + I3;
I5 = I6 + I2;  % или I1 + I2 + I3
I4 = I2 + I3;

% Выводим результаты
fprintf('=== РЕЗУЛЬТАТЫ ===\n');
fprintf('I3 = %.6f + %.6fi\n', real(I3), imag(I3));
fprintf('I4 = %.6f + %.6fi\n', real(I4), imag(I4));
fprintf('I5 = %.6f + %.6fi\n', real(I5), imag(I5));
fprintf('I6 = %.6f + %.6fi\n\n', real(I6), imag(I6));

% Выводим в полярной форме
fprintf('В полярной форме:\n');
fprintf('I3: модуль = %.6f, угол = %.6f°\n', abs(I3), angle(I3)*180/pi);
fprintf('I4: модуль = %.6f, угол = %.6f°\n', abs(I4), angle(I4)*180/pi);
fprintf('I5: модуль = %.6f, угол = %.6f°\n', abs(I5), angle(I5)*180/pi);
fprintf('I6: модуль = %.6f, угол = %.6f°\n\n', abs(I6), angle(I6)*180/pi);

% Проверка подстановкой в уравнение (4)
fprintf('=== ПРОВЕРКА ===\n');
left_side = I5*R4 + I6*R1 + I3*Rl + I3*R3 + I4*Rc;
right_side = V1 + V2;

fprintf('Левая часть (4): %.6f + %.6fi\n', real(left_side), imag(left_side));
fprintf('Правая часть (4): %.6f + %.6fi\n', real(right_side), imag(right_side));
fprintf('Разница: %.2e + %.2ei\n', real(left_side - right_side), imag(left_side - right_side));

% Проверка первых трех уравнений
fprintf('\nПроверка первых трех уравнений:\n');
fprintf('Ур.1 (I5 = I6 + I2): %.6f + %.6fi = %.6f + %.6fi\n', 
       real(I5), imag(I5), real(I6 + I2), imag(I6 + I2));
fprintf('Ур.2 (I2 + I3 = I4): %.6f + %.6fi = %.6f + %.6fi\n', 
       real(I2 + I3), imag(I2 + I3), real(I4), imag(I4));
fprintf('Ур.3 (I6 = I1 + I3): %.6f + %.6fi = %.6f + %.6fi\n', 
       real(I6), imag(I6), real(I1 + I3), imag(I1 + I3));

% Матричный метод для проверки
fprintf('\n=== МАТРИЧНЫЙ МЕТОД ===\n');
% Система из 4 уравнений с 4 неизвестными [I3, I4, I5, I6]
% Перепишем уравнения в стандартной форме:
% 1) -I5 + I6 = -I2
% 2) I3 - I4 = -I2
% 3) -I3 + I6 = I1
% 4) Rl*I3 + R3*I3 + Rc*I4 + R4*I5 + R1*I6 = V1 + V2

% Матрица коэффициентов
A = [0, 0, -1, 1;      % ур.1: -I5 + I6 = -I2
     1, -1, 0, 0;      % ур.2: I3 - I4 = -I2
     -1, 0, 0, 1;      % ур.3: -I3 + I6 = I1
     (Rl + R3), Rc, R4, R1];  % ур.4

% Вектор правой части
B = [-I2;
     -I2;
     I1;
     V1 + V2];

% Решаем систему
solution = A \ B;

I3_m = solution(1);
I4_m = solution(2);
I5_m = solution(3);
I6_m = solution(4);

fprintf('I3 = %.6f + %.6fi\n', real(I3_m), imag(I3_m));
fprintf('I4 = %.6f + %.6fi\n', real(I4_m), imag(I4_m));
fprintf('I5 = %.6f + %.6fi\n', real(I5_m), imag(I5_m));
fprintf('I6 = %.6f + %.6fi\n', real(I6_m), imag(I6_m));