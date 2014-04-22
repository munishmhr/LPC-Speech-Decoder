N=256;% number of samples
fs=1000;% frequency sampling
t=0:1/fs:(1/fs)*N; % time from 0 to (1/fs)*N, step each 1/fs
% 5 input signals x=A*sin(2*pi*f*t)
f1=0; f2=50; f3=100; f4=150; f5=200;
[x,fs,nbits,soundbits] = wavread('record1.wav');subplot(211);% make 2x1 viewpoint, plot in first viewpoint
plot(t,x);% plot input signal in time-domain
grid% turn-on grid
title('Signal Sampled at 1000Hz');
xlabel('Time (sec)');
ylabel('Signal Strength (volts)');
F=fft(x);% the FFT routine
magF=abs([F(1)/N,F(2:N/2)/(N/2)]); % adjust magnitude to volt
k=0:(N/2)-1; % axis setup, only plot 0 to pi/2
hz=k./(N/2)*(fs/2); % axis setup in Hertz
subplot(212); % make 2x1 viewpoint, plot in second viewpoint
plot(hz,magF); % plot input signal in frequency-domain
grid
title('Frequency Components');
xlabel('Frequency (Hz)');
ylabel('Amplitude (Volts)');