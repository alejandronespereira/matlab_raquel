function [ data ] = readMesh ( file_name )
  gmsh = fopen(file_name,('r'));
  assert(gmsh>=0,'Error opening file');   %Si el fichero no existe, devolver error

  %Leer 9 primeras lineas
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);
  fline = fgetl(gmsh);

  temp = fscanf( gmsh,'%d',[1]);
  
  data.n_nodes = temp;
  data.nne =9; %cuadratico y cuadrilatero
  data.n_dim =3; % Son 3 dimensiones, ya que z siempre es 0 
      
  fline = fgetl(gmsh);
  
  temp = fscanf(gmsh,'%f %f %f %f \n',[1+data.n_dim data.n_nodes]);
  %Nodos, solo cogemos las coordenadas x e y 
  data.node = temp(2:3,:)';
      
  %Leer
  fline = fgetl( gmsh ); %$EndNodes
  fline = fgetl( gmsh ); %$Elements
  n_elements = fscanf(gmsh,'%d',[1]);
  
  data.n_elements = n_elements;
  
  temp=fscanf(gmsh,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d',[5+data.nne data.n_elements]);
  data.etype=temp(2,1);
  data.element=temp(6:end,:)';
  data.material.element=temp(4,:)';

  fclose(gmsh);
end