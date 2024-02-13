windowSize = 1024;  
windowShift = 512;    

should = 'should.wav';
s5 = 's5.wav';

analyze(should, windowSize, windowShift);
analyze(s5, windowSize, windowShift);


function analyze(filePath, windowSize, windowShift)
    [speech, sampleRate] = audioread(filePath);

    energy = rms(buffer(speech, windowSize, windowSize - windowShift, 'nodelay'));

    magnitude = abs(spectrogram(speech, hann(windowSize), windowSize - windowShift));

    zeroCross = sum(abs(diff(sign(buffer(speech, windowSize, windowSize - windowShift, 'nodelay'))))) / windowSize;

    figure('Position', [100, 100, 800, 800]);

    subplot(4, 1, 1);
    plot(speech);
    xlabel('Sample');
    ylabel('Amplitude');
    title('Entire Speech Waveform');

    subplot(4, 1, 2);
    time = (windowSize/2 : windowShift : windowSize/2 + windowShift * (size(energy, 2)-1)) / sampleRate;
    plot(time, energy);
    xlabel('Time (s)');
    ylabel('Energy');
    title('Short-time Energy (En)');

    subplot(4, 1, 3);
    time = (windowSize/2 : windowShift : windowSize/2 + windowShift * (size(magnitude, 2)-1)) / sampleRate;
    imagesc(time, [], 20*log10(magnitude));
    set(gca, 'YDir', 'normal');
    xlabel('Time (s)');
    ylabel('Frequency');
    title('Short-time Magnitude (Mn)');
    colorbar();

    subplot(4, 1, 4);
    time = (windowSize/2 : windowShift : windowSize/2 + windowShift * (length(zeroCross)-1)) / sampleRate;
    plot(time, zeroCross);
    xlabel('Time (s)');
    ylabel('Zero-crossing rate');
    title('Short-time Zero-crossing (Zn)');

    sgtitle(sprintf('Speech Analysis: %s', filePath));
end


