
%% get local s-state feedback and closed loop dynamics
desired_eigenvalues = [0.2 0.4];
system.K_S = -place(system.A,system.B,desired_eigenvalues);


system.Acl = system.A+system.B*system.K_S;
system.bcl = system.c;

% compute robust positive invariant approximation of the minimal robust
% positively invariant set and use it as the robust 0
[X_inner,X_outer] = rpia_of_mrpis(system,disturbance,alpha);
S = X_outer;
KSS = system.K_S*S; 
system.Acl_S = system.Acl;
system.bcl_S = system.bcl;
constraints.E = S.A;
constraints.f = S.b;
%% get tighter constraint set Y
constraints.Ccl=constraints.C+constraints.D*system.K_S;
for i=1:size(constraints.Ccl,1);
        S_effect_on_Y(i)=S.support(constraints.Ccl(i,:)');
end
constraints.e_original=constraints.e;
constraints.e=constraints.e_original- S_effect_on_Y';
%%
% get local z-state feedback and closed loop dynamics
% solve unconstrained infinite horizon DLQR
[K_Z,P]=dlqr(system.A,system.B,cost.Q,cost.R);
% get unconstrained infinite horizon closed loop dynamics and use related 
% unconstrained infinite horizon cost as the terminal cost
system.K_Z=-K_Z;
system.Acl=system.A+system.B*system.K_Z;
system.bcl=system.c;
cost.P=P;
% construct maximal positively invariant set for this closed loop dynamics 
% and related constraints and use this set as the terminal constraint set
constraints.Ccl=constraints.C+constraints.D*system.K_Z;
constraints.dcl=constraints.e;
[Zftube,Zf,d_index]=mpis(system,constraints,kmax);
constraints.G=Zf.A;
constraints.h=Zf.b;
% compute controllable sets and restricted preimages for illustration
target.G=Zf.A;
target.h=Zf.b;
[ZX,ZZ]=c_tube(system,constraints,target,N);
Z=ZX;
% get X controllable sets from Z controllable sets
for i=1:size(Z,2)
    X(i)=Z(i)+S;
end
% generate constraints and cost for optimal control problem
problem.cost=generate_cost(cost,N);
problem.constraints=generate_constraints(system,constraints,N);