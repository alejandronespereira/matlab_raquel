function [ pe ] = PeBar3D( material, nodes,  element_state)

%Longitud de las barras
LONG = norm(nodes(2,:)-nodes(1,:));

L = (nodes(2,1)-nodes(1,1))/LONG;
M = (nodes(2,2)-nodes(1,2))/LONG;
N = (nodes(2,3)-nodes(1,3))/LONG;

B = (1/LONG)*[-1 1]*[L M N 0 0 0; 0 0 0 L M N];

Ve = material.A * LONG;

gp_state = element_state.state(1);

pe = B' * gp_state.stress * Ve;

end