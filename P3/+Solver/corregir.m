% Etapa de correccion de arclength

function [u,lambda] = corregir(u,delta_u,lambda,delta_lambda,q,data)
  
  kmax = data.kmax;
  psi = data.psi;
  epsilon = data.epsilon;
  l = data.l;
  
  p_int = fem.pint(u,data);
  residuo = p_int - lambda * q;
  residuo(data.fixed.nodes) = 0;
  
  r0 = norm(residuo);
  
  r_k = r0;
  c_k = 0;
  
  % Delta desplazamiento bucle correccion, empieza con valor de delta_u
  delta_u_k = delta_u;
  % Delta lambda bucle correccion, empieza con valor de delta_lambda
  delta_lambda_k = delta_lambda;
  
  % Desplazamiento bucle correccion, empieza con valor de u
  u_k = u;
  % Lambda bucle correccion, empieza con valor de lambda
  lambda_k = lambda;
  
  % Criterio de convergencia (empieza en 1):
  conv = r_k/r0;
  
  % Bucle de correccion
  k = 1;
  while(k <= kmax && conv >= epsilon)
%    fprintf('Iteracion=%3d \t Residuo =%7.5e \n',k,conv);
    Kt=fem.Ktangente(u_k,data);
  
    y=Solver.solveLS(Kt,q,data.fixed.nodes,data.fixed.values);
    x=Solver.solveLS(Kt,residuo,data.fixed.nodes,data.fixed.values);
    
    eta = 0.5 * (-c_k + 2 * delta_u_k' * x) / (delta_u_k'*y + delta_lambda_k * psi^2 * q'*q);
    
    d_k = -x + eta * y;
    
    % Actualizamos delta lambda y desplazamiento del bucle de correccion
    delta_lambda_k = delta_lambda_k + eta;
    delta_u_k = delta_u_k + d_k;
    
    % Actualizamos residuo y comprobamos convergencia
    
    c_k = delta_u_k' * delta_u_k + (delta_lambda_k^2) * psi^2 * q' * q - l^2;
    
    u_k = u_k + d_k;
    lambda_k = lambda_k + eta;
    p_int_k = fem.pint(u_k,data);
    
    residuo = p_int_k - lambda_k * q;
    residuo(data.fixed.nodes) = 0;
    
    r_k=norm(residuo);
    conv=r_k/r0;
    k=k+1;    
  end
  
  % Comprobamos que el bucle ha hecho menos que el maximo de iteraciones
  
  if k>=data.kmax
    error('No convergen en la iteración %d\n',k-1);
  else
%    fprintf('Residuo=%e\n',conv);
  end
  
  % Actualizamos valores
  u = u_k;
  lambda = lambda_k;
    
end 