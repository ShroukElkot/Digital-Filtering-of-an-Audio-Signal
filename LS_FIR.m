function Hd = LS_FIR(filter_length, n_points, Fpass_norm, Fstop_norm)

% MATLAB Code
% FIR least-squares Lowpass filter designed using the FIRLS function.
Wpass = 1;
Wstop = 1;
% Filter Order
N = filter_length; % Order of the filter

% Normalize frequencies to [0, 1]
normalized_freqs = [0 Fpass_norm Fstop_norm 1];

% Calculate the filter coefficients using the FIRLS function.
b = firls(N, normalized_freqs, [1 1 0 0], [Wpass Wstop]);
Hd = dfilt.dffir(b);

% Plot the frequency response of the designed filter
plot_magnitude_response(b, n_points);
Hd = b;

end

function plot_magnitude_response(b, n_points)
% Helper function to plot the magnitude response of the filter

% Frequency vector for plotting
f = linspace(0, 1, n_points); % Normalized frequency vector

% Frequency response of the filter
[H, f_response] = freqz(b, 1, n_points);

% Desired response (ideal lowpass filter)
Hd = zeros(1, n_points);
Hd(f_response <= max(f_response) * 0.2) = 1;  % Passband (gain = 1)
Hd(f_response > max(f_response) * 0.25) = 0;  % Stopband (gain = 0)

% Plot the magnitude response (linear scale)
figure;
subplot(2, 1, 1);
plot(f_response / pi, abs(H), 'b', 'LineWidth', 1.5); hold on;
plot(f, Hd, 'r--', 'LineWidth', 1.5); % Desired response
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude');
title('Magnitude Response (Linear Scale)');
legend('Designed Filter', 'Desired Response');
grid on;

% Plot the magnitude response (logarithmic scale)
subplot(2, 1, 2);
semilogy(f_response / pi, abs(H), 'b', 'LineWidth', 1.5); hold on;
semilogy(f, Hd, 'r--', 'LineWidth', 1.5); % Desired response
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
title('Magnitude Response (Logarithmic Scale)');
legend('Designed Filter', 'Desired Response');
grid on;
end
