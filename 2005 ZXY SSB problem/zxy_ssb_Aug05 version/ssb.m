%//created on 2005-Aug-05, to solve the problem of "Extracting rate constants using SSB with intrinsic fluorescence that changes upon binding to oligonucleotide".

clear
hold off
format short e

%//////////////////////////////////////////////////////////////////////////
global kf; 
global ku; 
global ka; 
global kd; 
global k_C;
global k_D;
global C0;
global Qt;
global assTime

%//set kinetic parameters (s^-1):
kf=1e-2;
ku=1e-3;
ka=1e6;
kd=1e-5;

%//set fluorescence coefficients of SSB (cps/M):
k_C=2e13;
k_D=0.8e13;

%//set SSB and DNA's concentration (M):
C0=2e-7;
Qt=2e-7;

%//set time of Association (sec): 
assTime=6000;

%//////////////////////////////////////////////////////////////////////////
%//SIMULATING PROCESS

%//calculate association phase:
[t,y] = ode15s('ssb_ode',[0:0.2:assTime],[(kf/(kf+ku))*Qt (ku/(kf+ku))*Qt k_C*C0]);

%//plot the fluorescence curve:
n=size(y);
global F
F=y(:,3)+1000*randn(n(1),1);
% subplot(1,2,1)
plot(t,F,'k')
hold on

% %//plot the distribution change of Q,R&D
% D=(y(:,3)-k_C*C0)/(k_D-k_C);
% subplot(1,2,2)
% plot(t,y(:,1), t,y(:,2), t,D)
% hold on

%//////////////////////////////////////////////////////////////////////////////////
%//FITTING PROCESS

%//set the level of initial fitting values of four ks:
randomLevel=0.5;

    inipara(1)=normrnd(kf,randomLevel*kf);
    inipara(2)=normrnd(ku,randomLevel*ku);
    inipara(3)=normrnd(ka,randomLevel*ka);
    inipara(4)=normrnd(kd,randomLevel*kf);
    while(inipara(1)<=0|inipara(2)<=0|inipara(3)<=0|inipara(4)<=0)
    inipara(1)=normrnd(kf,randomLevel*kf);
    inipara(2)=normrnd(ku,randomLevel*ku);
    inipara(3)=normrnd(ka,randomLevel*ka);
    inipara(4)=normrnd(kd,randomLevel*kf);
    end
    inipara
    options=optimset('MaxIter',10);
    [fitPara,r1,r2,exitFlag,output]=lsqnonlin(@ssb_fit,inipara,[0 0 0 0],[]);
    output

%//plot fitted Ass Curves:
kf=fitPara(1)
ku=fitPara(2)
ka=fitPara(3)
kd=fitPara(4)
[t,y] = ode15s('ssb_ode',[0:0.2:assTime],[(kf/(kf+ku))*Qt (ku/(kf+ku))*Qt k_C*C0]);
plot(t,y(:,3),'r')













