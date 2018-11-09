function rmpc_constraints = generate_constraints(problem)

%add tightened constraints for C, D, e, G, h
% change from X, U, X_f to Z, V, Z_f

N = problem.system.N;
n = problem.system.n;
%d = [z; v]
% Inequality constraints Ain d + Bin x \leq cin
%                        C z_k + D v_k \leq ~e, k \in R_L-1
%                        G z_L         \leq  h
%                       -E z_0 + E x   \leq  f

a1 = blkdiag(kron(eye(N), problem.constraints.C), problem.constraints.G);
a2 = [kron(eye(N), problem.constraints.D); zeros(size(problem.constraints.G,1) , N) ];
a = [a1 a2];
a3 = zeros(size(n, 1), size(a,2));
a3(1:size(problem.constraints.E,1),1:size(problem.constraints.E,2)) = -problem.constraints.E;
b = zeros(N*size(problem.constraints.C,1) + size(problem.constraints.G,1), n);
c = kron(ones(N,1),problem.constraints.e);


rmpc_constraints.Ain = [a; a3];
rmpc_constraints.Bin = [b; problem.constraints.E];
rmpc_constraints.cin = [c; problem.constraints.h; problem.constraints.f];


% Equality constraints Aeq + Beq x = ceq
%                      -A z_k + z_k+1 - B v_k = 0, k \in R_L-1
a1 = [kron(eye(N), -problem.system.A_K) zeros(n*N, n)];
a2 = [zeros(n*N, n) kron(eye(N), eye(n))];
a3 = a1 + a2;
a4 = kron(eye(N), -problem.system.B);

rmpc_constraints.Aeq = [a3 a4];
rmpc_constraints.Beq = zeros(N * n, n);
rmpc_constraints.ceq = zeros(N*n, 1);