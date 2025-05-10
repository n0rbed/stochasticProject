% parameters 
M = 4;   % PAM level
num_symbols = 1e5;  % el total "symbols", i.e. time ig
bits_per_symbol = log2(M);
EbN0_db = -10:0.5:10;
EbN0_linear = 10.^(EbN0_db/10);

% random bits
s = randi([0,1], num_symbols*bits_per_symbol, 1);
s_insymbols = bit2int(s, bits_per_symbol);
s_mapped = real(pammod(s_insymbols,M,0, 'bin'));
signal_power = mean(abs(s_mapped).^2);

BER = zeros(size(EbN0_db));

for i = 1:length(EbN0_db)
    channel = comm.AWGNChannel('EbNo', EbN0_db(i), 'BitsPerSymbol', ...
        bits_per_symbol, 'SignalPower', signal_power);
    r = channel(s_mapped);
    [~, BER(i)] = biterr(s, int2bit(pamdemod(r, M), bits_per_symbol));
end

theorBER = berawgn(EbN0_db, 'pam', M);
figure;
semilogy(EbN0_db, BER, 'bo-', 'LineWidth', 1, 'MarkerFaceColor', 'b');
hold on;
semilogy(EbN0_db, theorBER, 'r--', 'LineWidth', 2);
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate');
title("BER vs Eb/N0 for "+ M +"-PAM with Matched Filter");
legend('Simulated', 'Theoretical', 'Location', 'southwest');
axis([min(EbN0_db) max(EbN0_db) 1e-5 1]);




