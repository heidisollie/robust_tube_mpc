function [t_constraints, S_K, N, N_2, X_2] = tightened_constraints(constraints, system, disturbance)

i=1;
disturbance_set=Polyhedron(disturbance.E,disturbance.g);
X(i) = disturbance_set;

while not(system.A_K^i * disturbance_set <= system.alpha * disturbance_set)
    i = i + 1;
    X(i) = system.A_K * X(i-1) + disturbance_set;
end
N = i;
%s = support(S,x), s = max_y x'y, y \in S
for i = 1:size(constraints.C_K,1)
    theta_N(i) = X(N).support(constraints.C_K(i,:)');
end
S_K = (1 - system.alpha)^(-1) * X(N);
%S_K = X(N);


t_constraints.e = constraints.e - (1 - system.alpha)^(-1) * theta_N';
t_constraints.C = constraints.C;
t_constraints.D = constraints.D;

constraints.d_K = t_constraints.e;
%compute terminal constraints
i=1;
X_2(i) = Polyhedron(constraints.C_K, constraints.d_K);
cond = true;
while cond
        i = i+1;
        current_target.G = X_2(i-1).A;
        current_target.h = X_2(i-1).b;
        X_2(i) = br_set(system,constraints,current_target);
        cond = and(not(X_2(i-1) == X_2(i)), i<=system.Nsim);
end
N_2 = i;


% initial condition
t_constraints.S = S_K.A;
t_constraints.r = S_K.b;

%target
t_constraints.G = X_2(i).A;
t_constraints.h = X_2(i).b;
