

disturbance_set = Polyhedron(problem.disturbance.E, problem.disturbance.g);
size_step = 3;

alpha_array = [0.996 0.99 0.98 0.97 0.96 0.95 0.8 0.85 0.7 0.6 0.5 0.4 0.3 0.25 0.23 0.20 0.17 0.15 0.13 0.12 0.1 0.05 0.04 0.03 0.01 0.005 0.004 0.003 0.001];
size_alpha = size(alpha_array,2);
N_array = zeros(1,size_alpha);



max = 500;
for i=1:size_alpha
    n=0;
    while and(not(problem.system.A_K^n * disturbance_set <= alpha_array(i) * disturbance_set), n<= max)
        n = n + 1;
    end
    N_array(i) = n;
end    

figure; hold on;
plot(alpha_array, N_array, 'k-*')
yline(13)
ylabel('$N$', 'Interpreter','latex')
xlabel('$\alpha$', 'Interpreter','latex')
leg1 = legend('${A_K}^N {W} \subseteq \alpha {W}$');
set(leg1, 'Interpreter', 'Latex');
print('alpha_N', '-depsc', '-r300') 
axis([0 1 0 90])
hold off;