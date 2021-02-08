function writeNodalSolutionGMSH(file_name, name, step, time, solution)
gmsh = fopen(file_name, 'a');
assert(gmsh>=0, 'Error opening file');

[nn, n_comp] = size(solution);

fprintf(gmsh,'$NodeData\n');
fprintf(gmsh,'1\n"%s"\n 1\n %f\n',name,time);
fprintf(gmsh,'3\n%d\n%d\n%d\n',step,n_comp, nn);

temp = zeros(1,n_comp);

for n = 1:nn
    temp(1:n_comp) = solution(n,:);
    
    fprintf(gmsh, '%d %e %e %e %e %e %e %e %e %e', n, temp);
    fprintf(gmsh, '\n');
    
end

fprintf(gmsh,'$EndNodeData\n');
fclose(gmsh);