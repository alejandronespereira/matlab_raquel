function [map] = dofMap(connectivity,ndofn)

[ne, nne] = size(connectivity);

map = zeros(ne,nne*ndofn);

for e=1:ne
   
    for i=1:nne
       ni = connectivity(e,i);
       
       map(e,ndofn*(i-1)+1:ndofn*(i-1)+ndofn) = ...
           ndofn*(ni-1)+1:ndofn*(ni-1)+ndofn;
        
    end
    
end


end

