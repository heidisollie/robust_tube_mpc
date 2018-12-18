% close all;

system.alpha = 0.15;
data;
load('SKseq.mat')
offline_calc;

problem.system.w_sequence =  generate_disturbance(problem);

system.x0 = [16.5; 11.5];
x(:,1) = system.x0;



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


 [X_tube,U_tube]=construct_tubes(z,v,system.S_K,system.K, system.Nsim);
  
% [alpha_array, N_array] = generate_N_alpha(problem);
% constraint_set = Polyhedron(constraints.C + constraints.D, constraints.e_org);
% t_constraint_set = Polyhedron(constraints.C + constraints.D, constraints.e);
% K_constraint_set = Polyhedron(constraints.C + constraints.D*system.K, constraints.e_org);
% K_t_constraint_set = Polyhedron(constraints.C + constraints.D*system.K, constraints.e);

%% PLOTTING


%Plot N and alpha (A_K^N W \in alpha W)
%generate_N_alpha;

%Plot predicticed tubes X, U, and stats x,z
figure; hold on;
color1 = [0.3 0 0.3];
color2 = [0 0.3 0.3];
cs=1.75;
for i=1:system.N+1
    plot(X_c(system.N+1-i+1),'Color',(1-i/(cs*(system.N+1)))*color2, 'alpha', 0.0125, 'LineStyle',':');    
    plot(X(system.N+2-i),'Color',(1-i/(cs*(system.N+1)))*color1, 'alpha', 0.0125);
end
plot(X_tube,'Color', [0.3 0.2 1], 'alpha', 0.125);
z_legend = plot(z(1,:),z(2,:), 'r.--', 'LineWidth', 1.2);
x_legend = plot(x(1,:),x(2,:),'Color', [0.9 0.9 0.2], 'LineStyle', '--', 'LineWidth', 1.2);
e_legend = plot(x(1,:) - z(1,:),x(2,:) - z(2,:), 'c--', 'LineWidth', 1.2);
legend([z_legend,x_legend, e_legend],{'nominal state $\bar{x}$', 'system state $x$', 'error state $x - \bar{x}$'}, 'Interpreter', 'Latex')
%legend([z_legend,x_legend],{'nominal state $\bar{x}$', 'system state $x$'}, 'Interpreter', 'Latex')
%legend([S_K_leg e_legend],{'${S_K}_N(\alpha)$', 'error state $(x - \bar{x})$'}, 'Interpreter', 'Latex')
hold off;
print('simulation', '-depsc', '-r300') 


%Plot for different alphas
% color3 = [0 0 1];
% color4 = [1 0 0];
% figure; hold on;
% for i=system.N_08
%     st_08 = plot(X_c_alpha_08(system.N+1-i+1),'Color',(1-1/(cs))*color3, 'alpha', 0.125, 'LineStyle',':');    
%     plot(X_alpha_08(system.N+2-i),'Color',(1-1/(cs))*color3, 'alpha', 0.125);
% end
% for i = system.N
%     st_025 = plot(X_c(system.N+1-i+1),'Color',(1-1/(cs))*color4, 'alpha', 0.125, 'LineStyle',':');    
%     plot(X(system.N+2-i),'Color',(1-1/(cs))*color4, 'alpha', 0.125);
% end
% legend([st_08 st_025], {'$\alpha = 0.8$', '$\alpha = 0.25$'}, 'Interpreter', 'Latex');
% print('N_alpha_08_025', '-depsc', '-r300') 

% %Plot constraint set before and after
% figure; hold on;
% plot(constraint_set, 'Color', [0.3 0.4 0.2], 'alpha', 0.125);
% plot(t_constraint_set, 'Color', [0.3 0.6 0.2], 'alpha', 0.125, 'LineStyle', '--');
% hold off;
% 
% %Plot another set before and after
% figure; hold on;
% plot(K_constraint_set, 'Color', [0.3 0.4 0.2], 'alpha', 0.125);
% plot(K_t_constraint_set, 'Color', [0.3 0.6 0.2], 'alpha', 0.125, 'LineStyle', '--');

% S_K_seq = generate_S_K_seq(problem);test
% 
% alpha_tmp = 0.25;
% while and(not(system.A_K^i * disturbance_set <= alpha * disturbance_set), i <= 500)
%     i = i + 1;
% end
% N = i;
% S_K_tmp = (1-alpha)^(-1)*S_K_seq(N);
% figure; hold on;
% plot(S_K_tmp, 'Color', [1 0 1], 'alpha', 0.125);
% for i=1:5:100
%     plot(S_K_seq(i), 'Color', (1-i/(cs*(100)))*color3, 'alpha', 0.125);
% end    
% 
% figure; hold on;
% 
% 
% 
% figure; hold on;
% for i=0:29
%     SK_leg = plot(system.X_2(30-i), 'Color',(1-(30-i)/(cs*(30)))*color3, 'alpha', 0.05);
%     
%     AK_leg = plot(system.A_K^i * disturbance_set, 'Color', (1-i/(1.5*(30)))*[1 1 1], 'alpha', 0.5);
% end
% alpha_leg =plot(system.alpha * disturbance_set, 'Color', [1 0 0], 'alpha', 0.125);
% legend([SK_leg], {'${S_K}_i$'}, 'Interpreter', 'Latex');
% print('A_K_W_alpha_W', '-depsc', '-r300') 
% hold off;