function [X_tube,U_tube]=construct_tubes(z,v,S_K,K, Nsim)

%note: cannot preallocate bcs polyhedron

%generating tubes
for i=1:Nsim
    X_tube(i)=z(:,i)+ S_K;
    U_tube(i)=v(:,i)+ K * S_K;
end

%X_tube(Nsim+1)=z(:,Nsim)+ S_K;