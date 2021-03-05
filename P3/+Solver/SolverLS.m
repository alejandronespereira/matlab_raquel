function [ d ] = SolverLS(K, F, fixed_dofs, fixed_values)

C = median(diag(K));

K(fixed_dofs,:) = 0;      K(:,fixed_dofs) = 0;

K(fixed_dofs, fixed_dofs) = speye(length(fixed_dofs))*C;

F = F-K(:,fixed_dofs)*fixed_values; 

F(fixed_dofs) = fixed_values*C;

timerval = tic;

disp('>SOLVING THE SYSTEM');

d = K\F;

toc(timerval);

end