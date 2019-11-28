% 3. SIMO Rayleigh fading channel employing SC with 2 antenna perfect CSIR 
clear
clc

N = 100000; % number of symbols
Es_N0 = 0: 1: 30; % SNR

% generate QPSK symbols
% 1 + j, 1 - j, -1 + j, -1 - j
Tx = (2 * (rand(1, N) > 0.5) - 1) + j * (2 * (rand(1, N) > 0.5) - 1);
Tx_normal = Tx/sqrt(2); % normalize transmitted signal

h = (randn(2, N) + j * randn(2, N))/sqrt(2); % rayleigh fading channel % 2 antenna
n = (randn(1, N) + j * randn(1, N))/sqrt(2); % noise;

Rx_output = zeros(1, length(Es_N0));
P_s = zeros(1, length(Es_N0)); % probablity symbol error

for i = 1: length(Es_N0)
    Rx = max(abs(h(1,:)), abs(h(2, :))) .* (10^(Es_N0(i)/20) * Tx_normal) + n;
    
    Rx_re = real(Rx);
    Rx_im = imag(Rx);
    
    Rx_output(find(Rx_re > 0 & Rx_im > 0)) = 1 + j;
    Rx_output(find(Rx_re > 0 & Rx_im < 0)) = 1 - j;
    Rx_output(find(Rx_re < 0 & Rx_im > 0)) = -1 + j;
    Rx_output(find(Rx_re < 0 & Rx_im < 0)) = -1 - j;
    
    count_error = size(find(Tx - Rx_output), 2);
    P_s(i) = count_error/N;
    
end

figure(4)

semilogy(Es_N0, P_s, '-g+');
grid on
xlabel('E_s/N_0(dB)')
ylabel('Probability of symbol error (%)')
hold off
legend('SC')
axis([1 30 10^-3 1])

