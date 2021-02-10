function K = KeBeam2D_member(beam_index,material,P,structure)
  K = zeros(6,6);
  L = structure.lengths(beam_index);
  E = material.E;
  I = material.I;
  A = material.A;
  % La fuerza axial en una columna es la fuerza vertical en el nodo superior. 
  % topology indica los indices de las fuerzas/desplazamientos para cada nodo
  % Asi, topology(1:3) son los indices de Fx,Fy y M o ux, uy y theta para el nodo 1
  % y topology(4:6) el equivalente para el nodo 2 
  % M_a es el nodo 1, por seguir la convencion de la referencia
  M_a = P(structure.topology(3));
  M_b = P(structure.topology(6));
  
  % siguiendo el enunciado de la practica
  kappa = material.kappa;
  c1 = material.c1;
  c2 = material.c2;
  c3 = material.c3;
  
  kappa_a = kappa * M_a
  theta_a = c1 * kappa_a + c2 * (kappa_a**3) + c3 * (kappa_a**5)
  
  kappa_b = kappa * M_b;
  theta_b = c1 * kappa_b + c2 * (kappa_b**3) + c3 * (kappa_b**5);
  
  k_a = M_a/theta_a;
  k_b = M_b/theta_b;
  
  k_r = (1+(4*E*I)/(L*k_a))*(1+(4*E*I)/(L*k_b)) - (4/(k_a*k_b))*(E*I/L)**2;
  
  rii = (4+(12*E*I)/(L*k_b))/k_r;
  rjj = (4+(12*E*I)/(L*k_a))/k_r;
  rij = 2/k_r;
  
  K(1,1) = A*E/L;
  
  K(2,2) = E * I * (rii+rjj+2*rij) / (L**3);
  
  K(3,2) = (rii+rij) * E*I / (L**2);
  K(3,3) = rii*E*I/L;
  
  K(4,1) = -A*E/L;
  K(4,4) = A*E/L;
  
  K(5,2) = -E * I * (rii+rjj+2*rij) / (L**3);
  K(5,3) = - (rii+rij) * E*I / (L**2);
  K(5,5) = E * I * (rii+rjj+2*rij) / (L**3);
  
  K(6,2) = E*I *(rij+rjj) / (L**2);
  K(6,3) = rij * E * I / L;
  K(6,5) = -(rij + rjj) * E * I / (L**2);
  K(6,6) = rjj * E * I /L;
  
  # Hacer la matriz simetrica
  for i = 1:6
    for j = 1:i
      K(j,i) = K(i,j);
    end
  end  
end
