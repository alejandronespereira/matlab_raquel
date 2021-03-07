function [ q ] = assemble_q( data)

n= data.ndof*data.n_nodes;

% Fuerzas, hay 3 fuerzas negativas en z en los 3 ultimos nodos:
q = zeros(data.n_nodes * data.ndof,1);

F = -1000;

%F = F * factor;
% El nodo 8 se lleva la fuerza F
q(3 * (8-1) + 3) = F;
% Los nodos 7 y 9 1.5 veces F
q(3 * (7-1) + 3) = 1.5* F;
q(3 * (9-1) + 3) = 1.5* F;

end