function S_K_seq = generate_S_K_seq(problem)

i=1;
disturbance_set=Polyhedron(problem.disturbance.E,problem.disturbance.g);
S_K_seq(i) = disturbance_set;



while i < 80
    display(i)
    i = i + 1;
    S_K_seq(i) = problem.system.A_K * S_K_seq(i-1) + problem.system.E * disturbance_set;
end