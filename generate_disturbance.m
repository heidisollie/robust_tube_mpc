function w_sequence = generate_disturbance(problem)

% create random disturbance sequence

disturbance_set = Polyhedron(problem.disturbance.E, problem.disturbance.g);
W_vertices = size(disturbance_set.V,1);
w_sequence = zeros(size(problem.disturbance.E,2), problem.system.N);

for i=1:problem.system.Nsim
    w_sequence(:,i) = (disturbance_set.V)'*rand(W_vertices,1);
end    