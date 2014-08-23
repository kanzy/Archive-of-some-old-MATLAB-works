function f = kaufit(x)

global combine
global iniparaB
global chip
global Ctemp
global Cmbp

for i=1:5
Cmbp=Ctemp(i);   
[t,y] = ode15s('mbp',[0:0.2:90],[(iniparaB(1)/(iniparaB(1)+iniparaB(2)))*chip (iniparaB(2)/(iniparaB(1)+iniparaB(2)))*chip 0]); 
data(:,i)=1e6*y(:,3);
end
funxdata=[data(:,1);
             data(:,2);
             data(:,3);
             data(:,4);
             data(:,5); ];

ydata = [combine(1:451,2);
        combine(1:451,3);
        combine(1:451,4);
        combine(1:451,5);
        combine(1:451,6) ];
     
   f = ydata - funxdata;