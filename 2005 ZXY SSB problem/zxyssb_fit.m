%2005-12-19 created

function f = zxyssb_fit(x)

global kf; 
global ku; 
global ka; 
global kd;
global k_C;
global k_D;
global C0;
global Qt;
global Qtt;
global num;
global assTime;
global stepTime;
global data;
global ydata;
global sim;

kf=x(1);
ku=x(2);
ka=x(3);
kd=x(4);
%disp(x(1))
% ydata=zeros(1204,2);
% sim=zeros(1204,2);

for i=1:num
    Qtt=Qt(i);
    [t,y] = ode15s('zxyssb_ode',[0:stepTime:assTime],[(kf/(kf+ku))*Qtt (ku/(kf+ku))*Qtt k_C*C0]);
    sim((1+(i-1)*(assTime/stepTime+1)):(i*(assTime/stepTime+1)),2)=y(:,3);
    %disp(data(:,:))   
     ydata((1+(i-1)*(assTime/stepTime+1)):(i*(assTime/stepTime+1)),2)=data(:,(i+1));
 %    disp(i)
end

f = ydata(:,2) - sim(:,2);
