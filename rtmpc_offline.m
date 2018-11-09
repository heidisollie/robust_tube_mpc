% terminal cost
[cost.P, ~, ~] = dare(system.A, system.B, cost.Q, cost.R);

% state feedback
[K, cost.P] = dlqr(system.A, system.B, cost.Q, cost.R);
system.K = -K;

% problem reformulation
system.A_K = system.A + system.B * system.K;
[t_constraints, system.N] = tightened_constraints(constraints, system, disturbance);
problem.system = system;
problem.constraints = t_constraints;
problem.cost = cost;
problem.disturbance = disturbance;

% generate constraints and cost for mpc
problem.rmpc_disturbance.w_sequence = generate_disturbance(problem,0);
problem.rmpc_constraints = generate_constraints(problem);
problem.rmpc_cost = generate_cost(problem);

% dsplay N and alpha
%display_N_alpha(problem);
