function writeGMSH(data,file_name)


gmsh = fopen([file_name '.msh'], 'w','n');
assert(gmsh>=0,'WriteGMSH', 'Error abriendo fichero'); %comprobación de que fopen ha funcionado
[ne,nne] = size(data.element); %data va a devolver dos valores, ne y nne
[nn,n_dim] = size(data.node); %igual que lo anterior

switch n_dim
    case 2
        switch nne
            case 2
                etype = 1;
            case 3
                etype = 2;
            case 4
                etype = 3;
            case 9
                etype = 10;
        end
        case 3
        switch nne
            case 2; etype = 1;
            case 4; etype = 4;
            case 9; etype = 10;
            otherwise
                error('Number of nodes!');
        end
end
%la instrucción switch hace que según el valor de n_dim ejecute unas
%instrucciones u otras

fprintf(gmsh, '$MeshFormat\n'); %pasar a línea siguiente se hace con \n
fprintf(gmsh, '2.2 0 8\n');
fprintf(gmsh, '$EndMeshFormat\n');

fprintf(gmsh, '$Nodes\n');
fprintf(gmsh, '%d \n', nn); %introducimos un carácter de sustitución %d para reescribir el contenido de una variable
coords = zeros(1,3);
for i = 1:nn
  coords(1:n_dim) = data.node(i,1:n_dim);
  fprintf(gmsh,' %d %f %f %f \n',i,coords);
end
fprintf(gmsh, '$EndNodes\n');

fprintf(gmsh, '$Elements\n');
fprintf(gmsh, ' %d \n', ne);

%etype=3; %por ahora estamos trabajando con el elemento triangular
n_tags=2; tag1=0; %la tag 1 es un 0 y la tag 2 es el número de elementos

for e = 1:ne
    fprintf(gmsh,' %d %d %d %d %d ', e, etype, n_tags, tag1, e); 
    for ne = 1:nne
        fprintf(gmsh, ' %d ', data.element(e,ne)); %sacamos la conectividad de esta forma para que sirva para cualquier tipo de elemento,
        %pues en principio no sabemos cuántos nodos va a tener nuestro
        %elemento
    end
      fprintf(gmsh, ' \n');
end
    fprintf(gmsh, '$EndElements\n');
    
fclose(gmsh);

end
