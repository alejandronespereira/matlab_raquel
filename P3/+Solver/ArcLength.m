%
% Funcion Arclength para el desarrollo del estado de cargas desplazamientos
% no lineal, considerando puntos criticos y puntos de retorno
%
% Se realiza a partir de control hiperesferico
%

function [delta_d_k,delta_lambda_k,data]= ArcLength (d_n, lambda_n,data)


d=d_n;

%%%%%%
kmax=data.kmax;
epsilon=data.epsilon;
l=data.l;
psi=data.psi;
%%%%%%
q=data.q;
%%%%%%

%fext=lambda_n.*q;

% state_k=FEM.updateState(data);

Kt = FEM.Ktangente(d,data);

vn=FEM.solveLS(Kt,q,data.fixed.dofs,data.fixed.values);
%p=FEM.assemble_p(data); %residuo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Para implementar el criterio del trabajo positivo
criterio1=(q'*vn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Para implementar el criterio del ángulo
criterio2=(data.prev.lambda_o+vn'*data.prev.d_o);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% La comprobación pasaba por establecer el criterio del trabajo positivo
% incialmente hasta el punto límite y después en el punto de retroceso con
% el del ángulo, a la hora de implementarlo, no se ha conseguido pasar el
% punto de bifurcación existente que hay en el mismo punto que el punto
% límite

if criterio1>=0
    signo = 1;
else
    signo = -1;
end


delta_lambda_o=signo*(l)/sqrt(vn'*vn + psi^2*q'*q); %El signo se elige en función de los criterios estudiados




delta_d_o=delta_lambda_o*vn;

    data.prev.lambda_o=delta_lambda_o;
    data.prev.d_o=delta_d_o;

d_n_k=d_n+delta_d_o;

lambda_n_k=lambda_n+delta_lambda_o;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p = FEM.Ensamblaje_P(data,state_k);

p = FEM.pint(d_n_k,data);

r_k_v = p - lambda_n_k*q;

r_k_v(data.fixed.dofs) = 0.0;

r_o=norm(r_k_v);

r_k=r_o;



c_n_k=0;

%c_n_k=zeros(data.n_nodes*data.ndofn,1);

delta_d_k = delta_d_o;

delta_lambda_k= delta_lambda_o;

k=1;


while (k<=kmax && (r_k/r_o>=epsilon))
    
    fprintf('Iteración: %3d  \n',k);
    
    Kt = FEM.Ktangente(d_n_k,data);
    
    y= FEM.solveLS(Kt,q,data.fixed.dofs,data.fixed.values);
    
    x= FEM.solveLS(Kt,r_k_v,data.fixed.dofs,data.fixed.values);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Parada 1 %%%%%
    eta_k= (-c_n_k + 2*(delta_d_k)'*x)/(2*delta_d_k'*y + 2*delta_lambda_k*psi^2*q'*q);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    d_n1_k=x+eta_k*y;                      %%% Parada 2 %%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    delta_d_k=delta_d_k+d_n1_k;                %sale un vector

    %%% Parada 3 %%%%%
    delta_lambda_k=delta_lambda_k + eta_k;     %sale un escalar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    c_n_k=delta_d_k'*delta_d_k + delta_lambda_k^2*psi^2*q'*q - l^2;
    
    
    d_n_k=d_n_k + d_n1_k;
    
    lambda_n_k=lambda_n_k+eta_k;
    
    p = FEM.pint(d_n_k,data);
    
    r_k_v= p - lambda_n_k*q;
    
    r_k_v(data.fixed.dofs) = 0.0;
    
    r_k=norm(r_k_v);
    
    k=k+1;
    
end



end
