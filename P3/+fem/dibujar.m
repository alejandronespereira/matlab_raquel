function f = dibujar(data,lambda_pos,d_pos,lambda_angulo,d_angulo)
  
  f = figure('Name','Estudio de la estructura');
  
  scatter3(data.nodes(:,1),data.nodes(:,2),data.nodes(:,3),'filled','MarkerEdgeColor','k',...
          'MarkerFaceColor','k') %dibuja circulos
  axis equal; hold on;

  
   ne = size(data.element,1);
   nn = size(data.nodes,1);

   %% 45 azimuth 30 elevacion
   
   %Repetimos el proceso para la estructura desplazada tras aplicar las fuerzas
   
   displaced_nodes = data.nodes;
   % La posicion x nueva es la antigua mas los desplazamientos en x. Recordamos 
   % los desplazamientos en d estan estructurados como x1 y1 z1 x2 y2 z2..., y 
   % cada fila es un paso del algoritmo, asi que queremos la ultima
   
   dx = d_angulo(data.n_steps,1:3:data.ndof * nn)';
   dy = d_angulo(data.n_steps,2:3:data.ndof * nn)';
   dz = d_angulo(data.n_steps,3:3:data.ndof * nn)';
   
   displaced_nodes(:,1) += dx;
   displaced_nodes(:,2) += dy;
   displaced_nodes(:,3) += dz;
  
  scatter3(displaced_nodes(:,1),displaced_nodes(:,2),displaced_nodes(:,3),'filled','MarkerEdgeColor','k',...
          'MarkerFaceColor','b') %dibuja circulos
          
   % Dibujamos las lineas entre nodos       
   for e=1:ne
     n1 = data.element(e,1);
     n2 = data.element(e,2); 
     x1 = data.nodes(n1,1); x2 = data.nodes(n2,1);
     y1 = data.nodes(n1,2); y2 = data.nodes(n2,2);
     z1 = data.nodes(n1,3); z2 = data.nodes(n2,3);
     
     line([x1,x2],[y1,y2],[z1,z2],'Color','k');
   end
   
   for e=1:ne
     n1 = data.element(e,1);
     n2 = data.element(e,2); 
     x1 = displaced_nodes(n1,1); x2 = displaced_nodes(n2,1);
     y1 = displaced_nodes(n1,2); y2 = displaced_nodes(n2,2);
     z1 = displaced_nodes(n1,3); z2 = displaced_nodes(n2,3);
     
     line([x1,x2],[y1,y2],[z1,z2],'Color','b');
   end
   legend('Estructura original','Deformacion estimada usando criterio del angulo');
   
   view(45,30);  
  
  f = figure('Name','Desplazamientos con trabajo positivo');
  
  title('Desplazamientos con criterio de trabajo externo positivo');
  
  d = d_pos;
  lambda = lambda_pos;
  % Fuerza horizontal en el nodo 7
  u = d(:,(7-1) *3 +1);
  % Fuerza vertical en el nodo 7
  v = d(:,(7-1) *3 +3);
  % Fuerza vertical en el nodo 8
  w = d(:,(8-1) *3 +3);
  subplot(2,2,1);
  plot(w,lambda/data.material.EA,'k-o');
  hold on;
  plot(w(data.n_steps),lambda(data.n_steps)/data.material.EA,'ro');
  xlabel('w (desplazamiennto vertical nodo 8)');
  ylabel('Lambda/EA');
  
  
  subplot(2,2,2);
  plot(v,lambda/data.material.EA,'k-o');
  hold on;
  plot(v(data.n_steps),lambda(data.n_steps)/data.material.EA,'ro');
  xlabel('v (desplazamiennto vertical nodo 7)');
  ylabel('Lambda/EA');
  
  subplot(2,2,3);
  plot(w,v,'k-o');
  hold on;
  plot(w(data.n_steps),v(data.n_steps),'ro');
  xlabel('w (desplazamiennto vertical nodo 8)');
  ylabel('v (desplazamiennto vertical nodo 7)');
  axis equal
  
  
  d = d_angulo;
  lambda = lambda_angulo;
  cambio_criterio = data.step_criterio;
  
  f = figure('Name','Desplazamientos con criterio del angulo');
  subplot(2,2,1);
  title('Desplazamientos con criterio del angulo');
  % Fuerza horizontal en el nodo 7
  u = d(:,(7-1) *3 +1);
  % Fuerza vertical en el nodo 7
  v = d(:,(7-1) *3 +3);
  % Fuerza vertical en el nodo 8
  w = d(:,(8-1) *3 +3);
  subplot(2,2,1);
  plot(w(1:cambio_criterio),lambda(1:cambio_criterio)/data.material.EA,'k-o');
  hold on;
  plot(w(cambio_criterio:data.n_steps),lambda(cambio_criterio:data.n_steps)/data.material.EA,'b-o');
  plot(w(data.n_steps),lambda(data.n_steps)/data.material.EA,'ro');
  xlabel('w (desplazamiennto vertical nodo 8)');
  ylabel('Lambda/EA');
  
  
  subplot(2,2,2);
  plot(v(1:cambio_criterio),lambda(1:cambio_criterio)/data.material.EA,'k-o');
  hold on;
  plot(v(cambio_criterio:data.n_steps),lambda(cambio_criterio:data.n_steps)/data.material.EA,'b-o');
  plot(v(data.n_steps),lambda(data.n_steps)/data.material.EA,'ro');
  xlabel('v (desplazamiennto vertical nodo 7)');
  ylabel('Lambda/EA');
  
  subplot(2,2,3);
  plot(w(1:cambio_criterio),v(1:cambio_criterio),'k-o');
  hold on;
  plot(w(cambio_criterio:data.n_steps),v(cambio_criterio:data.n_steps),'b-x');
  plot(w(data.n_steps),v(data.n_steps),'ro');
  xlabel('w (desplazamiennto vertical nodo 8)');
  ylabel('v (desplazamiennto vertical nodo 7)');
  axis equal
  

  end