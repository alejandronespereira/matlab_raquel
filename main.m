clear all;
close all;
clc;

%DATOS DEL PROBLEMA


%leemos la malla
data = GMSH.readMesh('P1_NOTUNEL.msh',9,2);

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

GMSH.writeMesh(data,'Ap1.pos.msh'); %contiene la malla no tiene resultados aun
GMSH.writeNodalSolution('Ap1.pos.msh','Desplazamientos Iniciales_X',1,1,dx);
GMSH.writeNodalSolution('Ap1.pos.msh','Desplazamientos Iniciales_Y',1,1,dy);
return;

% CDC
% data.cdc=[30, 25];
% 
% fixed_terreno = find(abs(data.node(:,2)==data.cdc(1)) & (data.node(:,1)<=50));
% fixed_NF = find(abs(data.node(:,2)==data.cdc(2)) & (data.node(:,1)<=50));
% data.fixed_dofs = [fixed_terreno];
% data.fixed_values = [0*ones(length(fixed_terreno),1);];

data.fixed_edificio = find(abs(data.node(:,2)==30) & (data.node(:,1)<=20| data.node(:,1)>=10));
data.fixed_lado = find(abs(data.node(:,2)==30 & (data.node(:,1)<=50 | data.node(:,1)>=0)));
data.fixed_base = find(abs(data.node(:,2)==0 & (data.node(:,1)>=0 | data.node(:,1)<=50)));

data.fixed_dofs = [data.fixed_edificio; data.fixed_lado; data.fixed_base];
%data.fixed_values = zeros(size(data.fixed_dofs));
data.fixed_values = [0.25*ones(length(data.fixed_edificio),1); 0*ones(length(data.fixed_lado),1); 0*ones(length(data.fixed_base),1)];


 %fijo las posiciones de esos nodos fijos (vectores columnas)
 %dofs_fixed_X = (nodes_fixed-1)*data.ndofn +1; 
 %dofs_fixed_Y = (nodes_fixed-1)*data.ndofn +2;
 %dofs_fixed_Z = (nodes_fixed-1)*data.ndofn +3;
%GDL fijos ( ordeno los vectores columna)
 %dofs_fixed = [ dofs_fixed_X; dofs_fixed_Y;dofs_fixed_Z];
 
 %Nodos que no estan en la base de la presa
 %dofs_values = zeros(size(dofs_fixed));
 
%Desplazamientos
tic;
dini=fem.solveLS(K,f,data.fixed_dofs,data.fixed_values);
toc;

dini_y=dini(2:2:end);
solution = reshape (dini_y, [1 data.n_nodes])';

GMSH.writeMesh(data,'Ap1.pos'); %contiene la malla no tiene resultados aun
GMSH.writeNodalSolution('Ap1.pos','Desplazamientos Iniciales',1,1,dini);


%GMSH.writeMesh(data,'desp_ini');
%GMSH.writeNodalSolutionGMSH('desp_ini','desplazamientos',1,1,dini);
%toc;
% %% TENSIONES EFECTIVAS
% %Calculamos las tensiones
% Ssol= fem.assemble_S(data, d, 3);
% data.n_nodes = size(data.n_ode,1);
% solution = reshape( d , [data.ndofn; data.n_nodes ]' ); %Se obtiene del vector d y la tengo que convertir en una matriz con reshape para cambiar sus dimensiones
% %Eliminamos los valores menores que 0
% for i=1:data.n_nodes
%        if solution(i)<0;
%           solution(i)=0;
%        end
% end
% %Seleccionamos las tensiones Sigma XX, Sigma YY y Tau XY
% Sxx=Ssol(:,1);
% Syy=Ssol(:,2);
% Sxy=Ssol(:,3);
% 
% %Calculamos las tensiones efectivas rest?ndoles las presiones
% %intersticiales obtenidas en el apartado anterior
% 
% Sigmaxx_ef=-Sxx-U;
% Tauxy_ef=-Sxy;
% Sigmayy_ef=-Syy-U;
% 
% %Generamos en GMSH la malla y representamos las tensiones efectivas
% %GMSH.writeMesh(data,'Ap1'); %contiene la malla no tiene resultados aun
% %GMSH.writeNodalSolutionGMSH('Ap1','Displacements',1,1,solution); %1time 1 step
% %GMSH.writeNodalSolution('presa.pos','Stresses',1,1,Ssol);
% 
% GMESH.writeGMSH(data,'Tensiones_Efectivas')
% GMESH.writeNodalSolutionGMSH('Tensiones_Efectivas','Sigma efectiva XX',1,1,Sigmaxx_ef)
% GMESH.writeNodalSolutionGMSH('Tensiones_Efectivas','Sigma efectiva YY',1,1,Sigmayy_ef)
% GMESH.writeNodalSolutionGMSH('Tensiones_Efectivas','Tau efectiva XY',1,1,Tauxy_ef) 
