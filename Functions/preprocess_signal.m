function[signal] = preprocess_signal(signal)
    
    signal_std = std(signal);
    signal_mean = mean(abs(signal));

    signal(abs(signal)>signal_mean+2*signal_std) = [];

    signal = bandpass(signal,[10,150],2000);

end