% terminal cost
[cost.P, ~, ~] = dare(system.A, system.B, cost.Q, cost.R);

% state feedback
[K, cost.P] = dlqr(system.A, system.B, cost.Q, cost.R);
system.K = -K;

% problem reformulation
system.A_K = system.A + system.B * system.K;
constraints.C_K = constraints.C + constraints.D * system.K;
constraints.d_K = constraints.e;
[t_constraints, system.S, system.N] = tightened_constraints(constraints, system, disturbance);
target.G = t_constraints.G;
target.h = t_constraints.h;
constraints.e_org = constraints.e;
constraints.e = t_constraints.e;
[Z, ~] = c_tube(system,constraints,target);
for i=1:system.N+1
    X(i) = Z(i) + system.S;
end    
%assign to problem
problem.system = system;
problem.constraints = t_constraints;
problem.cost =  cost;
problem.disturbance = disturbance;

% generate constraints and cost for mpc
problem.rmpc_disturbance.w_sequence = generate_disturbance(problem,0);
problem.rmpc_constraints = generate_constraints(problem);
problem.rmpc_cost = generate_cost(problem);

