clear all;
close all;
clc;

%DATOS DEL PROBLEMA


%leemos la malla
data = GMSH.readMesh('P1.msh');

%a?adimos el material
data.material.e = 15e6; %Pa
data.material.nu = 0.3; %Poisson
data.material.k = 10e-4; %m/s
data.material.g = 9.81e3; %N/m3
data.material.peso_esp_sat = 19e3; %N/m3
data.material.peso_esp_ap = 17e3; %N/m3

data.ndofn = 2; %gdl por nodo (para los desplazamientos es 2)
data.etype = 'Quadrilateral_9'; %cuadrilatero cuadr?ticos
data.material.type = 'PlaneStrain2D';

% Generamos el mapa para la conectividad de elementos
data.map = fem.dofMap(data.element, data.ndofn);

%% 1. DESPLAZAMIENTOS VERTICALES EN EL TERRENO

data.cdc.altura_suelo_humedo = 30;
data.cdc.altura_suelo_impermeable = 25;
data.cdc.roca_impermeable = 0;

data.cdc.limite_derecho = 50;
data.cdc.limite_izquierdo = 0;

fixed_roca = find(data.node(:,2) == data.cdc.roca_impermeable); % Limite contra la roca
fixed_laterales = find(data.node(:,1) == data.cdc.limite_derecho | data.node(:,1) == data.cdc.limite_izquierdo); % Limites del problema hacia los lados

fixed = [fixed_roca;fixed_laterales];

% Quitamos los elementos repetidos: 
% https://www.mathworks.com/matlabcentral/answers/16667-how-to-remove-repeating-elements-from-an-array
[b,m1,n1] =  unique(fixed,'first'); % b son los valores unicos, y se cumple 'b=fixed(m1)' y 'fixed = b(n1)'
[c1,d1] = sort(m1);

data.fixed.dofs = b(d1);
data.fixed.values = zeros(size(data.fixed.dofs));
% Limpiamos variables auxiliares
clear fixed b m1 n1 c1 d1 fixed_roca fixed_laterales;

%Calculo de la matriz de rigidez
K = fem.assemble_K(data);
f = fem.assemble_fb(data);

tic;
d = fem.solveLS(K,f,data.fixed.dofs,data.fixed.values);
toc;

dx = d(1:2:end);
dy = d(2:2:end);

GMSH.writeMesh(data,'Resultados/Ap1.pos.msh'); %contiene la malla no tiene resultados aun
GMSH.writeNodalSolution('Resultados/Ap1.pos.msh','Desplazamientos Iniciales_X',1,1,dx);
GMSH.writeNodalSolution('Resultados/Ap1.pos.msh','Desplazamientos Iniciales_Y',1,1,dy);
return;
