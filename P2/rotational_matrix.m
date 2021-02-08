function M = rotational_matrix(theta)
  M = zeros(6,6);
  
  M(1,1) = M(2,2) = cos(theta);
  M(4,4) = M(5,5) = cos(theta);
  M(1,2) = M(4,5) = sin(theta);
  M(2,1) = M(5,4) = -sin(theta);
  M(3,3) = M(6,6) = 1;
end
