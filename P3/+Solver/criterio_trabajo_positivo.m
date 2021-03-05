function signo = criterio_trabajo_positivo(q,v_n)
  criterio = q'*v_n;
    
  if criterio>=0
    signo = 1;
  else
    signo = -1;
  end  
end
