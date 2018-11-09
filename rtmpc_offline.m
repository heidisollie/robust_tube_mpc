% terminal cost
[cost.P, ~, ~] = dare(system.A, system.B, cost.Q, cost.R);

% state feedback
%system.K = inv(cost.R + system.B' * cost.P * system.B) * system.B' * cost.P * system.A;
p = [0.2 0.4];
K = place(system.A, system.B, p);
system.K = -K;

% problem reformulation
system.A_K = system.A + system.B * system.K;
t_constraints = tightened_constraints(constraints, system, disturbance);
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
