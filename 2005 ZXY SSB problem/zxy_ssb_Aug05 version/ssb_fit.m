function f = ssb_fit(x)

global kf; 
global ku; 
global ka; 
global kd;
global k_C;
global k_D;
global C0;
global Qt;
global assTime;
global F;

kf=x(1);
ku=x(2);
ka=x(3);
kd=x(4);

[t,y] = ode15s('ssb_ode',[0:0.2:assTime],[(kf/(kf+ku))*Qt (ku/(kf+ku))*Qt k_C*C0]);

f = F - y(:,3);
