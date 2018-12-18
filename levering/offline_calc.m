
% state feedback & terminal cost
[K, cost.P] = dlqr(system.A, system.B, cost.Q, cost.R);
system.K = -K;

% problem reformulation
system.A_K = system.A + system.B * system.K;
constraints.C_K = constraints.C + constraints.D * system.K;

%tightened constraints, \bar{Y}, X_f, S_K
[constraints, system.S_K, system.N] = tightened_constraints(system, constraints, disturbance);

%N-step controllable tube for nominal and actual system
X_c = contr_tube(system,constraints);
for i=1:system.N+1
    X(i) = X_c(i) + system.S_K;
end    

%assign to problem
problem.system = system;
problem.constraints = constraints;
problem.cost = cost;
problem.disturbance = disturbance;

% generate matrices for online calculation
[problem.mpc_cost, problem.mpc_constraints] = generate_mpc_matrices(problem);

