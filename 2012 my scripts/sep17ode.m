

function dy=sep17ode(t,y)

global kch kf


%%%y1:Dcl, y2:Dop, y3:H

dy = zeros(3,1);

dy(1) = kf*y(2);
dy(2) = -(kch+kf)*y(2);
dy(3) = kch*y(2);

