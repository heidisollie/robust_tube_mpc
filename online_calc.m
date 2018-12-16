function optimal = rtmpc_online(problem,x)

n = problem.system.n;
m = problem.system.m;
N = problem.system.N;

options = optimset('Display', 'on');
% get optimal decision variable and optimal value
[output, ~] = quadprog(problem.mpc_cost.H, ... 
                                    problem.mpc_cost.f, ...
                                    problem.mpc_constraints.Ain, ...
                                    problem.mpc_constraints.bin + problem.mpc_constraints.cin * x, ...
                                    problem.mpc_constraints.Aeq, ...
                                    problem.mpc_constraints.beq, ...
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

optimal.z = z;
optimal.v = v;
