%"rbpc.m": command for Repeat Binding Problem 2005-Mar

%rate constant parameters below be copyed from file "rbp.m"
kf=1e-3;
ku=1e-6;

ka1=5e2;
ka2=1e4;
ka3=1e5;
ka4=1e6;

kd1=1e-2;
kd2=1e-3;
kd3=1e-4;
kd4=1e-5;


%//this seems a stiff problem, so use ode15s instead of ode45.
options = odeset('Refine',1);
%//set parameters: association time(90sec); binding capacity on chip(2e-4M,convert to RU:*1e6).
%//for high kf/ku simulation, use chip=2e-3 instead of 3e-4.
chip=2e-3;
[t,y] = ode15s('rbp',[0:0.2:90],[(kf/(kf+ku))*chip (ku/(kf+ku))*chip 0 0 0 0],options); 

Duplex=1e6*(y(:,3)+y(:,4)+y(:,5)+y(:,6));
tDuplex=[t,Duplex];
save filename tDuplex -ascii
tDDDD=[t,y(:,3),y(:,4),y(:,5),y(:,6)]; %//distribution of D1,D2,D3,D4
%plot(t,tDDDD(:,2), t,tDDDD(:,3), t,tDDDD(:,4), t,tDDDD(:,5))
save filename1 tDDDD -ascii

t=[90.2:.2:390];
n=size(y);
n=n(1)     %to see whether the option 'Refine' need adjusting.
z=1e6*(y(n,3)*exp(-kd1*(t-90)) + y(n,4)*exp(-kd2*(t-90)) + y(n,5)*exp(-kd3*(t-90))+ y(n,6)*exp(-kd4*(t-90)));
tz=[t',z'];
combine=[tDuplex; tz];

plot(combine(:,1),combine(:,2))
save filename2 combine -ascii   %//this command creat a ascii-file in Matlab/bin and can import Prism as final result.


%//add random error(= +/- 1) on final data:
%combine(:,2)= combine(:,2) + 2*rand(2501,1)-1;
%plot(combine(:,1),combine(:,2))
%save filename2 combine -ascii 

