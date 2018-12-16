function [S_K_tube]=construct_tubes_explicit(z,S_K_seq, Nsim)

%note: cannot preallocate bcs polyhedron

%generating tubes
for i=1:Nsim
    S_K_tube(i)=z(:,i)+ S_K_seq(i);
end

