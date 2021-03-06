%//created on 2005-May-4, to replace rbpc.m and add late-processing functions to complete whole fitting.

%//////////////////////////////////////////////////////////////////////////////////
%//SIMULATING PROCESS
clear
hold off
format short e

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
kf=1e-4;
ku=1e-1;

ka1=0;
ka2=0;
ka3=0;
ka4=1e6;

kd1=0;
kd2=0;
kd3=0;
kd4=1e-5;

%//set injecting Concentrations: (input the lowest; get 2*,4*,8*,16*)
C=10e-9;
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
for simFitTimes=1:1
    
    %//for each sim-fit cycle, respectively add a noise of normal distribution with a SD of 0.6 RU:
    global combine
    combine(:,1)=originCombine(:,1);
    combine(:,2:6)= originCombine(:,2:6) + 0.6*randn(1951,5);
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
        fitDiss(:,i) = originCombine(451,i+1)*exp(-fitParaA(1)*(combine(451:1951,1)-90));
        plot(combine(451:1951,1),fitDiss(:,i),'r')
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
    %//set the max number of iterations:
    %options=optimset('MaxIter',15);
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
        Cmbp=Ctemp(i);   
        [t,y] = ode15s('mbp',[0:0.2:90],[(mkf/(mkf+mku))*chip (mku/(mkf+mku))*chip 0]);
        fitAss(:,i)=1e6*y(:,3);
        plot(combine(1:451,1),fitAss(:,i),'r')
        hold on
    end
    
    fitParaSet(simFitTimes,1:3)=fitParaB;
    fitParaSet(simFitTimes,4)=fitParaA(1);
    fitChi2(simFitTimes,1)=r1A;
    fitChi2(simFitTimes,2)=r1B;
    %iterNumCount(simFitTimes)=outputB.iterations;
    %simFitTimes
end
%****************************************************
%// end of sim-fit cycles for Monto-Carlo analysis
%****************************************************

fitParaSet
fitChi2
% save E:\USER\kanzy\ns\ns_data\rawFitResult.txt fitParaSet -ascii
% save E:\USER\kanzy\ns\ns_data\fitChi2.txt fitChi2 -ascii
% %save E:\USER\kanzy\ns\ns_data\iterNumCount.txt iterNumCount -ascii
% 
% %//remove fault fitting-data:
% results=[fitChi2(:,2) fitParaSet];
% results=sortrows(results,1);
% 
% %//Method A: until passing Normality Test
% % h=1;
% % while (h~=0)
% %     rowNum=size(results);
% %     results=results(1:rowNum(1)-1,:);
% %     h=jbtest(results(:,2))|jbtest(results(:,3))|jbtest(results(:,4))|jbtest(results(:,5));
% % end
% 
% %//Method B: only delete the data with a higher magnitude
% rowNum=size(results);
% while (results(rowNum(1),1)>=10*results(1,1))
%     results=results(1:rowNum(1)-1,:);
%     rowNum=size(results);
% end
% 
% %results
% save E:\USER\kanzy\ns\ns_data\chosenFitResult.txt results -ascii
% 
% %//calculate final results of kf,ku,ka,kd and their SD:
% finalFitResult=[mean(results(:,2:5));std(results(:,2:5))]
% save E:\USER\kanzy\ns\ns_data\finalFitResult.txt finalFitResult -ascii










