function [X_c]=c_tube(system,constraints,target)
    i=1;
    X(i)=Polyhedron(target.G,target.h);
    Z(i)=Polyhedron([],[]);
  
    while i<= system.N
        i=i+1;
        current_target.G=X(i-1).A;
        current_target.h=X(i-1).b;
        %generate i-step controllable set
        L=[constraints.C constraints.D; current_target.G*system.A current_target.G*system.B];
        r=[constraints.e; current_target.h];
        Z(i)=Polyhedron(L,r);
        n=size(system.A,2);
        X(i)=Z(i).projection([1:n]);
    end