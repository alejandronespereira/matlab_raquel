
% funcion para resolver situaciones no lineales mediante arclength

function [uResults,lambdaResults,data] = arclength_solver (data)

  n_nodes = data.n_nodes;
  n_dof = data.ndof;
  n_forces = n_nodes * n_dof;
  
  % Lo guardamos todo
  n_steps = data.n_steps;
  d1=zeros(n_steps,n_forces);
  lambda1=zeros(n_steps,n_forces);

  d=zeros(n_dof,n_forces);

  lambda=0;
  lambdaResults = zeros(n_steps,1);
  uResults = zeros(n_steps,n_forces);

  % Inicializamos variables
  lambdaResults(1) = lambda;
  u = zeros(n_forces,1);
 
  % El criterio del angulo requiere unos datos previos, los fabricamos:
  data.previo.delta_lambda = 0;
  data.previo.delta_u = zeros(n_forces,1);

  % Bucle principal
  for step = 1 : n_steps
    uResults(step,:) = u';
    lambdaResults(step) = lambda;
    
##    fprintf('Paso %3d\n',step);
    %Resolvemos con el Arclength en cada paso
    [ u_n, lambda_n,data] = Solver.arcLength( u, lambda,data,step);
    
    % Actualizamos valores
    u = u_n;
    lambda = lambda_n;
    
  end 
  
end