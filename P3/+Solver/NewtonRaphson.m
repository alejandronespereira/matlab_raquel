function [ incd, sstate ] = NewtonRaphson(d_n,f_n,incf,sstate_k,data)

d = d_n;
f = f_n + incf;
p = FEM.Ensamblaje_P(data,sstate_k);
r = f-p;
r(data.fixed_dofs) = 0.0;
conv = norm(r/(1+norm(f)));

k = 1;

while k<=data.maxiter && conv>=data.epsilon
    
   fprintf('Iteration = %3d \t Residual %7.5e \n',k,conv);
   
   Kt = FEM.Ensamblaje_K(data,sstate_k);
   
   delta_d = SOLVER.SolverLS(Kt,r,data.fixed_dofs,data.fixed_dofs*0);
   
   d = d + delta_d;
   
   sstate = FEM.UpDateState(data,delta_d,sstate_k);
   
   p = FEM.Ensamblaje_P(data,sstate);
   
   r = f-p;
   
   r(data.fixed_dofs) = 0.0;
   
   conv = norm(r/(1+norm(f)));
   
   sstate_k = sstate;
   
   k = k+1;
end

incd = d-d_n;

if (k>data.maxiter)
   error('No convergence in %d iterations!\n',data.maxiter);
else
   fprintf('Residual = %e\n',conv); 
end

end