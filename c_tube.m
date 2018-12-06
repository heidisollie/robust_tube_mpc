function X=c_tube(system,constraints)
%generates N-step controllable sets
    i=1;
    X(i)=Polyhedron(constraints.G,constraints.h);
    Z(i)=Polyhedron([],[]);
    while i<= system.N
        i=i+1;
        current_target.G=X(i-1).A;
        current_target.h=X(i-1).b;
        %generate i-step controllable set
        L=[constraints.C constraints.D; current_target.G*system.A current_target.G*system.B];
        r=[constraints.e; current_target.h];
        Z(i)=Polyhedron(L,r);
        X(i)=Polyhedron(L,r).projection(1:system.n);
    end