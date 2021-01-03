function [ Ssol ] = assemble_S( data, d, nstresses )

    Se_func = ['Se' data.etype];
    
    Ssol = zeros(data.n_nodes,nstresses);
    count = zeros(data.n_nodes,1);
    
    for e=1:nelements
        locs = data.map(e,:);
        e_nodes = data.node (data.element(e,:),:);
        de = d(locs);
        Se = element.(Se_func)(e_nodes, data.material,de);
        
        node_locs = data.element(e,:);
        Ssol(node_locs,:) = Ssol(node_locs,:) + Se';
        count(node_locs) = count(node_locs)+1;
        
    end
    
    Ssol = Ssol./count;


end

