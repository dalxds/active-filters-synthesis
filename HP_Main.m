%% set enviroment
clear all;
clc;
close all;

global reporting;
global plotting;

reporting   =   true;
plotting    =   true;

reporting && fprintf('*** High Pass Butterworth ***\n');

%% specifications
reporting && fprintf('\n> Specifications\n');

AEM = [8 6 0 7];

[amin, amax, wp, ws, m, specsC] = HP_Specifications(AEM);

%% filter design
reporting && fprintf('\n> Poles & Zeros\n');

[w, Q, n, whp] = HP_Poles(amin, amax, wp, ws);

%% units
reporting && fprintf('\n> Units\n');

%%% initialize structures
units   =   n/2 + mod(n,2);
num     =   cell(units,1);
denum   =   cell(units,1);
gain    =   zeros(units,1);

%%% calculate transfer functions
for k = 1:units
    reporting && fprintf('\n>> Unit %i\n', k);
    [num{k}, denum{k}, gain(k)] = unitsSallenKeyStrategy2HP(w(k), Q(k), specsC);
end

%% transfer function
reporting && fprintf('\n> Transfer Function\n');

%%% initialize structures
tfn = cell(units,1);

%%% units transfer functions
for k = 1:units
    tfn{k} = tf(num{k}, denum{k});
    if(plotting)
        plot_transfer_function(tfn{k}, [ws/(2*pi) wp/(2*pi)]);
    end
    if(reporting)
       fprintf('>> Unit %i\n', k);
       fprintf('%s\n', evalc('tfn{k}'));
    end
end

%%% total transfer function
totalTf = 1;
for k = 1:units
   totalTf = series(totalTf, tfn{k});
end

if(plotting)
    plot_transfer_function(totalTf, [ws/(2*pi) wp/(2*pi)]);
end
if(reporting)
    fprintf('\n>> Total Transfer Function with no Gain Adjustment\n');
    fprintf('%s\n', evalc('totalTf'));
end

%% gain
reporting && fprintf('\n> Gain\n');

%%% zero gain
reporting && fprintf('\n>> Zero Gain\n');

specsGain = 0;
totalGain = HP_Gain(gain, specsGain);

zeroGainTf = series(totalTf, totalGain);
if(plotting)
    plot_transfer_function(zeroGainTf, [ws/(2*pi) wp/(2*pi)]);
end
if(reporting)
    fprintf('>>> Transfer Function\n');
    fprintf('%s\n', evalc('zeroGainTf'));
end

inverseZeroGainTf = inv(zeroGainTf);
if(plotting)
    plot_transfer_function(inverseZeroGainTf, [ws/(2*pi) wp/(2*pi)]);
end
if(reporting)
    fprintf('\n>>> Inverse Transfer Function\n');
    fprintf('%s\n', evalc('inverseZeroGainTf'));
end

%%% specifications gain
reporting && fprintf('\n>> Specifications Gain\n');

specsGain = 10;
totalSpecsGain = HP_Gain(gain, specsGain);

totalSpecsGainTf = series(totalTf, totalSpecsGain);
if(plotting)
    plot_transfer_function(totalSpecsGainTf, [ws/(2*pi) wp/(2*pi)]);
end
if(reporting)
    fprintf('>>> Total Transfer Function for Gain %i db\n', specsGain);
    fprintf('%s\n', evalc('totalTf'));
end

attenuation = inv(totalSpecsGainTf);
if(plotting)
    plot_transfer_function(attenuation, [ws/(2*pi) wp/(2*pi)]);
end
if(reporting)
    fprintf('\n>>> Total Inverse Transfer Function for Gain %i db\n', specsGain);
    fprintf('%s\n', evalc('attenuation'));
end

%% fourier
reporting && fprintf('\n> Fourier\n');

HP_Fourier(ws, wp, totalSpecsGainTf);