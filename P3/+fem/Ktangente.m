% Montaje de la matriz de rigidez tangente
function [K] = Ktangente (u,MEF_data)
% Dimensiones
nnodos=size(MEF_data.nodes,1);
nelementos=size(MEF_data.element,1);
ndofnd = MEF_data.ndof;
ndof=ndofnd*nnodos;
K=zeros(ndof);
for e=1:nelementos
  % nodos del elemento
  i=MEF_data.element(e,1);
  j=MEF_data.element(e,2);
  % posici�n de los dof
  egdls = MEF_data.map(e,:);
  % coordenadas nodales iniciales del elemento
  Xe0=[MEF_data.nodes(i,:)
    MEF_data.nodes(j,:)];
  % coordenadas nodales finales del elemento
  Ue=u(egdls);
  Uem=[Ue(1) Ue(2) Ue(3)
    Ue(4) Ue(5) Ue(6)];
  Xe1=Xe0+Uem;
  % propiedad material del elemento
  prop=MEF_data.material.element(e);
  
  % matriz de rigidez del elemento
  ke=Elements.keBar(Xe0,Xe1,prop);
  
  % ensamblaje en la matriz global
  K(egdls,egdls) = K(egdls,egdls) + ke;
end


