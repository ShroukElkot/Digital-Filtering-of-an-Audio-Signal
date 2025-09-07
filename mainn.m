% Main Script for Windowed Sinc FIR Filter Design

% Ask user to enter the filter length
filterLength = input('Enter the length of the filter impulse response (odd number): ');
if mod(filterLength, 2) == 0
    error('Filter length must be an odd number.');
end

filterType = menu('Select the FIR filter design method:', ...
                  'Windowed Sinc', 'Least Squares (LS)', 'Weighted Least Squares (WLS)');


% Ask the user to specify the audio file input path
audioFileinput = input('Enter the path of the audio file (e.g., "audioFile.wav"): ', 's');
% Load the audio with interference

% switch case on the selected filter design method
switch filterType
    
    case 1 % Windowed Sinc Design
        % Ask user for window type
        windowType = menu('Select the window type:', ...
                          'Rectangular', 'Blackman', 'Chebyshev', 'Kaiser');
        Fpass =  input('Enter cutoff frequency of the filter: ');
        Fsample = input('Enter sampling frequency of the filter: ');  
        % Call the function based on window type
        switch windowType
            case 1 % Rectangular
                Hd = fir_window_rect(filterLength, Fpass, Fsample);
            case 2 % Blackman
               Hd = fir_window_blackman(filterLength, Fpass, Fsample);
            case 3 % Chebyshev
                ripple = input('Enter ripple value for Chebyshev window (dB): ');
                Hd = fir_window_cheb(filterLength, Fpass, Fsample, ripple);
            case 4 % Kaiser
                beta = input('Enter beta value for Kaiser window: ');
                Hd = fir_window_kaiser(filterLength, Fpass, Fsample, beta);

            otherwise
                error('Invalid window type selected.');
        end
         % Compute the frequency response
        % [H, f] = freqz(Hd.Numerator, 1, 1024, 48000); % Include Fs explicitly
        % 
        % % Plot the magnitude response
        % figure;
        % subplot(2,1,1);
        % plot(f, abs(H));
        % title('Magnitude Response (Linear Scale)');
        % xlabel('Frequency (Hz)');
        % ylabel('Magnitude');
        % grid on;
        % 
        % subplot(2,1,2);
        % plot(f, 20*log10(abs(H)));
        % title('Magnitude Response (Log Scale)');
        % xlabel('Frequency (Hz)');
        % ylabel('Magnitude (dB)');
        % grid on;
        % 
        % % Display filter coefficients
        % disp('Filter coefficients:');
        % disp(Hd.Numerator);

    case 2 % Least Squares Design
        % Ask user for number of points
        Fpass_norm = input('Enter the normalized passband frequency (0 to 1, e.g., 0.2): '); % Normalized Passband Frequency
        Fstop_norm = input('Enter the normalized stopband frequency (0 to 1, e.g., 0.25): '); % Normalized Stopband Frequency
        n_points = input('Enter the number of points in the frequency response: ');

        % Call LS FIR filter
        Hd = LS_FIR(filterLength, n_points, Fpass_norm, Fstop_norm);
    case 3 % Weighted Least Squares Design
        % Ask user to enter wpass, wtrans, wstop
        Fpass_norm = input('Enter the normalized passband frequency (0 to 1, e.g., 0.2): '); % Normalized Passband Frequency
        Fstop_norm = input('Enter the normalized stopband frequency (0 to 1, e.g., 0.25): '); % Normalized Stopband Frequency
        w_pass = input('Enter the passband weight:');
        w_trans = input('Enter the transition band weight:');
        w_stop = input('Enter the stopband weight:');
        n_points = input('Enter the number of points in the frequency response: 71 ');
       

        % Call WLS FIR filter
        Hd = WLS_FIR(filterLength, n_points, Fpass_norm, Fstop_norm, w_pass, w_trans, w_stop);
        disp(Hd);
       
    otherwise
        error('Invalid filter type selected.');
end
 % Convolve the filter coefficients with the audio signal
        audioWithInterference = part2(audioFileinput);
        filtered_audio_signal = conv(audioWithInterference, Hd, 'same');  % Use 'same' to keep the length
      %filtered_audio_signal = filter(Hd, 1, audioWithInterference);
        % Compute the frequency response of the filtered signal
       
        [H, f] = freqz(filtered_audio_signal, 1, 1024, 48000);  % Use the correct sample rate
        sound(filtered_audio_signal, 48000);
        audiowrite('D:\filterred upsampled.wav', filtered_audio_signal, 48000);
        % Plot the frequency spectrum of the filtered signal
        figure;
        subplot(2, 1, 1);
        plot(f, abs(H));
        title('Magnitude Response of Filtered Audio (Linear Scale)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        grid on;

        subplot(2, 1, 2);
        plot(f, 20 * log10(abs(H)));
        title('Magnitude Response of Filtered Audio (Log Scale)');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        grid on;


