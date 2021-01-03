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
data.etype = 'Quadrilateral_9'; %cuadrilatero cuadr?ticos
data.material.type = 'PlaneStrain2D';

%% Escribimos la malla, sin datos, solo geometria
GMSH.writeMesh(data,'Resultados/Ap1.msh'); %contiene la malla no tiene resultados aun

%% Condiciones de contorno

data.cdc.altura_suelo_humedo = 30;
data.cdc.altura_suelo_impermeable = 25;
data.cdc.roca_impermeable = 0;

data.cdc.limite_derecho = 50;
data.cdc.limite_izquierdo = 0;

data.cdc.edificio = [10,20];

fixed_roca = find(data.node(:,2) == data.cdc.roca_impermeable); % Limite contra la roca
fixed_laterales = find(data.node(:,1) == data.cdc.limite_derecho | data.node(:,1) == data.cdc.limite_izquierdo); % Limites del problema hacia los lados
fixed_edificio = find(data.node(:,1) <= data.cdc.edificio(2) & data.node(:,1) >= data.cdc.edificio(1) & data.node(:,2) == data.cdc.altura_suelo_humedo);

fixed = [fixed_roca;fixed_laterales];

% Quitamos los elementos repetidos: 
% https://www.mathworks.com/matlabcentral/answers/16667-how-to-remove-repeating-elements-from-an-array
[b,m1,n1] =  unique(fixed,'first'); % b son los valores unicos, y se cumple 'b=fixed(m1)' y 'fixed = b(n1)'
[c1,d1] = sort(m1);

unique_fixed = b(d1);
unique_fixed_values = zeros(size(unique_fixed));

total_fixed = [unique_fixed;fixed_edificio];
total_fixed_values = [unique_fixed_values;-0.25 * ones(size(fixed_edificio))];

data.fixed.dofs = total_fixed;
data.fixed.values = total_fixed_values;

% Limpiamos variables auxiliares
clear fixed b m1 n1 c1 d1 fixed_roca fixed_laterales;

%% Altura piezometrica
##data.ndofn = 1; %gdl por nodo (para la altura piezometrica es 1)
##data.map = fem.dofMap(data.element, data.ndofn);
#### Necesario para la altura piezometrica
##data.material.type='PlainStrain2D';
##K=fem.assemble_K(data);
##f=zeros(size(K,1),1);
##
##h=fem.solveLS(K,f,data.fixed.dofs,data.fixed.values);
##GMSH.writeNodalSolution('Resultados/Ap1.msh','Altura Piezometrica',1,1,h);

% Presiones intersticiales
u=data.material.gamma_w*(h-data.node(:,2));
secos=find(data.node(:,2)>25);
u(secos)=0;
GMSH.writeNodalSolution('Resultados/Ap1.msh','Presiones Intersticiales',1,1,u);

%% Desplazamientos
data.ndofn = 2; %gdl por nodo (para los desplazamientos es 2)
data.map = fem.dofMap(data.element, data.ndofn);
K=fem.assemble_K(data);
f = fem.assemble_fb(data);

tic;
d = fem.solveLS(K,f,data.fixed.dofs,data.fixed.values);
toc;

dx = d(1:2:end);
dy = d(2:2:end);

GMSH.writeNodalSolution('Resultados/Ap1.msh','Desplazamientos Iniciales_X',1,1,dx);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Desplazamientos Iniciales_Y',1,1,dy);


%%Tensiones Totales
sigma=fem.assemble_S(data,d);

%%Tensiones Efectivas
[i,j]=find(u<=0);
u(i)=u(i).*0;
sigma.xx_efec=sigma.xx-u;%OJO SIGNOS
sigma.yy_efec=sigma.yy-u;


%Mallador
GMSH.writeNodalSolution2GMSH('pablomonleon','Sxx efectivas',1,1,sigma.xx_efec);
GMSH.writeNodalSolution2GMSH('pablomonleon','Syy efectivas',1,1,sigma.yy_efec);
GMSH.writeNodalSolution2GMSH('pablomonleon','Sxx',1,1,sigma.xx);
GMSH.writeNodalSolution2GMSH('pablomonleon','Syy',1,1,sigma.yy);
GMSH.writeNodalSolution2GMSH('pablomonleon','Tau xy',1,1,sigma.xy);

return;
