function ythoery = mbpfit(inipara,x)

kf=inipara(1);
ku=inipara(2);

global chip;
global ythoery;
global t2;

[t2,y] = ode15s('rbp2',[0:0.2:90],[(kf/(kf+ku))*chip (ku/(kf+ku))*chip 0]); 

ythoery=1e6*y(:,3);

