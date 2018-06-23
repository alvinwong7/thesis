close all;clear all; clc;
% Voice Activity Detection Module
% by Alvin Wong z5076152
% for undergraduate thesis 'Distant Real-Time Automatic Speech Recognition
% for Voice-Controlled Home Automation'

x = -1;
debug = 0;
options();
while (x < 0 || x > 4)
    prompt = 'Select the desired algorithm (1-4): ';
    x = input(prompt);
end

% --------------------------- INITIALISATION ---------------------------
% Initialisation of threshold levels
switch x
    case 1
        threshold = 1;
    case 2
        threshold = 1;
    case 3
        threshold = 1;
    case 4
        threshold = 1;
end

% Initialisation of microphone
deviceReader = audioDeviceReader;
setup(deviceReader);

% ---------------------------
while 1
    audio = deviceReader();
    switch x
        case 1
            val = energy(audio);
        case 2
            val = spectral(audio);
        case 3
            cepstral();
        case 4
            harmonicity();
    end
    if val > threshold
       if debug == 1
           disp('speech')
       end
    end
end

release(deviceReader);