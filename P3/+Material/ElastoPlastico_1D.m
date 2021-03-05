function [ new_state ] = ElastoPlastico_1D(material, deps, prev_state)

% E = material.E;
% Et = material.Et;
% sigmaY0 = material.sigmaY0;  %Limite elastico inicial
% H = (E*Et)/(E-Et);

if(nargin==1) %Si solo hay un argumento me devuelve un estado nulo
   new_state.stress = 0;
   new_state.strain_elastico = 0;
%    new_state.strain_plastico = 0;
%    new_state.D = E;
   return
end

sigmatr = prev_state.stress + E * deps;
sigmaYn = sigmaY0 + prev_state.strain_plastico * H;
ftr = abs(sigmatr) - (sigmaYn);

if ftr<0 %Elastico
   new_state.strain_elastico = prev_state.strain_elastico + deps; 
   new_state.strain_plastico = prev_state.strain_plastico;
   new_state.stress = sigmatr;
   new_state.D = E;
   return
else
   deps_n = ftr/(E+H);
   new_state.strain_elastico = prev_state.strain_elastico+(deps-deps_n);
   new_state.strain_plastico = prev_state.strain_plastico+deps_n;
   new_state.stress = sigmatr-sign(sigmatr)*E*deps_n;
   new_state.D = Et;
   return
end

end