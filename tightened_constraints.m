function [t_constraints, N] = tightened_constraints(problem)

constraints = problem.constraints;
i=1;
disturbance_set=Polyhedron(constraints.E,constraints.g);
X(i) = disturbance_set;

while not(problem.system.A_K^i * disturbance_set <= problem.system.alpha * disturbance_set)
    i = i + 1;
    X(i) = problem.system.A_K * X(i-1) + disturbance_set;
end


C_K = constraints.C + constraints.D * problem.system.K;
N = i;

for i = 1:size(C_K,1)
    theta_N(i) = X(N).support(C_K(i,:)');
end

constraints.C_K = C_K;

t_constraints.e = constraints.e - (1 - system.alpha)^(-1) * theta_N';
t_constraints.C = constraints.C;
t_constraints.D = constraints.D;
%target
t_constraints.G = constraints.G;
t_constraints.h = constraints.h;
%disturbance
t_constraints.E = constraints.E;
t_constraints.g = constraints.g;
