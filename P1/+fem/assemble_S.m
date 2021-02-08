function [ sigma ] = assemble_S( data, d, nstresses )

    Se_func = ['Se' data.etype];
    
    Ssol = zeros(data.n_nodes,nstresses);
    count = zeros(data.n_nodes,1);
    
    [n_elements,nndel] = size(data.element);

    for e=1:n_elements
        locs = data.map(e,:);
        e_nodes = data.node (data.element(e,:),:);
        de = d(locs);
        Se = element.(Se_func)(e_nodes, data.material,de);
        
        node_locs = data.element(e,:);
        Ssol(node_locs,:) = Ssol(node_locs,:) + Se;
        count(node_locs) = count(node_locs)+1;
        
    end
    
    Ssol = Ssol./count;
    sigma.xx = Ssol(:,1)./count;
    sigma.yy = Ssol(:,2)./count;
    sigma.xy = Ssol(:,3)./count;
end

