function [X_inner,X_outer]=rpia_of_mrpis(system,disturbance,alpha)
i=1;
disturbance_set=Polyhedron(disturbance.E,disturbance.g);
X(i)=disturbance_set;
while not(system.A_K^i*disturbance_set<=alpha*disturbance_set) 
    i=i+1;
    X(i)=system.Acl*X(i-1)+disturbance_set;
end

x_translation=(eye(system.n)-system.A_K)^(-1)*system.bcl;
X_inner=x_translation+X(i);
X_outer=x_translation+(1-alpha)^(-1)*X(i);
    
    
    
% Construct X_outer, {X_k}_k=0^N and {Z_k}_k=0^N