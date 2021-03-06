function [ solution ] = solveLS( K,f, fixed_dofs,fixed_values )

f=f-K(:,fixed_dofs)*fixed_values; %
alpha = mean(diag(K)); %Calculo alfa
f(fixed_dofs) = alpha*fixed_values; %Multiplico alfa por los desplazamientos restringidos
K(fixed_dofs,:)=0; K(:,fixed_dofs)=0;  %Borro las columnas correspondientes a los gdl conocidos, luego borro las filas
K(fixed_dofs, fixed_dofs) = alpha*speye(length(fixed_dofs)); %Por si la matriz K es sparse
solution = K\f;  %Resoluci?n del sistema utilizando la barra, que use el sistema que mejor considere Matlab


end

