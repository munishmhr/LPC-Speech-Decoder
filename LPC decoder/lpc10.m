clear all;
% 1. produce digital signal and dividing in frames, 20sec (240 samples)
[y,fs,nbits,soundbits] = wavread('original.wav');
frameLength = .02 * fs/4;
numFrame = length(y)/frameLength;

% example taken from matlab site
% http://www.mathworks.com/help/signal/ref/fdesign.lowpass.html
D = fdesign.lowpass('N,Fc',10,900,fs);
Hd = design(D);

% Array initializations
decisionArray = zeros(numFrame,1);
clip = zeros(numFrame,1);
x_n = zeros(240,1);
coffArray = zeros(1,11,numFrame);
pitchPeriod = zeros(numFrame,1);
gainArray = zeros(numFrame,1);

% 2. creating frames and other operations conserning it.
for frame = 1 : numFrame
    x = y((frame-1) * frameLength + 1 : frame * frameLength);
    [a,g] = lpc(x,10);
    coffArray(:,:,frame) = a;
    gainArray(frame,1) = g;
    
    % 2. Low pass filter
    x = filter(Hd,x);
    
    % 3. cl = 30% of max(x(n))
    clip=.3 * max(x);
        
    % calculating x(n) +1 -1 0 values dependng on values of x calculating x_n
    for i = 1 : length(x)
        if x(i) > clip
            x_n(i) = 1;
        elseif x(i) < -clip
            x_n(i) = -1;
        else
            x_n(i) = 0;
        end
    end
    
    % calculating R
    for k=floor(fs/350):floor(fs/80)
        su=0;
        for u=1:(length(x_n)-1-k)
            s = x_n(u) * x_n(u+k);
            su = su + s;
        end
        R(k)=su;
    end
    R_max = max(R);
    
    % calculating R0
    R0 = sum(x_n.*x_n);
    
    % find index K for pitch period and decision array
    % pitch period that ii have used is taen from a paper. I am unable to
    % found it write now and put its refrence here.
    K = find(R == R_max,1);
    if R_max > .3 * R0
        decisionArray(frame) = 1;
        pitchPeriod(frame) = K+fs/350;     
    else decisionArray(frame) = 0;
    end 
end

for f=1:numFrame
  if decisionArray(f) == 1                                 
    speechTrainWithPitchPeriod(1:floor(pitchPeriod(f))+1) = 1;
    speechTrainWithPitchPeriod = speechTrainWithPitchPeriod(1:frameLength);
  elseif  decisionArray(f) == 0                                       
    speechTrainWithPitchPeriod = 2*randn(frameLength,1); 
  end
  
  synthisSpeech(:,f) = filter(50000*gainArray(f),coffArray(:,:,f),speechTrainWithPitchPeriod);
end
synthisSpeech = synthisSpeech(:);
subplot(211);plot(y);subplot(212);plot(synthisSpeech);
%sound(synthisSpeech,fs);
wavwrite(synthisSpeech,fs,8,'compressed.wav');

