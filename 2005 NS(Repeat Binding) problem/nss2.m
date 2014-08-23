%//created on 2005-May-4, to replace rbpc.m and add late-processing functions to complete whole fitting.

clear
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
% kf=1e-3;
% ku=1e-7;

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
C(5)=100e-9;

%//set binding capacity on chip(i.e. Rmax) (RU):
chip=2e2;

%//set time of Association and Dissociation phase (sec): 
assTime=100;
dissTime=300;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nss=0;
for n_kf=-5:6
    for n_ku=-7:2
        kf=10^n_kf;
        ku=10^n_ku;
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
        simFitTimes=0;
        validTimes=1;
        while(validTimes<=200)
            
            %//for each sim-fit cycle, respectively add a noise of normal distribution with a SD of 0.6 RU:
            global combine
            combine=ones(((assTime+dissTime)*5+1),6);  %//this line to avoid a MATLAB bug when changing ass/dissTime.
            combine(:,1)=originCombine(:,1);
            combine(:,2:6)= originCombine(:,2:6) + 0.6*randn(((assTime+dissTime)*5+1),5);
            
            
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
            
            if(r1B<1e4)
                fitParaSet(validTimes,1:3)=fitParaB;
                fitParaSet(validTimes,4)=fitParaA(1);
%                 fitChi2(validTimes,1)=r1A;
%                 fitChi2(validTimes,2)=r1B;
                iterNumCount(validTimes,1)=outputA.iterations;
                iterNumCount(validTimes,2)=outputB.iterations;
                validTimes=validTimes+1;
            end
            simFitTimes=simFitTimes+1
            disp('Now validTimes has been:')
            disp(validTimes-1)
        end
        %****************************************************
        %// end of sim-fit cycles for Monte Carlo analysis
        %****************************************************
        %//Method C:2005-07-19
        trueKs=[kf,ku,ka4,kd4];
        for i=1:4
            finalFitResultC(:,i)=exp(lognfit(fitParaSet(:,i)))';
            finalError(i)=log10(finalFitResultC(1,i)/trueKs(i));
        end
%         disp('The final Monte Carlo result (MEAN & SD) of [kf, ku, ka, kd] by Method C is:')
%         disp(finalFitResultC)
%         format
%         disp('The final Error on LOG scale relative to True values [kf, ku, ka, kd] by Method C is:')
%         disp(finalError)
%         format short e
%         disp('Above results from the combined kf & ku of')
%         kf
%         ku
        
        %//save results:
        nss_rawFitResult((200*nss+1):(200*(nss+1)),:)=fitParaSet;
        save F:\nss_rawFitResult.txt nss_rawFitResult -ascii
        
        nss_FinalResult(nss+1,1)=kf;
        nss_FinalResult(nss+1,2)=ku;
        nss_FinalResult(nss+1,3:6)=finalError;
        nss_FinalResult(nss+1,7)=simFitTimes;
        nss_FinalResult(nss+1,8)=mean(iterNumCount(:,1));
        nss_FinalResult(nss+1,9)=mean(iterNumCount(:,2));
        save F:\nss_finalResult.txt nss_FinalResult -ascii
        
        
        nss=nss+1
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










