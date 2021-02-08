function ke=KeQuadrilateral9s_flujo(nodes,material)
%Matriz de rigidez del elemento cuadril?tero de 9 nodos (cuadr?tico)
%Aplicada al problema de flujo
ngp=9;
weight=[25 25 25 25 40 40 40 40 64]./81;
chi=[-1 1 1 -1 0 1 0 -1 0].*sqrt(0.6);
eta=[-1 -1 1 1 -1 0 1 0 0].*sqrt(0.6);

%MATRIZ CONSTITUTIVA D
%Material Props
k=material.k;   %Permeabilidad
D=k.*eye(2);

%N=@(chi,eta) [0.25*chi*(chi-1)*eta*(eta-1);
%              0.25*chi*(chi+1)*eta*(eta-1);
%              0.25*chi*(chi+1)*eta*(eta+1);
%              0.25*chi*(chi-1)*eta*(eta+1);
%              (1-chi^2)*0.5*eta*(eta-1);
%              0.5*chi*(chi+1)*(1-eta^2);
%              (1-chi^2)*0.5*eta*(eta+1);
%              0.5*chi*(chi-1)*(1-eta^2);
%              (1-chi^2)*(1-eta^2)];
%Lo de arriba lo usamos para copiar y pegar definiendo lo de abajo

dNchi=@(chi,eta) [0.25*(2*chi-1)*eta*(eta-1);
    0.25*(2*chi+1)*eta*(eta-1);
    0.25*(2*chi+1)*eta*(eta+1);
    0.25*(2*chi-1)*eta*(eta+1);
    (-chi)*eta*(eta-1);
    0.5*(2*chi+1)*(1-eta^2);
    (-chi)*eta*(eta+1);
    0.5*(2*chi-1)*(1-eta^2);
    (-2*chi)*(1-eta^2)];

dNeta=@(chi,eta) [0.25*chi*(chi-1)*(2*eta-1);
    0.25*chi*(chi+1)*(2*eta-1);
    0.25*chi*(chi+1)*(2*eta+1);
    0.25*chi*(chi-1)*(2*eta+1);
    (1-chi^2)*0.5*(2*eta-1);
    chi*(chi+1)*(-eta);
    (1-chi^2)*0.5*(2*eta+1);
    chi*(chi-1)*(-eta);
    (1-chi^2)*(-2*eta)];

%Jacobiano
xcoords=nodes(:,1);
ycoords=nodes(:,2);

J=@(chi,eta) [xcoords'*dNchi(chi,eta) ycoords'*dNchi(chi,eta);
    xcoords'*dNeta(chi,eta) ycoords'*dNeta(chi,eta)];

ke=zeros(9);

for j=1:ngp
    Jk=J(chi(j),eta(j));
    
    invJk=Jk\eye(2);
    dNk=invJk*[dNchi(chi(j),eta(j))';dNeta(chi(j),eta(j))'];
    
    Bk=zeros(2,9);
    Bk(1,1:9)=dNk(1,:);
    Bk(2,1:9)=dNk(2,:);
    
    dAk=det(Jk)*weight(j);
    ke=ke+(Bk'*D*Bk)*dAk;
end