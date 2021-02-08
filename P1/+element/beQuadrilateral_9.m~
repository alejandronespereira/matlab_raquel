function [be ] = beQuadrilateral_9( node, b )

ngp=9;

weight=[25 25 25 25 40 40 40 40 64]./81;
chi=[-1 1 1 -1 0 1 0 -1 0].*sqrt(0.6);
eta=[-1 -1 1 1 -1 0 1 0 0].*sqrt(0.6);


%Material
% e = material.e;
% nu = material.nu;

% switch material.type
%     case 'PlaneStrain2D' %Tension plana
%     D = e/(1+nu)/(1-2*nu)*[1-nu nu 0;
%                            nu 1-nu 0;
%                            0 0 ((1-2*nu)/2)]; % transparencias de la matriz custitutiva de tension plana y def plana
%     case 'PlaneStress2D'  %Def plana
%         D = e/(1-nu^2)*[1 nu 0;
%                         nu 1 0;
%                         0 0 (1-nu)/2];
%     otherwise
%         error ('Unknown material type')
% end

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

 Je=@(chi,eta) [xcoords'*dNchi(chi,eta) ycoords'*dNchi(chi,eta);
    xcoords'*dNeta(chi,eta) ycoords'*dNeta(chi,eta)];    


be = zeros(18,1);

for k=1:ngp %Bucle para los gp
    
    Jk = Je(chi(k),eta(k)); %Evaluamos el Jacobiano
    dNk = inv(Jk)*[dNchi(chi(k), eta(k))'; dNeta(chi(k), eta(k))'];
    
    %Construcci?n de Nk
    Nk = zeros(2,18);
    Nik = N(chi(k),eta(k)); %vector evaluado en el punto k esimo
    
    Nk(1,1:2:18) = Nik';
    Nk(2,2:2:18) = Nik;

%Diferencial de ?rea    
dAk = det(Jk)*weight(k);

be = be + (Nk'*b)*dAk;

% %Vector b
% if data.material.status == 1 %terreno saturado
%     be = be+(Nk'*data.material.body')*dAk;
% else %aplicamos peso espec?fico aparente
%     be = be + (Nk'*data.material.body_ap)*dAk;
% end

end


            
end

