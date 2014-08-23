function dy=mbp(t,y)
dy = zeros(3,1);    % a column vector

global iniparaB
global Cmbp

% y1:Q y2:R y3:D 
kf=iniparaB(1);
ku=iniparaB(2);
ka=iniparaB(3);
kd=iniparaB(4);


dy(1) = -ku*y(1) + kf*y(2);
dy(2) = ku*y(1) - (kf + ka*Cmbp)*y(2) + kd*y(3); 
dy(3) = ka*Cmbp*y(2) - kd*y(3);