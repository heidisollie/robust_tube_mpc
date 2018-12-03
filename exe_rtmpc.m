close all;

% data;
% 
% rtmpc_offline;
% 
% x(:,1) = system.x0;
% x_nom(:,1) = system.x0;
% 
% for i = 1:system.Nsim
%     % Return optimal x and u for horizon
%     optimal(i) = rmpc(problem, x(:,i));
%     V(i) = optimal(i).cost_V;
%     % Apply first value
%     v(:,i) = optimal(i).v(:,1);
%     z(:,i) = optimal(i).z(:,1);
%     u(:,i) = v(:,i) + problem.system.K * ( x(:,i) - z(:,i));
%     w(:,i) = problem.rmpc_disturbance.w_sequence(:,i);
%     x(:,i+1) = problem.system.A * x(:,i) + problem.system.B * u(:,i) + problem.system.E * w(:,i);
%     x_nom(:,i+1) = problem.system.A * x_nom(:,i) + problem.system.B * u(:,i);
% end

z(:,i+1) = [0; 0];

[X_tube,U_tube]=construct_tubes(z,v,system.S,system.K, system.Nsim);
[alpha_array, N_array] = generate_N_alpha(problem);

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
color = [1 0.3 0.5];
for i=1:system.N+1
    plot(X(system.N+2-i),'Color',((-i+3*system.N+1)/(3*system.N))*color);
    plot(Z(system.N+1-i+1),'Color',((-i+3*system.N+1)/(3*system.N))*color,'LineStyle',':');    
end
plot(X_tube,'Color', [0 0 1], 'alpha', 0.125);
plot(z(1,:),z(2,:),'k.--');
plot(x(1,:),x(2,:),'bo--');