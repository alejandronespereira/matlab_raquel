function [pe] = peBar(Xe0,Xe1,AE)
%***************************************************
% peBar:
%   Creates the element internal
%   force vector for elastic bar element.
% Input:
%   Xe0 : initial coordinates = [x1    y1    (z1)
%                                x2    y2    (z3)   ].
%   Xe1 : current coordinates = [x1+u1 y1+v1 (z1+w1)
%                                x2+u2 y2+v2 (z3+w2)].
%   AE   : element property AE.
% Output:
%   qe  : element nodal force vector.
%***************************************************

% Form initial element (column) vector a0(:).
a0 = (Xe0(2,:)-Xe0(1,:))';
l0 = sqrt(a0'*a0);

% Form current element (column) vector a1(:).
a1 = (Xe1(2,:)-Xe1(1,:))';
l1 = sqrt(a1'*a1);

% Find axial strain
Ee  = 0.5*(l1^2 - l0^2)/l0^2;

% Find internal element force in current position.
N  = AE*Ee;
pe =  (N/l0)*[-a1
  a1];
