function f = kdfit(x)

global combine

inikd=x(1);
offset=x(2:6);

funxdata = [combine(451,2)*exp(-inikd*(combine(451:1951,1)-90))+offset(1);
            combine(451,3)*exp(-inikd*(combine(451:1951,1)-90))+offset(2);
            combine(451,4)*exp(-inikd*(combine(451:1951,1)-90))+offset(3);
            combine(451,5)*exp(-inikd*(combine(451:1951,1)-90))+offset(4);
            combine(451,6)*exp(-inikd*(combine(451:1951,1)-90))+offset(5) ];

ydata = [combine(451:1951,2);
        combine(451:1951,3);
        combine(451:1951,4);
        combine(451:1951,5);
        combine(451:1951,6) ];
     
   f = ydata - funxdata;