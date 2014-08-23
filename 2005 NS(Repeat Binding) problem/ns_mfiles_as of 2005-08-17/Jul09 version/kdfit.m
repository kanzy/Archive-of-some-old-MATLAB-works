function f = kdfit(x)

global combine
global assTime
global dissTime

inikd=x(1);
offset=x(2:6);

funxdata = [combine((assTime*5+1),2)*exp(-inikd*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime))+offset(1);
            combine((assTime*5+1),3)*exp(-inikd*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime))+offset(2);
            combine((assTime*5+1),4)*exp(-inikd*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime))+offset(3);
            combine((assTime*5+1),5)*exp(-inikd*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime))+offset(4);
            combine((assTime*5+1),6)*exp(-inikd*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime))+offset(5) ];

ydata = [combine((assTime*5+1):((assTime+dissTime)*5+1),2);
        combine((assTime*5+1):((assTime+dissTime)*5+1),3);
        combine((assTime*5+1):((assTime+dissTime)*5+1),4);
        combine((assTime*5+1):((assTime+dissTime)*5+1),5);
        combine((assTime*5+1):((assTime+dissTime)*5+1),6) ];
     
   f = ydata - funxdata;