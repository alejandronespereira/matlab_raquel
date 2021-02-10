function K = KeBeam2D_base(beam_index,material,P,structure)
  K = zeros(6,6);
  K_1 = zeros(6,6);
  K_2 = zeros(6,6);
  L = structure.lengths(beam_index);
  E = material.E;
  I = material.I;
  A = material.A;
  
  % La fuerza axial en una columna es la fuerza vertical en el nodo superior. 
  % topology indica los indices de las fuerzas/desplazamientos para cada nodo
  % Asi, topology(1:3) son los indices de Fx,Fy y M o ux, uy y theta para el nodo 1
  % y topology(4:6) el equivalente para el nodo 2 
  % En el caso de la base de la columna, el nodo 1 (A) es la base y el nodo 2 no tiene momento 
  M_a = P(structure.topology(3));
  M_b = 0;
  Paxial = P(structure.topology(5));
  
  K_1(2,2) = 6/5;
  K_1(3,2) = L/10;
  K_1(3,3) =  L * L / 7.5;
  K_1(5,2) = -6/5;
  K_1(5,3) = -L/10;
  K_1(5,5) = 6/5;
  K_1(6,2) = L/10;
  K_1(6,3) = -(L*L)/30;
  K_1(6,5) = -L/10;
  K_1(6,6) = L* L / 7.5;
  K_1 = Paxial * K_1 / L;    
  
  %sustituyendo k_a por kbase y 1/kb por 0
  kappa = material.kappa;
  c1 = material.c1;
  c2 = material.c2;
  c3 = material.c3;
  
  kappa_a = kappa * M_a;
  theta_a = c1 * kappa_a + c2 * (kappa_a**3) + c3 * (kappa_a**5);
  
  [rb,Hc,tf] = tablas.get_beam_dimensions(tablas.get_semirigid_connection(beam_index));
  z = rb + 0.5*(Hc - tf);
  t = 0.01; % invent
  k_base = E * z * z * t / 20;
  
  k_r = 1 + (4*E*I)/(L*k_base);
  rii = 4 / k_r;
  rjj = (4 + (12 *E*I)/(L * k_base))/k_r;
  rij = 2/k_r;
  
  K_2(1,1) = A*E/L;
 
  K_2(2,2) = E * I * (rii+rjj+2*rij) / (L**3);

  K_2(3,2) = (rii+rij) * E*I / (L**2);
  K_2(3,3) = rii*E*I/L;

  K_2(4,1) = -A*E/L;
  K_2(4,4) = A*E/L;

  K_2(5,2) = -E * I * (rii+rjj+2*rij) / (L**3);
  K_2(5,3) = - (rii+rij) * E*I / (L**2);
  K_2(5,5) = E * I * (rii+rjj+2*rij) / (L**3);

  K_2(6,2) = E*I *(rij+rjj) / (L**2);
  K_2(6,3) = rij * E * I / L;
  K_2(6,5) = -(rij + rjj) * E * I / (L**2);
  K_2(6,6) = rjj * E * I /L;
  
  K_conventional = zeros(6,6);
  K_2 = K_2 + K_conventional;
  
  K = K_1 + K_2;
  # Hacer la matriz simetrica
  for i = 1:6
    for j = 1:i
      K(j,i) = K(i,j);
    end
  end  
end
