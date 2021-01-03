function [Se] = SeQuadrilateral_9(nodes, material, de)

ngp=9;

weight=[25 25 25 25 40 40 40 40 64]./81;
chi=[-1 1 1 -1 0 1 0 -1 0].*sqrt(0.6);
eta=[-1 -1 1 1 -1 0 1 0  0].*sqrt(0.6);

%Material
e = material.e;
nu = material.nu;

switch material.type
    case 'PlaneStrain2D' %Tension plana
    D = e/(1+nu)/(1-2*nu)*[1-nu nu 0;
                           nu 1-nu 0;
                           0 0 ((1-2*nu)/2)]; % transparencias de la matriz custitutiva de tension plana y def plana
    case 'PlaneStress2D'  %Def plana
        D = e/(1-nu^2)*[1 nu 0;
                        nu 1 0;
                        0 0 (1-nu)/2];
    otherwise
        error ('Unknown material type')
end

%FUNCIONES DE FORMA
N=@(chi,eta) [0.25*chi*(chi-1)*eta*(eta-1);
    0.25*chi*(chi+1)*eta*(eta-1);
    0.25*chi*(chi+1)*eta*(eta+1);
    0.25*chi*(chi-1)*eta*(eta+1);
    (1-chi^2)*0.5*eta*(eta-1);
    0.5*chi*(chi+1)*(1-eta^2);
    (1-chi^2)*0.5*eta*(eta+1);
    0.5*chi*(chi-1)*(1-eta^2);
    (1-chi^2)*(1-eta^2)];

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

%JACOBIANO

xcoords = node(:,1); ycoords = node(:,2);

Je = @(chi,eta) [xcoords'*dNchi(eta) ydoords'*dNchi(eta);
    xcoords'*dNeta(chi) ycoords'*dNeta(chi)];

Se = zeros(9,3);  %3 componentes de tensi?n para cada nodo (9)

for k=1:ngp
    Jk=Je(chi(k),eta(k));
    dNk=inv(Jk)*[dNchi(eta(k))';dNeta(chi(k))'];
    %dNk = inv(Jk)*[dNchi(chi(k), eta(k))'; dNeta(chi(k), eta(k))'];
    
    Bk=zeros(3,18);
    Bk(1,1:2:18)= dNk(1,:);
    Bk(2,2:2:18)= dNk(2,:);
    Bk(3,1:2:18)= dNk(2,:);
    Bk(3,2:2:18)= dNk(1,:);
    
    Sk=(D*Bk)*de;
    
for i = 1:9
        Se = Se + N(chi_n(i),eta_n(i))*Sk';
 end
end