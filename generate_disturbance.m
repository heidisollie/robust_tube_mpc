function w_sequence = generate_disturbance(problem, w_type)

% create random disturbance sequence

disturbance_set = Polyhedron(problem.disturbance.E, problem.disturbance.g);
W_vertices = size(disturbance_set.V,1);
w_sequence = zeros(size(problem.disturbance.E,2), problem.system.L);

if w_type == 0
    for i=1:problem.system.Nsim
        w_sequence(:,i) = (disturbance_set.V)'*rand(W_vertices,1);
    end

% disturbance sequence will only be vertices of W
else
    for i=1:problem.system.Nsim
        [~, ind] = max(rand(W_vertices,1));
        w_sequence(:,i) = (disturbance_set.V(ind,:))';
    end
end
  