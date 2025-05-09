% parameters 
M = 2;   % PAM level
num_symbols = 1e4;  % el total "symbols", i.e. time ig
samples_per_symbol = 1;
EbN0_db = -10:0.5:10;
EbN0_linear = 10.^(EbN0_db/10);


s = randi([0,M-1], 1, num_symbols*samples_per_symbol);
s_mapped = real(pammod(s, M));
BER = zeros(size(EbN0_db));
for i = 1:length(EbN0_db)
    channel = comm.AWGNChannel('EbNo', EbN0_db(i), 'BitsPerSymbol', ...
        samples_per_symbol);
    r = channel(s_mapped);
    [~, BER(i)] = biterr(s, pamdemod(r, M));
end

theorBER = qfunc(sqrt(2*EbN0_linear));
figure;
semilogy(EbN0_db, BER, 'bo-', 'LineWidth', 2, 'MarkerFaceColor', 'b');
hold on;
semilogy(EbN0_db, theorBER, 'r--', 'LineWidth', 2);
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate');
title("BER vs Eb/N0 for "+ M +"-PAM with Matched Filter");
legend('Simulated', 'Theoretical', 'Location', 'southwest');
axis([min(EbN0_db) max(EbN0_db) 1e-5 1]);




