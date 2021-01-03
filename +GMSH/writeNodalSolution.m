function writeNodalSolution(file_name,name,step,time,solution)

gmsh=fopen([file_name '.msh'],'a','n');
%gmsh = fopen(file_name,'a', 'n'); %pongo apend 'a' y 'n'
assert(gmsh>=0 ,'ERROR opening file');

[n_nodes,n_comp]=size(solution);

switch n_comp
    case {0,1}
        n_comp_out = 1;
    case {2,3}
        n_comp_out = 3;
    case {4,5,6,7,8,9}
        n_comp_out = 9;
    otherwise
        error('Wrong n_comp!!');
end

fprintf(gmsh,'$NodeData\n');
fprintf(gmsh,'1\n"%s"\n1\n%f\n',name,time);
fprintf(gmsh,'3\n%d\n%d\n%d\n',step,n_comp_out,n_nodes);

%temp=zeros(1,n_comp_out);

for i=1:n_nodes
    %temp(1:n_comp_out)=solution(i,:);
    
    fprintf(gmsh,'%d %e %e %e %e %e %e %e %e %e',i,solution(i,:));  %si defino temp, lo pongo aqui en el ultimo t?rmino
    fprintf(gmsh,'\n');
end

fprintf(gmsh,'$EndNodeData\n');

fclose(gmsh);