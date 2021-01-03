function [obj] = readMesh( file_name , nne, ndim )

% open file
gmsh = fopen(file_name,'r');
assert(gmsh>=0 ,'ERROR opening file');

switch ndim
  case (2) %2D
    switch nne
      case 2
        etype = 1;
      case 3
        etype = 2;
      case 4
        etype = 3;
      case 9
        etype =10;
      otherwise
        error('Unknown 2D element');
    end
  case (3) %3D
    switch nne
      case 2
        etype = 1;
      case 3
        etype = 2;
      case 4
        etype = 4;
      case 8
        etype = 5;
      case 9
        etype = 10;
      otherwise
        error('Unknown 3D element');
    end
  otherwise
    error('NDIM wrong value');
end

while(not(strcmp(fgetl(gmsh),'$Nodes')))
  if feof(gmsh)
    error('$Nodes not found');
  end
end

obj.n_nodes = fscanf(gmsh,'%d',1);

aux = fscanf(gmsh,'%g',[4 obj.n_nodes]); %la dimensi?n es de 4 columnas por el numero de nodos almacenado en obj.nnodes
obj.node = aux(2:1+ndim,:)'; %matriz que contiene las coordenadas nodales
%obj.node = aux(:,2:end); %todas las filas y desde la segunda columna al final

%Leemos los elementos
while(not(strcmp(fgetl(gmsh),'$Elements')))
  if feof(gmsh)
    error('$Elements not found');
  end
end

obj.n_elements = fscanf(gmsh,'%d',1);

aux = fscanf(gmsh,'%d',inf); %vector auxiliar infinito hasta que llegue a un no entero

ELE_INFOS = zeros(obj.n_elements,4); %informacion de los elementos (3 primeras columnas)
ELE_TAGS = zeros(obj.n_elements,3); %tags (siguientes2)
ELE_NODES = zeros(obj.n_elements,nne); %conectividad (4 ssiguientes)

start = 1;
for e=1:obj.n_elements
  finish = start + 2; % el final es start mas dos enteros (tres primeras columnas)
  ELE_INFOS(e,1:3) = aux(start:finish); %lo guardo en ELE_INFOS para la fila e, leo desde la 1 a la 3 columna, las leo de aux empezando desde start hasta finish
  ntags = aux(finish); % en este caso ntags son 2 pordian ser mas
  start = finish + 1; %empiezo donde acab? antes
  finish = start + ntags -1; %el nuevo finish 
  ELE_TAGS(e,1:ntags) = aux(start:finish); 
  start = finish + 1;
  finish = start + nne -1;
  ELE_NODES(e,1:nne) = aux(start:finish);
  start = finish + 1;
  
  assert(ELE_INFOS(e,2) == etype, 'Wrong elment type');
  
end

obj.element = ELE_NODES(:,1:nne);
obj.material.element = ELE_TAGS(:,1); %Para leer si el material est? seco o mojado


obj.n_dim = ndim;
obj.nne = nne;

fclose(gmsh);
end