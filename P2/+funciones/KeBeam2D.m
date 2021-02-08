function K_e = KeBeam2D(beam_index,material,P,structure)
  K_e = zeros(6,6);

  switch beam_index
    case {1,2,3}
      K_e = funciones.KeBeam2D_base(beam_index,material,P,structure);
  case {4,5,6,7,8,9}
      K_e = funciones.KeBeam2D_column(beam_index,material,P,structure);
    case {10,11,12,13,14,15}
      K_e = funciones.KeBeam2D_member(beam_index,material,P,structure);
    otherwise
      disp('Beam index not valid')
      return
  end

