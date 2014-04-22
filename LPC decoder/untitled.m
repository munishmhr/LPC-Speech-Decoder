%LPCestimationandspectrum
[a,g] = lpc(y(118*240:119*240),10);
figure;
hold on;
[H,freq]=freqz(g,a,512,8000);
subplot(211);plot(freq,(20*log(abs(H))));
subplot(212);plot(y(118*240:119*240));
%LSFrepresentationandstem
LSFcoef=poly2lsf(a);

for i=1:length(a),
    Y(i)=H(round((a(i)*4000/pi)/256)+4);
end
stem(LSFcoef/pi*8000/2,(-200+abs(Y)),'r');
xlabel('Frequency[Hz]')
ylabel('Amplitude[dB]')
axis([04000-200-100])


