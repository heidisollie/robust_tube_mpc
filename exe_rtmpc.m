
data;

rtmpc_offline;

x(:,1) = system.x0;

for i = 1:system.Nsim
    % Return optimal x and u for horizon
    optimal(i) = rmpc(problem, x(:,i));
    V(i) = optimal(i).cost_V;
    % Apply first value
    v(:,i) = optimal(i).v(:,1);
    z(:,i) = optimal(i).z(:,1);
    u(:,i) = v(:,i) + problem.system.K * ( x(:,i) - z(:,i));
    w(:,i) = problem.rmpc_disturbance.w_sequence(:,i);
    x(:,i+1) = problem.system.A * x(:,i) + problem.system.B * u(:,i) + w(:,i);
end

z(:,i+1) = [0; 0];
%% PLOTTING

%Plot controllable sets and states for each iteration
figure; hold on; grid on;
cs=1.75;

%Plot the states
st = plot(x(1,:),x(2,:), 'k*-', ...
    'LineWidth', 1.2);
err = plot(x(1,:)-z(1,:), ...
           x(2,:) - z(2,:), ...
           'b--');
legend([st err], 'State', 'Error')