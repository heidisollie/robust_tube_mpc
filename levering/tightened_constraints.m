function [t_constraints, S_K, N] = tightened_constraints(system, constraints, disturbance)

i=1;
W = Polyhedron(disturbance.E,disturbance.g);
S_K_seq(i) = W;

while and(not(system.A_K^i * W <= system.alpha * W), i <= system.Nsim)
    i = i + 1;
    S_K_seq(i) = system.A_K * S_K_seq(i-1) + system.E * W;
end
N = i;
S_K = (1 - system.alpha)^(-1) * S_K_seq(N);

%s = support(S,x), s = max_y x'y, y \in S
for i = 1:size(constraints.C_K,1)
    theta_N(i) = S_K.support(constraints.C_K(i,:)');
end
theta_N = theta_N';

t_constraints.e = constraints.e - theta_N;
t_constraints.C = constraints.C;
t_constraints.D = constraints.D;


%terminal constraint set 
i=1;
X(i) = Polyhedron(constraints.C_K, t_constraints.e);
cond = true;
while cond
        i = i+1;
        current_target.G = X(i-1).A;
        current_target.h = X(i-1).b;
        A=[constraints.C_K; current_target.G*system.A_K];
        b=[t_constraints.e; current_target.h];
        X(i) = Polyhedron(A,b);       
        cond = and(not(X(i-1) == X(i)), i<=system.Nsim);
end


% initial condition
t_constraints.S = S_K.A;
t_constraints.r = S_K.b;

%target
t_constraints.G = X(i).A;
t_constraints.h = X(i).b;
