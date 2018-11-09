function [alpha_array, N_array] = generate_N_alpha(problem)


step_size = 0.01;
alpha_array = step_size:step_size:1;
N_array = zeros(1, size(alpha_array, 2));

disturbance_set = Polyhedron(problem.disturbance.E, problem.disturbance.g);

for j=1:size(alpha_array,2)
    i = 1;
    while not(problem.system.A_K^i * disturbance_set <= alpha_array(j) * disturbance_set)
        i = i + 1;
    end
    N_array(j) = i;
end

