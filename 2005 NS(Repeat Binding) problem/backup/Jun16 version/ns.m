%//created on 2005-May-4, to replace rbpc.m and add late-processing functions to complete whole fitting.

%//////////////////////////////////////////////////////////////////////////////////
%//SIMULATING PROCESS
clear
hold off

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

ka1=0;
ka2=0;
ka3=0;
ka4=1e6;

kd1=0;
kd2=0;
kd3=0;
kd4=1e-4;

C=1e-9;
%eff=2^10;
%C=eff*1e-9;

%//set binding capacity on chip(2e-4M, convert to RU: *1e6):
%//for high kf/ku simulation, use chip=2e-3 instead of 2e-4.
chip=2e-4;

for i=1:5
   global Ctemp
   Ctemp(i)=C;
   
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
   
   originCombine(:,1)=[tDuplexAss(:,1); tDuplexDiss(:,1)];
   originCombine(:,i+1)=[tDuplexAss(:,2); tDuplexDiss(:,2)];

   C=2*C;
end

%****************************************************
%// start of sim-fit cycles for Monto-Carlo analysis:
%****************************************************
for simFitTimes=1:3
   
%//for each sim-fit cycle, respectively add a noise of normal distribution with a SD of 0.6 RU:
global combine
combine(:,1)=originCombine(:,1);
combine(:,2:6)= originCombine(:,2:6) + 0.6*randn(1951,5);
plot(combine(:,1),combine(:,2:6))
hold on
save D:\USER\Kan-ZY\ns_data\simuCurve.txt combine -ascii


%//////////////////////////////////////////////////////////////////////////////////
%//FITTING PROCESS

%//set the level of initial fitting values of four ks:
randomLevel=0.0;

%//fitting kd first:
inikd=kd4*(1+ randomLevel*randn);
iniparaA=[inikd; 0; 0; 0; 0; 0]; %//x0(2 to 6) is the fit-para Offset.
global fitkd
%options(2)=1e-2;
fitkd = leastsq('kdfit',iniparaA) %//cannot define fitkd>0, may insteadly use the update function "lsqnonlin" in MATLAB 6 or higher.
%clear options;

%//plot fitted Diss Curves:
for i=1:5
   fitDiss(:,i) = combine(451,i+1)*exp(-fitkd(1)*(combine(451:1951,1)-90));
   plot(combine(451:1951,1),fitDiss(:,i),'y')
   hold on
end

%//then fitting ku, kf and ka:
iniparaB(1)=kf*(1+ randomLevel*randn);
iniparaB(2)=ku*(1+ randomLevel*randn);
iniparaB(3)=ka4*(1+ randomLevel*randn);

format short e
%iniparaB
%//set the max number of iterations:
options(14)=40;
fitPara=leastsq('kaufit',iniparaB,options)

%//plot fitted Ass Curves:
global mkf
global mku
global mka
global mkd
mkf=fitPara(1);
mku=fitPara(2);
mka=fitPara(3);
mkd=fitkd(1);
for i=1:5
   global Cmbp
   Cmbp=Ctemp(i);   
   [t,y] = ode15s('mbp',[0:0.2:90],[(mkf/(mkf+mku))*chip (mku/(mkf+mku))*chip 0]);
   fitAss(:,i)=1e6*y(:,3);
   plot(combine(1:451,1),fitAss(:,i),'y')
   hold on
end

fitParaSet(simFitTimes,1:3)=fitPara;
fitParaSet(simFitTimes,4)=fitkd(1);

clear combine
clear iniparaA

end
%****************************************************
%// end of sim-fit cycles for Monto-Carlo analysis
%****************************************************

fitParaSet
