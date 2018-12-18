function [mpc_cost, mpc_constraints] = generate_mpc_matrices(problem)

N = problem.system.N;
n = problem.system.n;

% Inequality constraints

c = blkdiag(kron(eye(N), problem.constraints.C), problem.constraints.G);
d = [kron(eye(N), problem.constraints.D); zeros(size(problem.constraints.G,1) , N) ];
a = [c d];
e = zeros(size(n, 1), size(a,2));
e(1:size(problem.constraints.S,1),1:size(problem.constraints.S,2)) = -problem.constraints.S;
b = kron(ones(N,1),problem.constraints.e);
cin = zeros(N*size(problem.constraints.C,1) + size(problem.constraints.G,1), n);

mpc_constraints.Ain = [a; e];
mpc_constraints.bin = [b; problem.constraints.h; problem.constraints.r];
mpc_constraints.cin = [cin;-problem.constraints.S];

% Equality constraints

a = [kron(eye(N), -problem.system.A) zeros(n*N, n)] + [zeros(n*N, n) kron(eye(N), eye(n))];
b = kron(eye(N), -problem.system.B);

mpc_constraints.Aeq = [a b];
mpc_constraints.beq = zeros(N*n, 1);

% Objective function

H = blkdiag(kron(eye(problem.system.N), problem.cost.Q), problem.cost.P, ...
            kron(eye(problem.system.N), problem.cost.R));
mpc_cost.H = 2*H;
mpc_cost.f = zeros(size(H,1), 1);