function [fb] = assemble_fb(data)

be_func = ['be' data.etype];

ndof = data.n_nodes * data.ndofn;

fb = zeros(ndof,1);

for e = 1:data.n_elements
  
  locs = data.map(e,:);
  
  e_nodes = data.node(data.element(e,:),:);
  
 if data.material.element(e)==1
         data.body = [0; -data.material.peso_esp_sat];
 else
         data.body = [0; -data.material.peso_esp_ap];
     end
  
  fbe = element.(be_func)(e_nodes,data.body);
  
  fb(locs) = fb(locs) + fbe;
  
end

end

