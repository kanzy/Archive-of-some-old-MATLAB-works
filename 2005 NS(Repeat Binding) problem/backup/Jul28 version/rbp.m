% Repeat Binding Problem 2005-03-17
function dy=rbp(t,y)
dy = zeros(6,1);    % a Ctempolumn veCtemptor
% y1:Q y2:R y3:D1 y4:D2 y5:D3 y6:D4

global kf; 
global ku; 
global ka1; 
global ka2; 
global ka3; 
global ka4; 
global kd1; 
global kd2; 
global kd3; 
global kd4;
global Ctemp;

dy(1) = -ku*y(1) + kf*y(2);
dy(2) = ku*y(1) - (kf + (ka1 + ka2 + ka3 + ka4)*Ctemp)*y(2) + kd1*y(3) + kd2*y(4) + kd3*y(5)+ kd4*y(6); 
dy(3) = ka1*Ctemp*y(2) - kd1*y(3);
dy(4) = ka2*Ctemp*y(2) - kd2*y(4); 
dy(5) = ka3*Ctemp*y(2) - kd3*y(5); 
dy(6) = ka4*Ctemp*y(2) - kd4*y(6); 

