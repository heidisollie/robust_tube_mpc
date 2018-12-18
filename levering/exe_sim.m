close all;
%% Offline
system.alpha = 0.15;

%load system data
data;

%offline calculations
offline_calc;

%generate disturbance sequence
W = Polyhedron(disturbance.E, disturbance.g);
W_vertices = size(W.V,1);
w_sequence = zeros(size(disturbance.E,2), system.N);
for i=1:system.Nsim
    problem.system.w_sequence(:,i) = (W.V)'*rand(W_vertices,1);
end    

%initial condition
system.x0 = [-15; -15];
x(:,1) = system.x0;

%% Online
for i = 1:system.Nsim
    % Return optimal x and u for horizon
    optimal(i) = online_calc(problem, x(:,i));
    % Apply first value
    v(:,i) = optimal(i).v(:,1);
    z(:,i) = optimal(i).z(:,1);
    u(:,i) = v(:,i) + problem.system.K * ( x(:,i) - z(:,i));
    if ~(i == system.Nsim)
        x(:,i+1) = problem.system.A * x(:,i) + problem.system.B * u(:,i) ...
             + problem.system.E * problem.system.w_sequence(:,i);
    end
end


%calculate tubes with center in nominal system
for i=1:system.Nsim
    X_tube(i)=z(:,i)+ system.S_K;
end

%create error state
e = x - z;  

%% Plot
figure; hold on;
for i=1:system.N+1
    plot(X_c(system.N+1-i+1),'Color',[0.3 0 0.3], 'alpha', 0.0125, 'LineStyle',':');    
    plot(X(system.N+1-i+1),'Color',[0 0.3 0.3], 'alpha', 0.0125);
end
plot(X_tube,'Color', [0.3 0.2 1], 'alpha', 0.125);
z_legend = plot(z(1,:),z(2,:), 'c.--');
x_legend = plot(x(1,:),x(2,:),'Color', [0.9 0.9 0.2], 'LineStyle', '--');
e_legend = plot(e(1,:),e(2,:), 'r-', 'LineWidth', 1.2);
legend([z_legend,x_legend, e_legend],{'nominal state', 'system state', 'error state'}, 'Interpreter', 'Latex')
hold off;