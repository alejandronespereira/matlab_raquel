##clear all;
##clc;

load('structure','structure');
load('data','data');

P = zeros(1,36);

K_sistema = funciones.computeSystemK(structure,data.material,P);
disp(K_sistema);