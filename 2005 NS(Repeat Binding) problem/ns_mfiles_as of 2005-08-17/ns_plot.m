%//created on 2005-May-4, to replace rbpc.m and add late-processing functions to complete whole fitting.

clear
hold off
format short e

%//////////////////////////////////////////////////////////////////////////
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
global assTime
global dissTime

%//set kinetic parameters (s^-1):
kf=1e-2;
ku=1e-3;

ka1=1e4;
ka2=1e5;
ka3=5e5;
ka4=1e6;

kd1=1e-2;
kd2=1e-3;
kd3=1e-4;
kd4=1e-5;

%//set injecting Concentrations (M):
C(1)=5e-9;
C(2)=15e-9;
C(3)=30e-9;
C(4)=60e-9;
C(5)=150e-9;

%//set binding capacity on chip(i.e. Rmax) (RU):
chip=2e2;

%//set time of Association and Dissociation phase (sec): 
assTime=100;
dissTime=300;

%//////////////////////////////////////////////////////////////////////////
%//SIMULATING PROCESS
for i=1:5
    global Ctemp
    Ctemp=C(i);
    
    %//this seems a stiff problem, so use ode15s instead of ode45:
    %//calculate association phase:
    [t,y] = ode15s('rbp',[0:0.2:assTime],[(kf/(kf+ku))*chip (ku/(kf+ku))*chip 0 0 0 0]); 
    Duplex=y(:,3)+y(:,4)+y(:,5)+y(:,6);
    tDuplexAss=[t,Duplex];
    
    %//get the distribution of D1,D2,D3,D4:
%     tDDDD=[t,y(:,3),y(:,4),y(:,5),y(:,6)]; 
%     plot(t,tDDDD(:,2), t,tDDDD(:,3), t,tDDDD(:,4), t,tDDDD(:,5))
%     hold on
    %save filename1 tDDDD -ascii
    
    %//calculate dissociation phase(set 300sec):
    t=[(assTime+0.2):0.2:(assTime+dissTime)];
    Duplex=y((assTime*5+1),3)*exp(-kd1*(t-assTime)) + y((assTime*5+1),4)*exp(-kd2*(t-assTime)) + y((assTime*5+1),5)*exp(-kd3*(t-assTime))+ y((assTime*5+1),6)*exp(-kd4*(t-assTime));
    tDuplexDiss=[t',Duplex'];
    
    %//generate theoretical data of whole process:
    originCombine(:,1)=[tDuplexAss(:,1); tDuplexDiss(:,1)];
    originCombine(:,i+1)=[tDuplexAss(:,2); tDuplexDiss(:,2)];
    
end

%****************************************************
%// start of sim-fit cycles for Monto-Carlo analysis:
%****************************************************
for simFitTimes=1:1
    
    %//for each sim-fit cycle, respectively add a noise of normal distribution with a SD of 0.6 RU:
    global combine
    combine=ones(((assTime+dissTime)*5+1),6);  %//this line to avoid a MATLAB bug when changing ass/dissTime.
    combine(:,1)=originCombine(:,1);
    combine(:,2:6)= originCombine(:,2:6) + 0.6*randn(((assTime+dissTime)*5+1),5);
    plot(combine(:,1),combine(:,2:6),'k')
    hold on
    
    %//////////////////////////////////////////////////////////////////////////////////
    %//FITTING PROCESS
    
    %//set the level of initial fitting values of four ks:
    randomLevel=0.5;
    
    %//fitting kd first:
    inikd=normrnd(kd4,randomLevel*kd4);
    while(inikd <= 0)
        inikd=normrnd(kd4,randomLevel*kd4);
    end
    inikd
    iniparaA=[inikd; 0; 0; 0; 0; 0]; %//x0(2 to 6) is the fit-para Offset.
    global fitParaA
    [fitParaA,r1A,r2A,exitFlagA,outputA]=lsqnonlin(@kdfit, iniparaA, [0;-Inf;-Inf;-Inf;-Inf;-Inf],[]);
    outputA
    fitParaA
    
    %//plot fitted Diss Curves:
    for i=1:5
        fitDiss(:,i) = originCombine((assTime*5+1),i+1)*exp(-fitParaA(1)*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime));
        plot(combine((assTime*5+1):((assTime+dissTime)*5+1),1),fitDiss(:,i),'r')
        hold on
    end
    
    %//then fitting ku, kf and ka:
    iniparaB(1)=normrnd(kf,randomLevel*kf);
    iniparaB(2)=normrnd(ku,randomLevel*ku);
    iniparaB(3)=normrnd(ka4,randomLevel*ka4);
    while(iniparaB(1)<=0|iniparaB(2)<=0|iniparaB(3)<=0)
        iniparaB(1)=normrnd(kf,randomLevel*kf);
        iniparaB(2)=normrnd(ku,randomLevel*ku);
        iniparaB(3)=normrnd(ka4,randomLevel*ka4);
    end
    iniparaB
    [fitParaB,r1B,r2B,exitFlagB,outputB]=lsqnonlin(@kaufit,iniparaB,[0 0 0],[]);
    outputB
    
    %//plot fitted Ass Curves:
    global mkf
    global mku
    global mka
    global mkd
    mkf=fitParaB(1);
    mku=fitParaB(2);
    mka=fitParaB(3);
    mkd=fitParaA(1);
    for i=1:5
        global Cmbp
        Cmbp=C(i);   
        [t,y] = ode15s('mbp',[0:0.2:assTime],[(mkf/(mkf+mku))*chip (mku/(mkf+mku))*chip 0]);
        fitAss(:,i)=y(:,3);
        plot(combine(1:(assTime*5+1),1),fitAss(:,i),'r')
        hold on
    end
    
    fitParaSet(simFitTimes,1:3)=fitParaB;
    fitParaSet(simFitTimes,4)=fitParaA(1);
    fitChi2(simFitTimes,1)=r1A;
    fitChi2(simFitTimes,2)=r1B;

end
%****************************************************
%// end of sim-fit cycles for Monto-Carlo analysis
%****************************************************
    disp('The fitting result is:')
    disp(fitParaSet)
    disp('And the two fittings Chi2 is:')
    disp(fitChi2)
