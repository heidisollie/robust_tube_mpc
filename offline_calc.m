% terminal cost
[cost.P, ~, ~] = dare(system.A, system.B, cost.Q, cost.R);

% state feedback
[K, cost.P] = dlqr(system.A, system.B, cost.Q, cost.R);
system.K = -K;

% problem reformulation
system.A_K = system.A + system.B * system.K;
constraints.C_K = constraints.C + constraints.D * system.K;
[t_constraints, system.S_K, system.N, system.N_2, system.X_2] = tightened_constraints(constraints, system, disturbance);
constraints.e_org = constraints.e;
constraints.e = t_constraints.e;
%terminal constraint set 
constraints.G = t_constraints.G;
constraints.h = t_constraints.h;

%sets
X_c = c_tube(system,constraints);
for i=1:system.N+1
    X(i) = X_c(i) + system.S_K;
end    

%assign to problem
problem.system = system;
problem.constraints = t_constraints;
problem.cost =  cost;
problem.disturbance = disturbance;

% generate mpc matrices
[problem.mpc_cost, problem.mpc_constraints] = generate_mpc_matrices(problem);

