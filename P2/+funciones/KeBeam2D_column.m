function K = KeBeam2D_column(beam_index,material,P,structure)
  K = zeros(6,6);
  L = structure.lengths(beam_index);
  
  % La fuerza axial en una columna es la fuerza vertical en el nodo superior. 
  % topology indica los indices de las fuerzas/desplazamientos para cada nodo
  % Asi, topology(1:3) son los indices de Fx,Fy y M o ux, uy y theta para el nodo 1
  % y topology(4:6) el equivalente para el nodo 2 
  Paxial = P(structure.topology(5));
  K(2,2) = 6/5;
  K(3,2) = L/10;
  K(3,3) =  L * L / 7.5;
  K(5,2) = -6/5;
  K(5,3) = -L/10;
  K(5,5) = 6/5;
  K(6,2) = L/10;
  K(6,3) = -(L*L)/30;
  K(6,5) = -L/10;
  K(6,6) = L* L / 7.5;
  K = Paxial * K / L;    
  
  # Hacer la matriz simetrica
  for i = 1:6
    for j = 1:i
      K(j,i) = K(i,j);
    end
  end  
end
