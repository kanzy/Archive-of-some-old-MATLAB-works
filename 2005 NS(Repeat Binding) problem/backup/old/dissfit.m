function dissthoery = dissfit(inikd,x)

kd=inikd;

global tDuplexDiss;
global dissthoery;
global t2;

dissthoery=1e6*tDuplexDiss(1,2)*exp(-kd*(tDuplexDiss(:,1)-90));

