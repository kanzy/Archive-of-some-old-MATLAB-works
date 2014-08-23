%//created on 2005-May-4, to replace rbpc.m and add late-processing functions to complete whole fitting.

clear
% hold off
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
kf=1e-4;
ku=1e0;

ka1=0;
ka2=0;
ka3=0;
ka4=1e4;

kd1=0;
kd2=0;
kd3=0;
kd4=1e-2;

%//set injecting Concentrations (M):
C(1)=5e-9;
C(2)=15e-9;
C(3)=30e-9;
C(4)=60e-9;
C(5)=100e-9;

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
    %tDDDD=[t,y(:,3),y(:,4),y(:,5),y(:,6)]; 
    %plot(t,tDDDD(:,2), t,tDDDD(:,3), t,tDDDD(:,4), t,tDDDD(:,5))
    %save filename1 tDDDD -ascii
    
    %//calculate dissociation phase:
    t=[(assTime+0.2):0.2:(assTime+dissTime)];
    Duplex=y((assTime*5+1),3)*exp(-kd1*(t-assTime)) + y((assTime*5+1),4)*exp(-kd2*(t-assTime)) + y((assTime*5+1),5)*exp(-kd3*(t-assTime))+ y((assTime*5+1),6)*exp(-kd4*(t-assTime));
    tDuplexDiss=[t',Duplex'];
    
    %//generate theoretical data of whole process:
    originCombine(:,1)=[tDuplexAss(:,1); tDuplexDiss(:,1)];
    originCombine(:,i+1)=[tDuplexAss(:,2); tDuplexDiss(:,2)];
    
end

%****************************************************
%// start of sim-fit cycles for Monte Carlo analysis:
%****************************************************
%%for simFitTimes=1:200
simFitTimes=0;
validTimes=1;
while(validTimes<=200)
    
    %//for each sim-fit cycle, respectively add a noise of normal distribution with a SD of 0.6 RU:
    global combine
    combine=ones(((assTime+dissTime)*5+1),6);  %//this line to avoid a MATLAB bug when changing ass/dissTime.
    combine(:,1)=originCombine(:,1);
    combine(:,2:6)= originCombine(:,2:6) + 0.6*randn(((assTime+dissTime)*5+1),5);
    %plot(combine(:,1),combine(:,2:6),'k')
    %hold on
    
    
    %//////////////////////////////////////////////////////////////////////////////////
    %//FITTING PROCESS
    
    %//set the level of initial fitting values of four ks:
    randomLevel=0.5;
    
    %//fitting kd first:
    inikd=normrnd(kd4,randomLevel*kd4);
    while(inikd <= 0)
        inikd=normrnd(kd4,randomLevel*kd4);
    end
    iniparaA=[inikd; 0; 0; 0; 0; 0]; %//x0(2 to 6) is the fit-para Offset.
    global fitParaA
    [fitParaA,r1A,r2A,exitFlagA,outputA]=lsqnonlin(@kdfit, iniparaA, [0;-Inf;-Inf;-Inf;-Inf;-Inf],[]);
    
    %     %//plot fitted Diss Curves:
    %     for i=1:5
    %     fitDiss(:,i) = originCombine((assTime*5+1),i+1)*exp(-fitParaA(1)*(combine((assTime*5+1):((assTime+dissTime)*5+1),1)-assTime));
    %     plot(combine((assTime*5+1):((assTime+dissTime)*5+1),1),fitDiss(:,i),'r')
    %     hold on
    %     end
    
    %//then fitting ku, kf and ka:
    iniparaB(1)=normrnd(kf,randomLevel*kf);
    iniparaB(2)=normrnd(ku,randomLevel*ku);
    iniparaB(3)=normrnd(ka4,randomLevel*ka4);
    while(iniparaB(1)<=0|iniparaB(2)<=0|iniparaB(3)<=0)
        iniparaB(1)=normrnd(kf,randomLevel*kf);
        iniparaB(2)=normrnd(ku,randomLevel*ku);
        iniparaB(3)=normrnd(ka4,randomLevel*ka4);
    end
    
    %//set the max number of iterations:
    options=optimset('MaxIter',30);
    [fitParaB,r1B,r2B,exitFlagB,outputB]=lsqnonlin(@kaufit,iniparaB,[0 0 0],[],options);
    
    %     %//plot fitted Ass Curves:
    %     global mkf
    %     global mku
    %     global mka
    %     global mkd
    %     mkf=fitParaB(1);
    %     mku=fitParaB(2);
    %     mka=fitParaB(3);
    %     mkd=fitParaA(1);
    %     for i=1:5
    %     global Cmbp
    %     Cmbp=C(i);   
    %     [t,y] = ode15s('mbp',[0:0.2:assTime],[(mkf/(mkf+mku))*chip (mku/(mkf+mku))*chip 0]);
    %     fitAss(:,i)=y(:,3);
    %     plot(combine(1:(assTime*5+1),1),fitAss(:,i),'r')
    %     hold on
    %     end
    if(r1B<1e4)
        fitParaSet(validTimes,1:3)=fitParaB;
        fitParaSet(validTimes,4)=fitParaA(1);
        fitChi2(validTimes,1)=r1A;
        fitChi2(validTimes,2)=r1B;
        iterNumCount(validTimes,1)=outputA.iterations;
        iterNumCount(validTimes,2)=outputB.iterations;
        validTimes=validTimes+1;
    end
    simFitTimes=simFitTimes+1
    disp('Now validTimes has been:')
    disp(validTimes-1)
    %simFitTimes   %//indicate the sim-fit cycles has been completed.
