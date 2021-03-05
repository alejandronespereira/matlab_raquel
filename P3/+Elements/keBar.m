function Ke = keBar(Xe0,Xe1,AE)
%***************************************************
% KeBar: 
%   Creates the element tangent stiffness matrix of
%   a Truss element.
% Input:
%   Xe0  : initial coordinates = [x1    y1    (z1)
%                                 x2    y2    (z3)   ].
%   Xe1  : current coordinates = [x1+u1 y1+v1 (z1+w1)
%                                 x2+u2 y2+v2 (z2+w2)].
%   AE   : element property AE.
% Output:
%   Ke   : element tangent stiffness matrix.
%***************************************************

% Form initial element (column) vector a0(:).
a0 = (Xe0(2,:)-Xe0(1,:))';
l0 = sqrt(a0'*a0);

% Form current element (column) vector a1(:).
a1 = (Xe1(2,:)-Xe1(1,:))';
l1 = sqrt(a1'*a1);

% Find axial strain and normal force
e  = 0.5*(l1^2 - l0^2)/l0^2 ;
N  = AE*e;

% Unit matrix.
I = eye(size(a0,1));

% Element tangent stiffness matrix.
Ke = (AE/l0^3)*[ a1*a1'  -a1*a1'
                -a1*a1'   a1*a1'] ...
       + (N/l0)*[   I       -I
                   -I        I   ]   ;

