function [ new_elementstate ] = SeBar3D(material, nodes, inc_de, last_elementstate)

if (nargin==1)
   new_elementstate.state(1) = Material.ElastoPlastico_1D(material);
   return
end

%Longitud de las barras
LONG = norm(nodes(2,:)-nodes(1,:));

B = (1/LONG)*[-1 1];
 
%Matriz de rotación 2x6
L = (nodes(2,1)-nodes(1,1))/LONG;
M = (nodes(2,2)-nodes(1,2))/LONG;
N = (nodes(2,3)-nodes(1,3))/LONG;
T = [L M N 0 0 0; 0 0 0 L M N];

deps = B*T*inc_de; 
new_elementstate.state(1) = Material.ElastoPlastico_1D(material,deps,last_elementstate.state(1));
end