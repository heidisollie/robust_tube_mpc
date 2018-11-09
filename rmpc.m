function optimal = rmpc(problem,x)

n = problem.system.n;
m = problem.system.m;
N = problem.system.N;

options = optimset('Display', 'off');
% get optimal decision variable and optimal value
[output, optimal.cost_V] = quadprog(problem.rmpc_cost.H, ... 
                                    problem.rmpc_cost.f, ...
                                    problem.rmpc_constraints.Ain, ...
                                    problem.rmpc_constraints.cin - problem.rmpc_constraints.Bin * x, ...
                                    problem.rmpc_constraints.Aeq, ...
                                    problem.rmpc_constraints.ceq - problem.rmpc_constraints.Beq*x, ...
                                    [], [], [], ...
                                    options);

% devectorize output to obtain optimal x
% and optimal u

z = zeros(n,N);
v = zeros(m,N);
z(:,1) = output(1:n);

for i=1:N
    z(:,i+1) = output(i*n + 1: (i+1)*n);
    v(:,i) = output((N+1)*n + (i-1)*m + 1:(N+1)*n + i*m);
end

optimal.v=v; 
optimal.z=z;