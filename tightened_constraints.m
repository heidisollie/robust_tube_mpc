function t_constraints = tightened_constraints(problem)


% Z = X - S \check
% V = U - K_s * S

X = Polyhedron(problem.constraints.C, problem.constraints.e);

U = Polyhedron(problem.constraints.D, problem.constraints.e);

disturbance_set=Polyhedron(problem.constraints.E,problem.constraints.g);
% Find S
% S(\infty) is difficult to compute, find one that is "enough"
% Find theta_\infty \leq (1 - alpha)^-1 \theta_N

N=1;
while ~(problem.system.A_K^N * disturbance_set <= problem.system.alpha * disturbance_set)
    N = N + 1;
end

tmp = zeros(size(constraints.C,1), size(disturbance_set.V,1));
theta_N = zeros(size(constrains.C,2), size(disturbance_set.V,1));

% Calculate \theta_N
for k=1:size(constraints.C,1)
    c_x = constraints.C(k,:);
    c_u = constraints.D(k,:);
    d = constraints.e(k,:);
    for i=1:N
        for i=1:size(disturbance_set.V, 1)
            W_vertice = disturbance_set.V(i,:)';
            tmp(k, i) = tmp(k, i) + c_x * problem.system.A_K^i * W_vertice ...
                  + c_u * problem.system.K*problem.system.A_K^i * W_vertice;
        end
    % Find maximum value for each row 
    [~, ind] = max(tmp(k,:));
    theta_N(:,i) = disturbance_set.V(ind,:)';
    end
end


t_constraints.e = problem.system.constraints.e - (1 - alpha)^-1 * theta_N;
t_constraints.C = problem.system.constraints.C;
t_constraints.D = problem.system.constraints.D;
    
    
    
% Construct X_outer, {X_k}_k=0^N and {Z_k}_k=0^N
