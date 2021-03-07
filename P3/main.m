
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
data.step_criterio = 200;


%% Dibujar estructura 

    
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

data.q = fem.assemble_q(data);

% Hacemos una ejecucion solo con el criterio del trabajo positivo
% assemble_q ya sabe que elementos tienen que fuerza y solo necesita la magnitud
[d_pos,lambda_pos] = Solver.arclength_solver(data);

% Hacemos otra ejecucion en el que a partir del paso 40 usamos el criterio del angulo
% 40 elegido empiricamente a ensayo y error
data.step_criterio = 40;
[d_angulo,lambda_angulo] = Solver.arclength_solver(data);

% Para de dibujar graficas
f = fem.dibujar(data,lambda_pos,d_pos,lambda_angulo,d_angulo);

