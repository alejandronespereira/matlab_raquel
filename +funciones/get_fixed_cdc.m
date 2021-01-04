function fixed = get_fixed_cdc(data,cdc)
  % Edificio, y == 30, 10<= x <= 20
  fixed_edificio = find(data.node(:,1) <= cdc.edificio(2) & data.node(:,1) >= cdc.edificio(1) & data.node(:,2) == cdc.altura_suelo_humedo);
  fixed_edificio_y = (fixed_edificio-1) * data.ndofn + 2;
  
  fixed_roca = find(data.node(:,2) == cdc.roca_impermeable); % Limite contra la roca y == 0
  fixed_pared_izquierda = find(data.node(:,1) == cdc.pared_izquierda); % Pared izquierda x == 0
  fixed_pared_derecha = find(data.node(:,1) == cdc.pared_derecha); % Pared derecha x == 50
  % Todos estos elementos no se mueven verticalmente
  ##fixed = [fixed_roca;fixed_pared_derecha;fixed_pared_izquierda];
  fixed_0 = fixed_roca;
  fixed_0_y = (fixed_0-1)*data.ndofn +2;
  % su valor inicial es 0
  fixed_values_0 = zeros(size(fixed_0_y));

  total_fixed = [fixed_0_y;fixed_edificio_y];
  % el edificio sin embargo tiene una presion de 0.25 hacia abajo
  total_fixed_values = [fixed_values_0;-0.25 * ones(size(fixed_edificio))];

  fixed.dofs = total_fixed;
  fixed.values = total_fixed_values;
  
  fixed.dofs = fixed_0_y;
  fixed.values = fixed_values_0;
  
  
endfunction
