% Исходные данные
ZR1 = 15 + 0j;
Z32 = 81 + 452.3893j;
Z22 = 77 - 49.1219j;
ZL1 = 0 + 251.3274j;

% Функция параллельного соединения
parallel = @(Z1, Z2) (Z1 .* Z2) ./ (Z1 + Z2);

% Расчёт A11
% A11 = ((ZR1 + Z32) * (Z22 + (ZL1||(ZR1 + Z32)))) / (Z32 * (ZL1||(ZR1 + Z32)))

% Шаг 1: ZL1 || (ZR1 + Z32)
ZL1_par_ZR1_Z32 = parallel(ZL1, (ZR1 + Z32));
printf('ZL1 || (ZR1 + Z32) = %.4f %+.4fj Ом\n', real(ZL1_par_ZR1_Z32), imag(ZL1_par_ZR1_Z32));

% Шаг 2: Числитель
denominator = (ZR1 + Z32) * (Z22 + ZL1_par_ZR1_Z32);
printf('Числитель = %.4f %+.4fj\n', real(numerator), imag(numerator));

% Шаг 3: Знаменатель
numerator = Z32 * ZL1_par_ZR1_Z32;
printf('Знаменатель = %.4f %+.4fj\n', real(denominator), imag(denominator));

% Шаг 4: A11
A11 = numerator / denominator;

printf('\n========================================\n');
printf('A11 = %.4f %+.4fj\n', real(A11), imag(A11));
printf('|A11| = %.4f\n', abs(A11));
printf('arg(A11) = %.4f°\n', angle(A11) * 180 / pi);
printf('========================================\n');
