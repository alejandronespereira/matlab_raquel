function solution=solveLS(K,f,fixed_dofs,fixed_values)
% Solver para Sistema Lineal con CC

% Miramos que las CC sean coherentes;  numero de valores y numero de condiciones
assert(length(fixed_dofs)==length(fixed_values),'Error en solverLS');

f=f-K(:,fixed_dofs)*fixed_values;   
alpha=mean(diag(K));    %Magnitud apoximada de Kuu

K(fixed_dofs,:)=0;
K(:,fixed_dofs)=0;

% Esto funciona porque las fixed_dofs van de 0 a N de manera continua (sin agujeros)
K(fixed_dofs,fixed_dofs)=alpha*eye(length(fixed_dofs));

f(fixed_dofs)=alpha*fixed_values;

solution=K\f;
