function [X_tube,U_tube]=construct_tubes(z,v,S,K, Nsim)

%note: cannot preallocate bcs polyhedron

%generating tubes
for i=1:Nsim
    X_tube(i)=z(:,i)+ S;
    U_tube(i)=v(:,i)+ K * S;
end

X_tube(Nsim+1)=z(:,Nsim+1)+ S;