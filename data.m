% System, constraints and target set
% 
% system - x+ = Ax + Bu + c
% constraints -  Z = {x, u | Cx + Du \leq e }
% disturbance - W = { w | Ew \leq g }
% cost J = sum_0^L-1  x_k'Qx_k + u_k'Ru_k + x_L' P x_L
% terminal constraints -  X_f = { x | Gx \leq h }
% terminal cost Vf = 0.5 * x' * P * x, A'PA - P- A'PB(R+B'PB)^-1 B'PA + Q = 0
%

% initial condition
system.x0 = [20; -20];

% system 
system.h=0.1;
system.A = [1 system.h; 0 1];
system.B = [0; system.h];
system.c = [0; 0];
system.n = size(system.A,2);
system.m = size(system.B,2);

% constraints
constraints.C = [1 0; -1 0; 0 1;0 -1; 0 0];
constraints.D = [0;0;0;0;-1];
constraints.e = [20;20;20;20;0];

% terminal constraints
constraints.G = [1 0;-1 0;0 1; 0 -1];
constraints.h = [2;2;2;2];

% disturbance
constraints.E = [1 0; -1 0; 0 1; 0 -1];
constraints.g = 0.1*ones(size(constraints.E,1),1);

% cost
cost.Q = 3*eye(system.n);
cost.R = 2*eye(system.m);

% terminal cost
[cost.P, ~, ~] = dare(system.A, system.B, cost.Q, cost.R);


% state feedback
%system.K = inv(cost.R + system.B' * cost.P * system.B) * system.B' * cost.P * system.A;
p = [2,0.5];
system.K = place(system.A, system.B, p);

% problem reformulation
system.A_K = system.A + system.B * system.K;

% horizon
system.L = 9;
    
% alpha
system.alpha = 0.25;

% max number of iterations
system.Nsim = 500;

% alpha 
alpha = 0.25;