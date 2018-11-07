function [N, alpha] = plot_N_alpha(problem)


max_N = 50;
alpha_array = zeros(1, max_N);
num_w_vertices = size(problem.constraints.W.V,1);
N = 1:max_N+1;

%since the disturbance set is a box we only check the vertices
for i=1:num_w_vertices
    w_vertices = problem.constraints.W.V(i,:);
    for k = N
        %solve for alpha and save
        alpha = %equation
        alpha_array(k) = alpha;
    end
end
   
%% PLOTTING

%Plot controllable sets and states for each iteration
figure; hold on; grid on;

plot(N-1, alpha_array);
legend(N, alpha)