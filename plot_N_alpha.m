function [N, alpha] = plot_N_alpha(problem)


max_N = 50;
alpha_array = zeros(1, max_N);
num_w_vertices = size(problem.constraints.W.V,1);


for i=1:num_w_vertices
    w_vertices = problem.constraints.W.V(i,:);
    for N=1:max_N+1
        %solve for alpha and save
        
    