% System, constraints and target set
% 
% system - x+ = Ax + Bu + Ew
% constraints -  Z = {x, u | Cx + Du \leq e }
% disturbance - W = { w | Ew \leq g }
% cost J = sum_0^L-1  x_k'Qx_k + u_k'Ru_k + x_L' P x_L
% terminal constraints -  X_f = { x | Gx \leq h }
% terminal cost Vf = 0.5 * x' * P * x, A'PA - P- A'PB(R+B'PB)^-1 B'PA + Q = 0
%

% initial condition
system.x0 = [7; -7];

% system 
system.h=0.1;
system.A = [1 system.h; 0 1];
system.B = [0; system.h];
system.E = [1 0; 0 1];
system.n = size(system.A,2);
system.m = size(system.B,2);

% constraints
constraints.C = [1 0; -1 0; 0 1;0 -1; 0 0; 0 0];
constraints.D = [0;0;0;0;-1; 1];
constraints.e = [10;10;10;10;50;50];

%terminal constraints
constraints.G = [1 0; -1 0; 0 1; 0 -1];
constraints.h = [15; 15; 15; 15];

% disturbance
disturbance.E = [1 0; -1 0; 0 1; 0 -1];
disturbance.g = 0.1*ones(size(disturbance.E,1),1);

% cost
cost.Q = 3*eye(system.n);
cost.R = 2*eye(system.m);

% alpha
system.alpha = 0.25;

% max number of iterations
system.Nsim = 100;