end
%****************************************************
%// end of sim-fit cycles for Monte Carlo analysis
%****************************************************

save E:\USER\kanzy\ns\ns_data\c-4+0_rawFitResult.txt fitParaSet -ascii
save E:\USER\kanzy\ns\ns_data\c-4+0_fitChi2.txt fitChi2 -ascii
save E:\USER\kanzy\ns\ns_data\c-4+0_iterNumCount.txt iterNumCount -ascii

save E:\USER\kanzy\ns\ns_data\c-4+0_simFitTimes.txt simFitTimes -ascii

% %//remove fault fitting-data:
% global results
% results=[fitChi2(:,2) fitParaSet];

% %//Method A: until passing Normality Test
% resultsA=[];
% j=validTimes-1;   %//step-length of Segment for resultsA. Here fixed to only ONE segment! 
% for i=1:j:(validTimes-1)
%     resultsAseg=sortrows(results(i:i+j-1,:),1);
%     h=1;
%     while (h~=0)
%         rowNum=size(resultsAseg);
%         resultsAseg=resultsAseg(1:rowNum(1)-1,:);
%         h=jbtest(resultsAseg(:,2))|jbtest(resultsAseg(:,3))|jbtest(resultsAseg(:,4))|jbtest(resultsAseg(:,5));
%     end
%     resultsA=[resultsA;resultsAseg];
% end
% size_of_resultsA=size(resultsA);
% size_of_resultsA=size_of_resultsA(1);
% disp('The number of Fitting results chosen by Method A is:')
% disp(size_of_resultsA)
% %h=jbtest(resultsA(:,2))|jbtest(resultsA(:,3))|jbtest(resultsA(:,4))|jbtest(resultsA(:,5)) %//if h=0, all-combined set meet Normality.
% save E:\USER\kanzy\ns\ns_data\chosenFitResultA.txt resultsA -ascii
% %//calculate final results of kf,ku,ka,kd and their SD:
% finalFitResultA=[mean(resultsA(:,2:5));std(resultsA(:,2:5))];
% disp('The final Monte Carlo result (MEAN & SD) of [kf, ku, ka, kd] from Method A is:')
% disp(finalFitResultA)
% save E:\USER\kanzy\ns\ns_data\finalFitResult_A.txt finalFitResultA -ascii

% %//Method B: only delete the data with a higher magnitude
% resultsB=sortrows(results,1);
% rowNum=size(resultsB);
% while (resultsB(rowNum(1),1)>=10*resultsB(1,1))
%     resultsB=resultsB(1:rowNum(1)-1,:);
%     rowNum=size(resultsB);
% end
% size_of_resultsB=size(resultsB);
% size_of_resultsB=size_of_resultsB(1);
% disp('The number of Fitting results chosen by Method B is:')
% disp(size_of_resultsB)
% save E:\USER\kanzy\ns\ns_data\chosenFitResultB.txt resultsB -ascii
% %//calculate final results of kf,ku,ka,kd and their SD:
% finalFitResultB=[mean(resultsB(:,2:5));std(resultsB(:,2:5))];
% disp('The final Monte Carlo result (MEAN & SD) of [kf, ku, ka, kd] from Method B is:')
% disp(finalFitResultB)
% save E:\USER\kanzy\ns\ns_data\finalFitResult_B.txt finalFitResultB -ascii

%//Method C:2005-07-19
trueKs=[kf,ku,ka4,kd4];
for i=1:4
    finalFitResultC(:,i)=exp(lognfit(fitParaSet(:,i)))';
    finalError(i)=log10(finalFitResultC(1,i)/trueKs(i));
end
disp('The final Monte Carlo result (MEAN & SD) of [kf, ku, ka, kd] by Method C is:')
disp(finalFitResultC)
format
disp('The final Error on LOG scale relative to True values [kf, ku, ka, kd] by Method C is:')
disp(finalError)
save E:\USER\kanzy\ns\ns_data\c-4+0_finalFitResult_C.txt finalFitResultC -ascii
save E:\USER\kanzy\ns\ns_data\c-4+0_finalError_C.txt finalError -ascii

format short e
disp('Above results from the combined kf & ku of')
kf
ku
%//save the workspace for future analysis:
%save E:\USER\kanzy\ns\ns_data\workspace











