% Evalua el vector de fuerzas internas p(u)
function [p] = pint (u,MEF_data)
% Dimensiones
nnodos=size(MEF_data.nodes,1);
nelementos=size(MEF_data.element,1);
ndofnd = MEF_data.ndof;
ndof=ndofnd*nnodos;
p=zeros(ndof,1);
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
  
  % fuerzas internas del elemento
  pe=Elements.peBar(Xe0,Xe1,prop);
  
  % se ensambla en el vector general
  p(egdls)=p(egdls)+pe;
end


