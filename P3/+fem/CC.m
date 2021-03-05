function [ K_mod, q_mod ] = CC(K,q,data)
  
  n_nodos = data.n_nodes;
  n_dofs = data.ndof;
  n_dofs = n_nodos * n_dofs;
  
  % indices de los nodos sin libertad
  id_fijos = data.fixed;
  
  % indices de los nodos con grados de libertad: todos los indices menos los que ya teniamos
  id_libres = [1:n_dofs];
  id_libres(id_fijos) = [];
  
  % Modificamos el vector de fuerzas
  % Las fuerzas de los elementos fijos son 0:
  q_mod = zeros(n_dofs,1);
  q_mod
  id_libres
  id_fijos'
  K(id_libres,id_fijos)
  q_mod(id_libres) = q(id_libres) - K(id_libres,id_fijos) * data.fixed;
  
  % Modificamos la matriz tangente
  K_mod = zeros(size(K));
  K_mod(id_libres,id_libres) = K(id_libres,id_libres);
  K_mod(id_fijos,id_fijos) = eye(size(id_fijos,1));
  
end
