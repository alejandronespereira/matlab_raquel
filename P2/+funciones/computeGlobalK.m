function K = computeGlobalK(k_element,element_topology,angle)
  K = zeros(36,36); % 12 nodes, 3 dof each
  M = rotational_matrix(angle);
  k_gcs = M' * k_element * M;
    
  for j = 1:length(element_topology)
    for l = 1:length(element_topology)
      K(element_topology(j),element_topology(l)) += k_element(j,l);
    end
  end
end
