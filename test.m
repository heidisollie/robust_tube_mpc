n=2; 
m=1;
nY=5;
nZf=4;
nS=4;
N = 40;
C = [3 3;3 3;3 3;3 3; 3 3];
D = [4;4;4;4;4];
G = [5 5; 5 5; 5 5; 5 5];
E = [2 2; 2 2; 2 2; 2 2];
e = [10; 10 ; 10 ; 10 ; 10];
h = [ 1 ; 1 ; 1 ; 1];
A = [9 9 ; 9 9];
B = [6 ; 6];
Q = [13 0; 0 13];
P = [5 0; 0 5];
R = 16;

Ain=zeros(N*nY+nZf+nS,(N+1)*n+N*m); % initialize
Bin=zeros(N*nY+nZf+nS,n);
cin=zeros(N*nY+nZf+nS,1);
% add stage constraints Czk + Dvk <= e
Ain(1:N*nY,1:N*n)=kron(eye(N),C);
Ain(1:N*nY,(N+1)*n+1:(N+1)*n+N*m)=kron(eye(N),D);
Bin(1:N*nY,1:n)=zeros(N*nY,n);
cin(1:N*nY,1)=kron(ones(N,1),e);
Ain(N*nY+1:N*nY+nZf,N*n+1:(N+1)*n)=G;
Bin(N*nY+1:N*nY+nZf,1:n)=zeros(nZf,n);
cin(N*nY+1:N*nY+nZf,1)=h;

a1 = [kron(eye(N), -A) zeros(n*N, 2)];
a2 = [zeros(n*N, 2) kron(eye(N), eye(n))];
a3 = a1 + a2;
a4 = kron(eye(N), -B);
Aeq = [a3 a4];
Beq = zeros(N * n, n);
ceq = zeros(N*n, 1);



%generate H

% generate H
H=zeros((N+1)*n+N*m,(N+1)*n+N*m);

H(1:N*n,1:N*n)=kron(eye(N),Q);
H(N*n+1:(N+1)*n,N*n+1:(N+1)*n)=P;
H((N+1)*n+1:(N+1)*n+N*m,(N+1)*n+1:(N+1)*n+N*m)=kron(eye(N),R);


