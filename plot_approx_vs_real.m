alpha_tmp = 0.15;
i=1;
while and(not(system.A_K^i * disturbance_set <= alpha_tmp * disturbance_set), i <= 100)
    display(i)
    i = i + 1;
    if i == 100
        display("HEI")
    end
end
N_tmp = i;
S_K_tmp = (1-alpha_tmp)^(-1)*S_K_seq(N_tmp);
figure; hold on;
S_K_lg = plot(S_K_tmp, 'Color', [1 0 1], 'alpha', 0.3);
%plot(system.S_K);
for i=1:5:80
    S_K_seq_lg = plot(S_K_seq((80-i)), 'Color', (1-i/(cs*(100)))*color3, 'alpha', 0.5);
end  
legend([S_K_lg S_K_seq_lg], {'$(1-\alpha)^{-1} {S_K}_N$', '${S_K}_i$'}, 'Interpreter', 'Latex');
print('approxvsrealSK', '-depsc', '-r300') 