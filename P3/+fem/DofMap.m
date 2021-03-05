function [Map] = DofMap(element,ndofnode)

[ne,nne] = size(element);
Map = zeros(ne,nne*ndofnode);

for e=1:ne
    for i=1:nne
        ni = element(e,i);
        Map(e,ndofnode*(i-1)+1:ndofnode*(i-1)+ndofnode) = ndofnode*(ni-1)+1:ndofnode*(ni-1)+ndofnode;
    end
end
end