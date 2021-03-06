function LP_Fourier(ChebyshevLowPass)

global reporting;
global plotting;

%% fourier parameters
Fs = 40000;           % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 22000;            % Length of signal
t = (0:L-1)*T;        % Time vector
fr = 2000;

%% fourier input
X = sawtooth(2*pi*t*f);
Y = fft(X);
OnlySources = abs(Y/L);
InputFourierLowPass = OnlySources(1:L/2+1);
InputFourierLowPass(2:end-1) = 2*InputFourierLowPass(2:end-1);

f = Fs*(0:(L/2))/L;

if(reporting)
    fprintf('Fs = %f\n', Fs);
    fprintf('T = %f\n', T);
    fprintf('L = %f\n', L);
    fprintf('fr = %f\n', fr);
end

if(plotting)
    figure;
    plot(f,InputFourierLowPass); 
    title('Low Pass Input Fourier');
    xlabel('f (Hz)');
    ylabel('Voltage (V)');
end

%% fourier output
Z = lsim(ChebyshevLowPass, X, t);
W = fft(Z);
OnlySources = abs(W/L);
OutputFourierLowPass = OnlySources(1:L/2+1);
OutputFourierLowPass(2:end-1) = 2*OutputFourierLowPass(2:end-1);

if(plotting)
    figure;
    plot(f,OutputFourierLowPass); 
    title('Low Pass Output Fourier');
    xlabel('f (Hz)');
    ylabel('Voltage (V)');
end

end