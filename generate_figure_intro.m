
clear x_traj_1 x_traj_2 x_traj_3 x_traj_4 x_traj_5 x_traj_6

x0 = [-15; -15];

x_traj_1(:,1) = x0;
x_traj_2(:,1) = x0;
x_traj_3(:,1) = x0;
x_traj_4(:,1) = x0;


w_seq_1 = generate_disturbance(problem);
w_seq_2 = generate_disturbance(problem);
w_seq_3 = generate_disturbance(problem);
w_seq_4 = generate_disturbance(problem);

E = 1;

for i = 1:50
    % Return optimal x and u for horizon
    optimal_1(i) = online_calc(problem, x_traj_1(:,i));
    optimal_2(i) = online_calc(problem, x_traj_2(:,i));
    optimal_3(i) = online_calc(problem, x_traj_3(:,i));
    optimal_4(i) = online_calc(problem, x_traj_4(:,i));

    v_1(:,i) = optimal_1(i).v(:,1);
    z_1(:,i) = optimal_1(i).z(:,1);
    v_2(:,i) = optimal_2(i).v(:,1);
    z_2(:,i) = optimal_2(i).z(:,1);
    v_3(:,i) = optimal_3(i).v(:,1);
    z_3(:,i) = optimal_3(i).z(:,1);
    v_4(:,i) = optimal_4(i).v(:,1);
    z_4(:,i) = optimal_4(i).z(:,1);
    
    u_1(:,i) = v_1(:,i) + problem.system.K * ( x_traj_1(:,i) - z_1(:,i));
    u_2(:,i) = v_2(:,i) + problem.system.K * ( x_traj_2(:,i) - z_2(:,i));
    u_3(:,i) = v_3(:,i) + problem.system.K * ( x_traj_3(:,i) - z_3(:,i));
    u_4(:,i) = v_4(:,i) + problem.system.K * ( x_traj_4(:,i) - z_4(:,i));


	x_traj_1(:,i+1) = problem.system.A * x_traj_1(:,i) + problem.system.B * u_1(:,i) + E*w_seq_1(:,i);
    x_traj_2(:,i+1) = problem.system.A * x_traj_2(:,i) + problem.system.B * u_2(:,i) + E*w_seq_2(:,i);
    x_traj_3(:,i+1) = problem.system.A * x_traj_3(:,i) + problem.system.B * u_3(:,i) + E*w_seq_3(:,i);
    x_traj_4(:,i+1) = problem.system.A * x_traj_4(:,i) + problem.system.B * u_4(:,i) + E*w_seq_4(:,i);

end

[X_tube,U_tube]=construct_tubes(z_3,v_3,system.S_K,system.K, 49);
%Plot state and error trajectory
figure; hold on; grid on;
cs=1.75;
plot(z_3(1,:), z_3(2,:), 'r', 'LineWidth', 1.4);
for i=1:49
plot(X_tube(i),'Color', [0.1 0.2 1], 'alpha', 0.015, 'LineStyle', ':');
end
plot(x_traj_1(1,:),x_traj_1(2,:), 'k', 'LineWidth', 1);
plot(x_traj_2(1,:),x_traj_2(2,:), 'k', 'LineWidth', 1);
plot(x_traj_3(1,:),x_traj_3(2,:), 'k', 'LineWidth', 1);
plot(x_traj_4(1,:),x_traj_4(2,:), 'k', 'LineWidth', 1);
%plot(X_tube,'Color', [0.1 0.2 1], 'alpha', 0.01);
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
print('intro_fig', '-depsc', '-r300') 
hold off;       

