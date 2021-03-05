function [ Ke ] = KeBar3D(data,nodes,element_state)

material = data.material;

%Extracción de las componentes de los nodos para la matriz de rotación que pasa a ejes globales
xi = nodes(1,1);
xj = nodes(2,1);
yi = nodes(1,2);
yj = nodes(2,2);
zi = nodes(1,3);
zj = nodes(2,3);

%Hallar longitud de la barra
L=norm(nodes(2,:)-nodes(1,:));

%Cosenos directores
l = (xj-xi)/L;
m = (yj-yi)/L;
n = (zj-zi)/L;

EA = material.EA;

gp_state = element_state.state(1);

%Contrucción de rotación R
R = [l^2 l*m l*n -l^2 -l*m -l*n;
     l*m m^2 m*n -l*m -m^2 -m*n;
     l*n m*n n^2 -l*n -m*n -n^2;
    -l^2 -l*m -l*n l^2 l*m l*n;
    -l*m -m^2 -m*n l*m m^2 m*n;
    -l*n -m*n -n^2 l*n m*n n^2;];   
                    
Ke =(EA/L)*R;
% Ke =(A*gp_state.D/L)*R;
end