function display_N_alpha(problem)


max_N = 50;
step_size = 1;
alpha_array = 1:step_size:max_N;
N_array = zeros(1, size(alpha_array, 2));

disturbance_set=Polyhedron(problem.constraints.E,problem.constraints.g);

for j=1:size(alpha_array,2)
    i = 1;
    while not(problem.system.A_K^i * disturbance_set <= problem.system.alpha * disturbance_set)
        i = i + 1;
    end
    N_array(j) = i;
end

figure
grid on;
plot(N_array, alpha_array);
xlabel('N')
ylabel('alpha')
