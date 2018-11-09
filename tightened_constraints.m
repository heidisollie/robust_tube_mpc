function [t_constraints, N] = tightened_constraints(constraints, system, disturbance)

i=1;
disturbance_set=Polyhedron(disturbance.E,disturbance.g);
X(i) = disturbance_set;

while not(system.A_K^i * disturbance_set <= system.alpha * disturbance_set)
    i = i + 1;
    X(i) = system.A_K * X(i-1) + disturbance_set;
end


C_K = constraints.C + constraints.D * system.K;
N = i;

for i = 1:size(C_K,1)
    theta_N(i) = X(N).support(C_K(i,:)');
end

S = (1 - system.alpha)^(-1) * X(N);

t_constraints.e = constraints.e - (1 - system.alpha)^(-1) * theta_N';
t_constraints.C = constraints.C;
t_constraints.D = constraints.D;

% initial condition
t_constraints.E = S.A;
t_constraints.f = S.b;

%target
t_constraints.G = constraints.G;
t_constraints.h = constraints.h;
