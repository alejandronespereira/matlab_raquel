function [ Be ] = BeBar3D(material,nodes)

LONG = norm((nodes(2,:))-(nodes(1,:)));

Ve = material.A*LONG;

Be = [0; 0; (-material.rho*9.81*Ve)/2; 0; 0; (-material.rho*9.81*Ve)/2];

end