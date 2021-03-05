% Funcion Arclength a partir de control hiperesferico para el desarrollo 
% del estado de cargas desplazamientos no lineales

% uN : desplazamientos en el paso n + 1
% lambdaN: carga en el paso n + 1

% u: desplazamientos en el paso n
% lambda: carga en el paso n
% step: numero de paso para elegir criterio
function [ u_n1, lambda_n1,data] = arcLength(u_n,lambda_n,data, step)
  
  psi = data.psi;
  l = data.l;
  
  q = data.q;
  
  % Generamos la matriz tangente del sistema:
  K = fem.Ktangente(u_n,data);
  
  % Resolvemos el sistema
  v_n = Solver.solveLS(K,q,data.fixed.nodes,data.fixed.values);
  
  if (step <= 50)
    s = Solver.criterio_trabajo_positivo(q,v_n);  
  else
    s = Solver.criterio_angulo(data.previo.delta_lambda,v_n,data.previo.delta_u);  
  end
  
  delta_lambda = s * l / sqrt(v_n'*v_n + psi^2 * q'*q);
  delta_u = delta_lambda * v_n;
  
  % Para el criterio del angulo
  data.previo.delta_lambda = delta_lambda;
  data.previo.delta_u = delta_u;
  
  u_n = u_n + delta_u;
  lambda_n = lambda_n + delta_lambda;
  
  %% Empezamos la fase de correccion, en otra funcion por claridad:
  
  [u_n1,lambda_n1] = Solver.corregir(u_n,delta_u,lambda_n,delta_lambda,q,data);
  
  
end