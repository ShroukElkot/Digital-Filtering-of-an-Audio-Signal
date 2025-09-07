function Hd = fir_window_rect(filterlength, Fpass, Fsample)
    % Parameters
    Fs = Fsample; % Sampling frequency (Hz)
    Fc = Fpass; % Cutoff frequency (Hz)
    N = filterlength; % Filter length (odd number preferred for symmetry)
    
    % Time vector for the filter (-(N-1)/2 to (N-1)/2)
    n = -(N-1)/2:(N-1)/2;
    
    % Generate the sinc function
    sinc_func = 2 * Fc / Fs * sinc(2 * Fc * n / Fs);
    
    % Apply the rectangular window
    rect_window = ones(1, N); % Rectangular window
    filter_coeffs = sinc_func .* rect_window; % Windowed sinc (FIR filter)

    % Plot the filter coefficients
    figure;
    stem(n, filter_coeffs, 'filled');
    title('FIR Filter Coefficients (Rectangular Window)');
    xlabel('Sample Index');
    ylabel('Amplitude');
    grid on;

    % Frequency response of the filter
    [H, w] = freqz(filter_coeffs, 1, 1024, Fs); % DTFT of the filter
    % Ask the user whether to plot in linear or log scale
    disp('Select the type of magnitude response plot:');
    disp('1. Linear Scale');
    disp('2. Log Scale (dB)');
    choice = input('Enter your choice (1 or 2): ');

    % Plot the magnitude spectrum based on user's choice
    figure;
    if choice == 1
        plot(w, abs(H)); % Linear scale
        title('Frequency Response of the FIR Filter (Linear Scale)');
        ylabel('Magnitude');
    elseif choice == 2
        plot(w, 20 * log10(abs(H))); % Log scale
        title('Frequency Response of the FIR Filter (Log Scale)');
        ylabel('Magnitude (dB)');
    else
        disp('Invalid choice. Defaulting to Log Scale.');
        plot(w, 20 * log10(abs(H))); % Default to log scale
        title('Frequency Response of the FIR Filter (Log Scale)');
        ylabel('Magnitude (dB)');
    end
    xlabel('Frequency (Hz)');
    grid on;
    Hd = filter_coeffs;
end
