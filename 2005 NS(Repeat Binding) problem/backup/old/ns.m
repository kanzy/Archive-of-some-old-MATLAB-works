%//created on 2005-May-4, to replace rbpc.m and add late-processing functions to complete whole fitting.

%//////////////////////////////////////////////////////////////////////////////////
%//SIMULATING PROCESS

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
global chip;
global C;

%//set kinetic parameters:
kf=1e-2;
ku=1e-3;

ka1=5e2;
ka2=1e4;
ka3=1e5;
ka4=1e6;

kd1=1e-2;
kd2=1e-3;
kd3=1e-4;
kd4=1e-5;

C=10e-9;
%eff=2^10;
%C=eff*1e-9;

%//set binding capacity on chip(2e-4M, convert to RU: *1e6):
%//for high kf/ku simulation, use chip=2e-3 instead of 2e-4.
chip=2e-4;

%//this seems a stiff problem, so use ode15s instead of ode45:
%//calculate association phase(set 90sec):
[t,y] = ode15s('rbp',[0:0.2:90],[(kf/(kf+ku))*chip (ku/(kf+ku))*chip 0 0 0 0]); 
Duplex=1e6*(y(:,3)+y(:,4)+y(:,5)+y(:,6));
tDuplexAss=[t,Duplex];

%//get the distribution of D1,D2,D3,D4:
%tDDDD=[t,y(:,3),y(:,4),y(:,5),y(:,6)]; 
%plot(t,tDDDD(:,2), t,tDDDD(:,3), t,tDDDD(:,4), t,tDDDD(:,5))
%save filename1 tDDDD -ascii

%//calculate dissociation phase(set 300sec):
t=[90.2:.2:390];
n=size(y);
n=n(1);
Duplex=1e6*(y(n,3)*exp(-kd1*(t-90)) + y(n,4)*exp(-kd2*(t-90)) + y(n,5)*exp(-kd3*(t-90))+ y(n,6)*exp(-kd4*(t-90)));
global tDuplexDiss
tDuplexDiss=[t',Duplex'];

%//generate theoretical data of whole process:
combine=[tDuplexAss; tDuplexDiss];
%plot(combine(:,1),combine(:,2),'r')
%hold on
%save filename2 combine -ascii

%//add noise of normal distribution with a SD of 0.6 RU:
n=size(combine);
n=n(1);
combine(:,2)= combine(:,2) + 0.6*randn(n,1);
plot(combine(:,1),combine(:,2))
hold on
save filename combine -ascii



%//////////////////////////////////////////////////////////////////////////////////
%//FITTING PROCESS

%//fitting kd first:
%global inikd
%global dissthoery

%inikd=kd4*(1+ 0.1*randn);
%fitkd = nlinfit(tDuplexDiss(:,1),tDuplexDiss(:,2),'dissfit',inikd);
%plot(tDuplexDiss(:,1),dissthoery,'r')
%hold on

%//fitting ku, kf and ka:
%global inipara
%global ythoery
%global t2

%inipara(1)=kf*(1+ 0.1*randn);
%inipara(2)=ku*(1+ 0.1*randn);
%inipara(3)=ka4*(1+ 0.1*randn);
%inipara(4)=fitkd;

%//Best-fit Values: kf,ku,ka4,kd4
%format short e
%inipara
%fitpara = nlinfit(combine(1:451,1),combine(1:451,2),'mbpfit',inipara);
%fitpara=fitpara'
%plot(t2,ythoery,'r')

%clear
