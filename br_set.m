function X=br_set(system,constraints,target)
    L=[constraints.C_K; target.G*system.A_K];
    r=[constraints.d_K; target.h];
    X=Polyhedron(L,r);