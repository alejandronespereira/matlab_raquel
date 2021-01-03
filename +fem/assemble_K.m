function [K] = assemble_K(data)

Ke_func = ['Ke' data.etype];

ndof = data.n_nodes * data.ndofn;

[n_elements,nndel] = size(data.element);

ndofel = nndel * data.ndofn;
nvalel = ndofel*ndofel;

Krow = zeros(nvalel*n_elements, 1);
Kcol = zeros(nvalel*n_elements, 1);
Kval = zeros(nvalel*n_elements, 1);

counter = 0;

for e = 1:n_elements
  
   edofs = data.map(e,:);
   
   e_nodes = data.node( data.element(e,:), : );
   
   Ke = element.(Ke_func)(e_nodes,data.material);
   
   Krow(counter+1:counter+nvalel) = repmat(edofs,1,length(edofs));
   Kcol(counter+1:counter+nvalel) = repelem(edofs,length(edofs));
   Kval(counter+1:counter+nvalel) = Ke(:);
   
   counter = counter + nvalel;
end

K = sparse(Krow,Kcol,Kval,ndof,ndof);

end

