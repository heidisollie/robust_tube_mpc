function rmpc_cost = generate_cost(problem)


rmpc_cost.H = 2*blkdiag(kron(eye(problem.system.L), problem.cost.Q), problem.cost.P, kron(eye(problem.system.L), problem.cost.R));
rmpc_cost.f = zeros(size(rmpc_cost.H,1), 1);