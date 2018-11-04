function w_sequence = generate_disturbance(problem, w_type)

% create random disturbance sequence

problem.constraints.W = Polyhedron(problem.constraints.E, problem.constraints.g);
W_vertices = size(problem.constraints.W.V,1);
w_sequence = zeros(size(problem.constraints.E,2), problem.system.L);

if w_type == 0
    for i=1:problem.system.Nsim
        w_sequence(:,i) = (problem.constraints.W.V)'*rand(W_vertices,1);
    end

% disturbance sequence will only be vertices of W
else
    for i=1:problem.system.Nsim
        [~, ind] = max(rand(W_vertices,1));
        w_sequence(:,i) = (problem.constraints.W.V(ind,:))';
    end
end
  