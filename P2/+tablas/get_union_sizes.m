function [v1,v2,v3] = get_union_sizes(type)
  
  switch type
    case 1
      v1 = 2.54;
      v2 = 22.86;
      v3 = 0;
    case 2
      v1 = 2.54;
      v2 = 2.54;
      v3 = 11.43;
    case 3 
      v1 = 2.54;
      v2 = 2.54;
      v3 = 0;
    case 4
      v1 = 2.54;
      v2 = 2.54;
      v3 = 0;
    case 5
      v1 = 2.54;
      v2 = 2.54;
      v3 = 0;
    case 6
      v1 = 2.233;
      v2 = 2.54;
      v3 = 0;
  otherwise
    disp('Error, type not valid')
  end
end
