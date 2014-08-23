% Repeat Binding Problem 2005-03-17
function dy=rbp2(t,y)
dy = zeros(3,1);    % a column vector

global inipara
global C

% y1:Q y2:R y3:D4 
kf=inipara(1);
ku=inipara(2);
ka=inipara(3);
kd=inipara(4);


dy(1) = -ku*y(1) + kf*y(2);
dy(2) = ku*y(1) - (kf + ka*C)*y(2) + kd*y(3); 
dy(3) = ka*C*y(2) - kd*y(3);

