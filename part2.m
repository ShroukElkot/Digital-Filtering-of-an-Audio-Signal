function audio_signal = part2(audioFileinput)
        %1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Specify the path to the audio file
        %audioFilePath = 'C:\Users\Sherin\Downloads\M1F1-Alaw-AFsp.wav';
        Path = audioFileinput; 
        % Read the audio file
        [audioData, sampleRate] = audioread(Path);
        
        % If the audio has multiple channels, convert to mono by averaging the channels
        if size(audioData, 2) > 1
            audioData = mean(audioData, 2); % Convert to mono by averaging
        end
        
        %2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Define the upsampling factor
        upsampleFactor = 2;
        upFs = sampleRate * upsampleFactor;
        % Upsample the audio data by the specified factor
        upsampledAudio = resample(audioData, upsampleFactor, 1);
        
        %3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot the frequency spectrum before upsampling
        figure;
        freqz(audioData, 1, 1024, sampleRate);  
        title('Frequency Spectrum of Original Audio Signal');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        % Plot frequency response of the upsampled audio signal
        figure;
        freqz(upsampledAudio, 1, 1024, upFs);  % Upsampled audio signal frequency response
        title('Frequency Spectrum of Upsampled Audio Signal');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        
        
        %4  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        interferenceFrequency = 22000;  
        % Create a time vector based on the sample rate and length of the audio data
        t_upsampled = (0:length(upsampledAudio)-1)/upFs; % Time vector
        %t = (0:length(audioData)-1) / sampleRate;
        %interferenceSignal = 0.1 * sin(2 * pi * interferenceFrequency * t_upsampled);  
        interferenceSignal = 0.5 * sin(2 * pi * interferenceFrequency * (0:length(upsampledAudio)-1)' / (sampleRate*2));
        audioWithInterference = upsampledAudio + interferenceSignal;
        audiowrite('D:\audioWithInterference.wav', audioWithInterference, 48000);
        figure;
        hold on;  
        plot(t_upsampled, interferenceSignal, 'r', 'DisplayName', 'Interference Signal');
        plot(t_upsampled, upsampledAudio, 'b', 'DisplayName', 'Original Audio'); 
        title('Original Audio and Sinusoidal Interference Signal (Time Domain)');
        xlabel('Time (s)');
        ylabel('Amplitude');
        legend('show');
        grid on;
        hold off; 
        
        % %5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot the frequency spectrum of the audio signal with interference
        figure;
        freqz(audioWithInterference, 1, 1024, upFs);  % Use freqz to analyze the signal
        title('Frequency Spectrum of Audio Signal with Interference');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        grid on;
        
        
        %6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Ensure the signal has only one or two channels before playing
        [numSamples, numChannels] = size(audioWithInterference);
        if numChannels > 2
            audioWithInterference = audioWithInterference(:, 1:2); % Select only the first two channels
        end
        
        % Play the combined upsampled signal
        %sound(audioWithInterference, upFs); 
        %Save the signal to a new audio file
        %audiowrite('E:\final download\dsp-project\combined_audio_with_interference_upsampled.wav', audioWithInterference, upFs);
        audio_signal = audioWithInterference;
        sampleRate = sampleRate;
end