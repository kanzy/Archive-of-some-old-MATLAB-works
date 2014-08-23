function f = kaufit(x)

global combine
global mkf
global mku
global mka
global mkd
global chip
global Ctemp
global Cmbp
global fitParaA

mkf=x(1);
mku=x(2);
mka=x(3);
mkd=fitParaA(1);

for i=1:5
Cmbp=Ctemp(i);   
[t,y] = ode15s('mbp',[0:0.2:90],[(mkf/(mkf+mku))*chip (mku/(mkf+mku))*chip 0]); 
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