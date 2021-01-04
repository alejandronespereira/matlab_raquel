clear all;
close all;
clc;

%DATOS DEL PROBLEMA

%leemos la malla
data = GMSH.readMesh('P1_NOTUNEL.msh');

%a?adimos el material
data.material.e = 15e6; %Pa
data.material.nu = 0.3; %Poisson
data.material.k = 10e-4; %m/s
data.material.g = 9.81e3; %N/m3
data.material.peso_esp_sat = 19e3; %N/m3
data.material.peso_esp_ap = 17e3; %N/m3
data.etype='Quadrilateral9s_flujo';
data.material.type = 'PlaneStrain2D';

%% Escribimos la malla, sin datos, solo geometria
GMSH.writeMesh(data,'Resultados/Ap1.msh'); %contiene la malla no tiene resultados aun

%% Condiciones de contorno
cdc.altura_suelo_humedo = 30;
cdc.altura_suelo_impermeable = 25;
cdc.roca_impermeable = 0;
cdc.edificio = [10,20];
cdc.pared_izquierda = 0;
cdc.pared_derecha = 50;


%% Altura piezometrica
data.ndofn = 1; %gdl por nodo (para la altura piezometrica es 1)
data.map = fem.dofMap(data.element, data.ndofn);
fixed = funciones.get_fixed_cdc(data,cdc);
K=fem.assemble_K(data);
f=zeros(size(K,1),1);

h=fem.solveLS(K,f,fixed.dofs,fixed.values);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Altura Piezometrica',1,1,h);


% Presiones intersticiales
u=data.material.g*(h-data.node(:,2));
secos=find(data.node(:,2)>25);
u(secos)=0;
GMSH.writeNodalSolution('Resultados/Ap1.msh','Presiones Intersticiales',1,1,u);

%% Desplazamientos
data.ndofn = 2; %gdl por nodo (para los desplazamientos es 2)
data.map = fem.dofMap(data.element, data.ndofn);
data.etype = 'Quadrilateral_9'; %cuadrilatero cuadr?ticos
fixed = funciones.get_fixed_cdc(data,cdc);

K=fem.assemble_K(data);
f = fem.assemble_fb(data);

tic;
d = fem.solveLS(K,f,fixed.dofs,fixed.values);
toc;

dx = d(1:2:end);
dy = d(2:2:end);

GMSH.writeNodalSolution('Resultados/Ap1.msh','Desplazamientos Iniciales_X',1,1,dx);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Desplazamientos Iniciales_Y',1,1,dy);

%%Tensiones Totales
sigma =fem.assemble_S(data,d,3);


%%Tensiones Efectivas
[i,j]=find(u<=0);
u(i)=u(i).*0;
sigma.xx_efec=sigma.xx-u;
sigma.yy_efec=sigma.yy-u;

% Guardamos resultados
GMSH.writeNodalSolution('Resultados/Ap1.msh','Sxx efectivas',1,1,sigma.xx_efec);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Syy efectivas',1,1,sigma.yy_efec);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Sxx',1,1,sigma.xx);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Syy',1,1,sigma.yy);
GMSH.writeNodalSolution('Resultados/Ap1.msh','Tau xy',1,1,sigma.xy);

return;
