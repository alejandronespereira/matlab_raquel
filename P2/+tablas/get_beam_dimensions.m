function  [rb,Hc,tf] = get_beam_dimensions(beam_type)
  
  switch beam_type
    case "W12x99"
      Hc = 12.75;
      tf = 0.921;
    case "W12x40"
      Hc = 11.94;
      tf = 0.515;
    case "W12x19"
      Hc = 12.16;
      tf = 0.35;
    case "W12x87"
      Hc = 12.53;
      tf = 0.81;
    case "W12x65"
      Hc = 12.12;
      tf = 0.605;
  otherwise
    disp('Beam type not valid')
    return;
  end    
    % Convert to meters from inches
    Hc = Hc / 39.37;
    tf = tf / 39.37;
    % invent 
    rb = 1.5 * tf;
end
