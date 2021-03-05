function signo = criterio_angulo(delta_lambda,v_n,delta_u)
  criterio = delta_lambda + v_n' * delta_u;
  
  if criterio>=0
    signo = 1;
  else
    signo = -1;
  end  
end
