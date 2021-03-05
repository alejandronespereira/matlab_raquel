
clearvars
close all
clear all
clc

% Generamos la estructura

data.etype='Bar3D';

x1 = 1.697;

data.nodes = [-x1 -1 0
                0 -1 0
               x1 -1 0
              -x1  1 0
                0  1 0
               x1  1 0
              -x1  0 1
                0  0 1
               x1  0 1];

% Matriz de conectividad. El elemento 1 une los nodos 1 y 7               
data.element = [1,7;
                1,8;
                2,8;
                3,8;
                3,9;
                4,7;
                4,8;
                5,8;
                6,8;
                6,9;
                7,8;
                8,9];

     
%%  Planteamiento del problema

data.ndof=3; % x y z
data.n_elements=size(data.element,1);
data.n_nodes=size(data.nodes,1);             
[data.map] = fem.DofMap(data.element,data.ndof);
        
% Material
data.material.EA = 5e4;
data.material.element= data.material.EA * ones(data.n_elements,1);

%% Carga
% Segun enunciado
data.kmax=100;
data.epsilon=1e-5;
data.psi = 0;
data.l = 0.1;
data.n_steps = 200;


%% Dibujar estructura 

 ne = size(data.element,1);
 nn = size(data.nodes,1);

    
% Especificamos los nodos fijos sin grado de libertad, todos los que estan en el suelo (z == 0)
fixed_nodes = find(data.nodes(:,3) == 0);
data.fixed.nodes = zeros(size(fixed_nodes));

% Como hay 3 grados de libertad, son 3 fixed por cada nodo. Los nodos fijos son los del 1 al 6 por lo que  del 1 al 18
for i = 1:length(fixed_nodes)
  for j = 1:data.ndof
    data.fixed.nodes(data.ndof * (i-1) + j) = (fixed_nodes(i) - 1) * data.ndof + j;
  end
end

data.fixed.values = zeros(size(data.fixed.nodes));

% assemble_q ya sabe que elementos tienen que fuerza y solo necesita la magnitud
data.q = fem.assemble_q(data);

[d,lambda] = Solver.arclength_solver(data);

% Hora de dibujar graficas

subplot(2,2,1);

scatter3(data.nodes(:,1),data.nodes(:,2),data.nodes(:,3),'filled','MarkerEdgeColor','k',...
        'MarkerFaceColor','k') %dibuja circulos
axis equal; hold on;

 for e=1:ne
   n1 = data.element(e,1);
   n2 = data.element(e,2); 
   x1 = data.nodes(n1,1); x2 = data.nodes(n2,1);
   y1 = data.nodes(n1,2); y2 = data.nodes(n2,2);
   z1 = data.nodes(n1,3); z2 = data.nodes(n2,3);
   
   line([x1,x2],[y1,y2],[z1,z2],'Color','k');
 end
 %% 45 azimuth 30 elevacion
 view(45,30);

% Fuerza horizontal en el nodo 7
u = d(:,(7-1) *3 +1);
% Fuerza vertical en el nodo 7
v = d(:,(7-1) *3 +3);
% Fuerza vertical en el nodo 8
w = d(:,(8-1) *3 +3);

subplot(2,2,2);
plot(w,lambda/data.material.EA);
subplot(2,2,3);
plot(v,lambda/data.material.EA);
subplot(2,2,4);
plot(w,v);


