function  connection = get_semirigid_connection(beam_index)
  
  switch beam_index
    case {1,4,7}
      connection = "W12x99";
  case {2,5,8}
      connection = "W12x40";
  case {3,6,9}
      connection = "W12x19";
  case {10,11,12,13}
      connection = "W12x87";
  case {14,15}
      connection = "W12x65";
  otherwise
    disp('Beam index not valid')
  end
end
