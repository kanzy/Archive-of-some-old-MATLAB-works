function dy=ssb_ode(t,y)

global kf; 
global ku; 
global ka; 
global kd;
global k_C;
global k_D;
global C0;

dy = zeros(3,1);    

% y1:Q y2:R y3:F
dy(1) = -ku*y(1) + kf*y(2);
dy(2) = ku*y(1) - (kf + ka*(y(3)-k_D*C0)/(k_C-k_D))*y(2) + kd*(y(3)-k_C*C0)/(k_D-k_C); 
dy(3) = C0*(ka*k_D*y(2)+kd*k_C) - y(3)*(ka*y(2)+kd);
