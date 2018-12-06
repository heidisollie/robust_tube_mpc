close all;

data;

rtmpc_offline;

x(:,1) = system.x0;
x_nom(:,1) = system.x0;

for i = 1:system.Nsim
    % Return optimal x and u for horizon
    optimal(i) = mpc(problem, x(:,i));
    V(i) = optimal(i).cost_V;
    % Apply first value
    v(:,i) = optimal(i).v(:,1);
    z(:,i) = optimal(i).z(:,1);
    u(:,i) = v(:,i) + problem.system.K * ( x(:,i) - z(:,i));
    x(:,i+1) = problem.system.A * x(:,i) + problem.system.B * u(:,i) ...
             + problem.system.E * problem.system.w_sequence(:,i);
    x_nom(:,i+1) = problem.system.A * x_nom(:,i) + problem.system.B * u(:,i);
end

z(:,i+1) = [0; 0];

[X_tube,U_tube]=construct_tubes(z,v,system.S_K,system.K, system.Nsim);
[alpha_array, N_array] = generate_N_alpha(problem);
constraint_set = Polyhedron(constraints.C + constraints.D, constraints.e_org);
t_constraint_set = Polyhedron(constraints.C + constraints.D, constraints.e);
K_constraint_set = Polyhedron(constraints.C + constraints.D*system.K, constraints.e_org);
K_t_constraint_set = Polyhedron(constraints.C + constraints.D*system.K, constraints.e);
%% PLOTTING


%Plot state and error trajectory
figure; hold on; grid on;
cs=1.75;
st = plot(x(1,:),x(2,:), 'k*-', ...
    'LineWidth', 1.2);
st_nom = plot(x_nom(1,:), x_nom(2,:), 'g');
Polyhedron(problem.constraints.C, problem.constraints.e).plot('color', 'b', 'alpha', 0.2);
hold off;       
legend('State', 'Nominal state')

%Plot N and alpha (A_K^N W \in alpha W)
figure; grid on; hold on;
plot(N_array, alpha_array);
plot(system.N, system.alpha, 'k*-', ...
    'LineWidth', 1.4);

hold off;
xlabel('N')
ylabel('alpha')

%Plot predicticed tubes X, U
figure; hold on;

color1 = [1 0.3 0.5];
color2 = [1 0.3 0.5];
%X_c is the controllable tube, X is the controllable tube + S_K
for i=1:system.N+1
    plot(X_c(system.N+1-i+1),'Color',(1-i/(cs*(system.N+1)))*color2, 'alpha', 0.125, 'LineStyle',':');    
    plot(X(system.N+2-i),'Color',(1-i/(cs*(system.N+1)))*color1, 'alpha', 0.125);
end
%this is the nominal state z + S_K
plot(X_tube,'Color', [0.3 0.2 1], 'alpha', 0.125);
z_legend = plot(z(1,:),z(2,:), 'k.--');
x_legend = plot(x(1,:),x(2,:),'Color', [0.9 0.9 0.2], 'LineStyle', '--');
x_nom_legend = plot(x_nom(1,:),x_nom(2,:),'Color', [1 0 0.5], 'LineStyle', '--');
legend([z_legend,x_legend, x_nom_legend],{'MPC state', 'system state', 'nominal state'})

figure; hold on;
plot(constraint_set, 'Color', [0.3 0.4 0.2], 'alpha', 0.125);
plot(t_constraint_set, 'Color', [0.3 0.6 0.2], 'alpha', 0.125, 'LineStyle', '--');
hold off;
figure; hold on;

plot(K_constraint_set, 'Color', [0.3 0.4 0.2], 'alpha', 0.125);
plot(K_t_constraint_set, 'Color', [0.3 0.6 0.2], 'alpha', 0.125, 'LineStyle', '--');