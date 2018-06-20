close all;clear all; clc;
% Voice Activity Detection Module
% by Alvin Wong z5076152
% for undergraduate thesis 'Distant Real-Time Automatic Speech Recognition
% for Voice-Controlled Home Automation'

x = -1;
options();
while (x < 0 || x > 4)
    prompt = 'Select the desired algorithm (1-4): ';
    x = input(prompt);
end

% Initialisation of threshold levels
switch x
    case 1
        max = 1;
    case 2
        max = 1;
    case 3
        max = 1;
    case 4
        max = 1;
end

% Initialisation of microphone
deviceReader = audioDeviceReader;
setup(deviceReader);

while 1
    audio = deviceReader();
    switch x
        case 1
            if energy(audio) > max
                disp('speech')
            end
        case 2
            spectral();
        case 3
            cepstral();
        case 4
            harmonicity();
    end
end

release(deviceReader);