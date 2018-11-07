function t_constraints = tightened_constraints(problem)

i=1;
disturbance_set=Polyhedron(problem.constraints.E,problem.constraints.g);
X(i) = disturbance_set;

while not(problem.system.A_K^i * disturbance_set <= problem.system.alpha * disturbance_set)
    i = i + 1;
    X(i) = problem.system.A_K * X(i-1) + disturbance_set;
end


C_K = problem.constraints.C + problem.constraints.D * problem.system.K;
N = i;

for i = 1:size(C_K,1)
    theta_N(i) = X(N).support(C_K(i,:)');
end

problem.constraints.C_K = C_K;

problem.constraints.e_tmp = problem.constraints.e;
t_constraints.e = problem.constraints.e - (1 - problem.system.alpha)^(-1) * theta_N';

