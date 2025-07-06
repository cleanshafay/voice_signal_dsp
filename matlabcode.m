% Task 1: Energy Analysis and Original Signal Plot
[a_original, Fs_original] = audioread('C:\Users\Shafay Nadeem\Documents\Sound Recordings\Recording.m4a');
N_original = length(a_original);
A_original = fft(a_original);
Exx_original = abs(A_original(1:N_original/2+1));

Exx_squared_original = Exx_original.^2;
cumulative_energy_original = cumsum(Exx_squared_original) / sum(Exx_squared_original);

energy_threshold_original = 0.95;
selected_index_original = find(cumulative_energy_original >= energy_threshold_original, 1);
bandwidth_original = selected_index_original / N_original * Fs_original;

disp(['95% of the total energy is contained within the bandwidth: ', num2str(bandwidth_original), ' Hz']);

duration_original = length(a_original) / Fs_original;
t = (0:1/Fs_original:duration_original-1/Fs_original)';

figure(1);
subplot(2, 1, 1);
plot(t, a_original);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Audio Signal');

subplot(2, 1, 2);
fft_voice_original = fftshift(fft(a_original));
freq_res_original = Fs_original / N_original;
freq_axis_original = linspace(-Fs_original/2, Fs_original/2 - freq_res_original, N_original);
plot(freq_axis_original, abs(fft_voice_original));
title('Original Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% -----------------------------------------------------------------------

% Task 2: Modulation and Resampling
t_Fs = 4e6; % Targeted frequency
resampled_voice = resample(a_original, t_Fs, Fs_original);
resampled_length = length(resampled_voice);
t_resampled = (0:resampled_length-1) * (1 / t_Fs);

f = 1e6;
sinusoid_modulation = sin(2*pi*f*t_resampled);
modulated_voice = resampled_voice .* transpose(sinusoid_modulation);

fftsignal_modulation = fftshift(fft(modulated_voice, length(modulated_voice)));
freq_axis_modulation = (-length(fftsignal_modulation)/2 : length(fftsignal_modulation)/2 - 1) * t_Fs / length(fftsignal_modulation);
figure;

subplot(2, 1, 1);
plot(t_resampled, modulated_voice);
title('Time Domain of Multiplied Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(freq_axis_modulation, abs(fftsignal_modulation));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of Multiplied Signal');
modulated_voice = a_original .* sin(2*pi*f*t);
% -----------------------------------------------------------------------

% Task 3: Impulse Sampling
A_original = fft(a_original);
freq_sampling = linspace(0, Fs_original/2, length(A_original));
high_freq_sampling = max(freq_sampling);

result_signal = modulated_voice';
sampling_fs = 2 * high_freq_sampling;
freq_impulse = high_freq_sampling;
increment_value = round(Fs_original / (freq_impulse));
L_result = length(result_signal);
impulse_train = zeros(1, L_result);
impulse_train(1:increment_value:end) = 1;
t_impulse = linspace(0, length(impulse_train)/freq_impulse, length(impulse_train));
result_sample = result_signal .* impulse_train;
t_sample = (0:length(result_sample)-1)/Fs_original;
f_sample = (0:length(result_sample)-1)*Fs_original/length(result_sample);
result_sampleT = transpose(result_sample);
fft_sample = fft(result_sampleT);

subplot(2, 1, 1);
stem(t_sample, impulse_train);
title('Plot of Impulse Train');
xlabel('Time (s)');
ylabel('Impulse Train');

subplot(2, 1, 2);
plot(f_sample, abs(fftshift(fft_sample)));
title('Sampled Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% -----------------------------------------------------------------------

% Task 4: Retrieval and Multiplication
t_sync = -1:1/sampling_fs:1;
sync_func = sinc(t_sync * sampling_fs);
retrieved_signal = convn(fft(result_sample), sync_func);
retrieved_signal = real(retrieved_signal);
t_retrieved = (0:length(retrieved_signal)-1) / sampling_fs;

figure;
subplot(2, 1, 1);
plot(t_sync, sync_func);
title('Sync Function');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t_retrieved, retrieved_signal);
title('Retrieved Signal');
xlabel('Time (s)');
ylabel('Amplitude');
%---------------------------------------------------------------------
%Task 5: Retrieving back the original singnal and sounding it.
% Multiplication with Sinusoid and Final Output
L = length(a_original);
fft_audio_original = fft(a_original);
F_Mhz = 1e6;
t_result_final = (0:length(retrieved_signal)-1)/Fs_original;
sine = sin(2 * pi * F_Mhz * t_result_final);
fft_sine = fft(sine);

result_signal_final = sine .* retrieved_signal;
result_signal_finalT = transpose(result_signal_final);
t_result_final = (0:length(result_signal_final)-1)/Fs_original;
result_spectrum_final = fft(result_signal_finalT);
F = (0:length(result_spectrum_final)-1)*Fs_original/length(result_spectrum_final);

sync2 = sinc(t_sync * sampling_fs);
final_output = convn(fft(result_signal_final), sync2);
t_output = (0:length(final_output)-1) / sampling_fs;

figure;
subplot(3, 1, 1);
plot(t_result_final, result_signal_finalT);
title('Multiplication with Sinusoid');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(F, abs(fftshift(result_spectrum_final)));
title('Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(t_output, real(final_output));
title('Final Output in Time Domain');
xlabel('Time (s)');
ylabel('Magnitude');

sound(final_output, Fs_original);
grid on