function [X,Z]=c_tube(system,constraints,target)
    i=1;
    X(i)=Polyhedron(target.G,target.h);
    Z(i)=Polyhedron([],[]); % initiate with empty Z0
    while i<= system.N
        i=i+1;
        current_target.G=X(i-1).A;
        current_target.h=X(i-1).b;
        %generate i-step controllable set
        L=[constraints.C constraints.D; target.G*system.A target.G*system.B];
        r=[constraints.e; target.h];
        Z(i)=Polyhedron(L,r);
        n=size(system.A,2);
        X(i)=Z(i).projection([1:n]);
    end