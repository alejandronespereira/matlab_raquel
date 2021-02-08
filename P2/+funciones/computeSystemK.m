function K = computeSystemK(structure,material,P)
  dofs = 36;
  K = zeros(dofs,dofs);
  for i = 1:length(structure.angles)
    k_e = funciones.KeBeam2D(i,material,P,structure);
    angle = structure.angles(i);
    K = K + funciones.computeGlobalK(k_e,structure.topology(:,i),angle);
  end
  
  
end
