function Hd = WLS_FIR(filter_length, n_points, Fpass_norm, Fstop_norm, w_pass, w_trans, w_stop)

% Desired Frequency Response and Weights
freq_axis = pi * linspace(0, 1, n_points);  % Frequency range [0, pi]
H_desired = zeros(size(freq_axis));  % Initialize desired frequency response array
weights = zeros(size(freq_axis));  % Initialize weights array
N = filter_length;  % Filter length (number of taps)

% Loop through the frequency axis to assign desired response and weights
for i = 1:length(freq_axis)
    freq_normalized = freq_axis(i) / pi;  % Normalize frequency to range [0, 1]
    
    % Check which frequency range the current point falls into
    if freq_normalized <= Fpass_norm
        % Passband: desired response is 1, weight is w_pass
        H_desired(i) = 1;
        weights(i) = w_pass;
    elseif freq_normalized <= Fstop_norm
        % Transition band: desired response is 0, weight is w_trans
        H_desired(i) = 0; 
        weights(i) = w_trans;
    else
        % Stopband: desired response is 0, weight is w_stop
        H_desired(i) = 0;
        weights(i) = w_stop;
    end
end

% Plot Desired Frequency Response
figure;
plot(freq_axis/pi, abs(H_desired), 'LineWidth', 1.5);  % Plot magnitude of the desired response
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude |H_d(\omega)|');  
title('Desired Frequency Response |H_d(\omega)|');
grid on;

% Construct Filter Matrix F
L = (0:N-1)';  % Define the filter taps (indices from 0 to N-1)
omega_axis = linspace(0, pi, n_points);  % Define the omega axis for frequency bins (make sure it matches the length of H_desired)
F_initial = L * omega_axis;  % Compute the product of filter taps and omega_axis to get \(\omega l\)
F = 2 * cos(F_initial);  % Generate the cosine matrix
F(:, 1) = F(:, 1) / 2;  % Adjust the DC term (first column) to avoid doubling
F = F';  % Transpose the matrix to have correct dimensions

% Construct the Weight Matrix W
W = diag(weights);  % Create a diagonal matrix of the weights

% Solve for Filter Coefficients using the Weighted Least Squares (WLS) approach
h = (F' * W * F) \ (F' * W * H_desired(:));  % Solve for filter coefficients h

% Make the filter coefficients symmetric for FIR design
h = h';  % Convert h to a row vector
h_symmetric = [fliplr(h(2:end)) h];  % Reflect the non-DC part to make the filter symmetric

% Frequency Response of the Designed Filter
filter_response = abs(fft(h_symmetric, 1024));  % Compute the FFT of the symmetric filter coefficients
freqnorm_axis = linspace(0, 1, 1024);  % Define normalized frequency axis for plotting (use 1024 for better resolution)

    % Plot Designed Filter Response
    figure;
    subplot(2, 1, 1);
    plot(freqnorm_axis, filter_response, 'LineWidth', 1.5);
    hold on;
    plot(freq_axis/pi, abs(H_desired), 'r--', 'LineWidth', 1.5);
    title('Designed Filter vs Desired Frequency Response');
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Magnitude');
    legend('Designed Filter', 'Desired Response');
    grid on;

    % Logarithmic Scale
    subplot(2, 1, 2);
    semilogy(freqnorm_axis, filter_response, 'LineWidth', 1.5);
    hold on;
    semilogy(freq_axis/pi, abs(H_desired), 'r--', 'LineWidth', 1.5);
    title('Log-Scale Magnitude Response');
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Magnitude (dB)');
    legend('Designed Filter', 'Desired Response');
    grid on;

   % Output the filter coefficients
disp('Filter Coefficients (h):');
disp(h_symmetric);

% Assign the symmetric filter coefficients to the output variable
Hd = h_symmetric;  % Ensure Hd is assigned the filter coefficients

end

