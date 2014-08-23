%%%dec14.m: revised from sep26b.m

%%%2011-08-31 msdfit_pf.m:


SNase='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';
proSeq=SNase;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART I. data preparation (referred to exmsnhx.m)
disp(' ')
flag=1 %input('Input: (1=import data now; 2=import previously saved "MSDFIT_PF.mat" for re-fit) ');
switch flag
    case 1
        HXdir=2 %input('Input the HX direction (1=H->D; 2=D->H): ');
        HXratio=0.1 %input('Input the fraction of D2O (0~1) in HX buffer: ');
        HXallD=0.95 %input('Input the fraction of D (0~1) in FD(all-D) sample: '); %'HXratio' and 'HXallD' should be same or not necessary?
        if HXdir==1 %H->D
            HXpH=input('Input the effective pH value (e.g. pDread+0.4) in HX buffer: ');
        else %D->H
            HXpH=5.6 %8.2 %input('Input the pH value in HX buffer: ');
        end
        HXtemp=20 %input('Input the HX experiment temperature("C): ');

        TP=Data(1,3:end);


    case 2
        uiimport
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
        
    otherwise
        error('Wrong input!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PART II. HX curve plot and pf fitting
disp(' ')
pfFitAlgo=2 %input('Input the number of PF fitting algorithm to be used (1=ode+lsqnonlin; 2=ode+globalsearch; 3=exp+lsqnonlin; 4=exp+globalsearch): ');

qualNum=2 %3; %adjustable
qualThreshold1=0.1 %1/exp(1); %adjustable
qualThreshold2=0.1 %1/exp(1); %adjustable

kchPro_HD = fbmme_hd(proSeq, HXpH, HXtemp, 'poly', 0); %call fbmme_hd.m
kchPro_DH = fbmme_dh(proSeq, HXpH, HXtemp, 'poly'); %call fbmme_dh.m

pfFitResults=[];
M=0;

for aaNum=Data(2,1):Data(end,1)

    disp(' ')
    disp('*******************************************************')
    disp(['Now plot/analyze residue # ',num2str(aaNum),' ...'])
    aaIndex=find(aaNum==Data(:,1));
    if min(size(aaIndex))==0
        disp(' ')
        disp('Because it was not fitted, no plot for it.')
        continue
    end
    
    close all
    h=figure;
    
    %%%plot horizonal D% line of FD ctrl:
    semilogx([1e-6, max(TP)*1.2], [Data(aaIndex,2), Data(aaIndex,2)], 'k:','LineWidth',2)
    hold on
    
    %%%plot intrinsic rate curve (corrected by FD ctrl):
    kcHD=kchPro_HD(aaNum);
    kcDH=kchPro_DH(aaNum);
    [T,Y] = ode15s(@(t,y)msdfit_hx2ode(t,y,kcHD,kcDH,HXratio),[0 max(TP)*1.2],[1-HXallD HXallD]); %use msdfit_hx2ode.m
    corrY=Y(:,2)*(Data(aaIndex,2)/HXallD);
    semilogx(T,corrY,'k--')
    hold on
    
    %%%plot the D% of time points:
    N=0;
    Ds=[];
    for x=1:size(TP,2)
        aaIndex=find(aaNum==Data(:,1));
        if min(size(aaIndex))~=0
                semilogx(TP(x), Data(aaIndex,x+2), 'ro') %single residue resolved
                hold on
                N=N+1;
                Ds(N,1)=TP(x);
                Ds(N,2)=Data(aaIndex,x+2)*(HXallD/Data(aaIndex,2)); %corrected by FD ctrl
        end
    end
    
    %%%do PF fitting only for qualified (single residue resolved) sites:
    if N>=qualNum && max(Ds(:,2))>=qualThreshold1 && min(Ds(:,2))<=(1-qualThreshold2)*max(Ds(:,2))
        disp(' ')
        disp('The data is qualified for PF fitting.')
        pf0=10^(logPfList(aaNum));
        lb=1e-10;
        ub=1e30;
        switch pfFitAlgo
            case 1
                disp('Running nonlinear least-squares curve fitting... Please wait!')
                f = @(pf)msdfit_pf_fit1a(pf, Ds, kcHD, kcDH, HXratio, HXallD); %use msdfit_pf_fit.m
                [pfFit,resnorm,residual,exitflag,output] = lsqnonlin(f,pf0,lb,ub); %use MATLAB nonlinear least-squares curve fitting
            case 2
                disp('Running global search fitting... Please wait!')
                f = @(pf)msdfit_pf_fit1b(pf, Ds, kcHD, kcDH, HXratio, HXallD); %use msdfit_pf_fit.m
                problem = createOptimProblem('fmincon','objective',f,'x0',pf0,'lb',lb,'ub',ub);
                gs = GlobalSearch;
                [pfFit,fval,exitflag,output,solutions] = run(gs,problem);
            case 3
                disp('Running nonlinear least-squares curve fitting... Please wait!')
                if HXdir==1 %H->D
                    kc=kcHD;
                else %D->H
                    kc=kcDH;
                end
                f = @(pf)msdfit_pf_fit2a(pf, Ds, HXdir, kc, HXratio, HXallD); 
                [pfFit,resnorm,residual,exitflag,output] = lsqnonlin(f,pf0,lb,ub); %use MATLAB nonlinear least-squares curve fitting
            case 4
                disp('Running global search fitting... Please wait!')
                if HXdir==1 %H->D
                    kc=kcHD;
                else %D->H
                    kc=kcDH;
                end
                f = @(pf)msdfit_pf_fit2b(pf, Ds, HXdir, kc, HXratio, HXallD); 
                problem = createOptimProblem('fmincon','objective',f,'x0',pf0,'lb',lb,'ub',ub);
                gs = GlobalSearch;
                [pfFit,fval,exitflag,output,solutions] = run(gs,problem);
        end
        
        %%%plot the NMR PF rate curve (corrected by FD ctrl):
        pfNMR=10^(logPfList(aaNum));
        [T,Y] = ode15s(@(t,y)msdfit_hx2ode(t,y,kcHD/pfNMR,kcDH/pfNMR,HXratio),[0 max(TP)*1.2],[1-HXallD HXallD]); %use msdfit_hx2ode.m
        corrY=Y(:,2)*(Data(aaIndex,2)/HXallD);
        semilogx(T,corrY,'b--','LineWidth',1)
        hold on
        
        %%%plot the fitted PF rate curve (corrected by FD ctrl):
        [T,Y] = ode15s(@(t,y)msdfit_hx2ode(t,y,kcHD/pfFit,kcDH/pfFit,HXratio),[0 max(TP)*1.2],[1-HXallD HXallD]); %use msdfit_hx2ode.m
        corrY=Y(:,2)*(Data(aaIndex,2)/HXallD);
        semilogx(T,corrY,'r--','LineWidth',2)
        hold on
        
        if pfFitAlgo>2
            T=0:min(TP)/5:max(TP)*1.2';
            if HXdir==1 %H->D
                Y=HXratio*(1-exp(-kcHD*T/pfFit));
            else %D->H
                Y=HXratio+(HXallD-HXratio)*exp(-kcDH*T/pfFit);
            end
            corrY=Y*(Data(aaIndex,2)/HXallD);
            semilogx(T,corrY,'m--','LineWidth',2)
            hold on
        end
        
        %%%save result:
        M=M+1;
        pfFitResults(M,1)=aaNum;
        pfFitResults(M,2)=pfFit;
        disp(['Residue # ',num2str(aaNum),' fitted Protection Factor = ',num2str(pfFit)])
        title({['Residue # ',num2str(aaNum),': Log(NMR PF)=',num2str(logPfList(aaNum),'%4.2f'),'; Log(MSDFIT PF)=',num2str(log10(pfFit),'%4.2f')];...
            '(black=kch; blue=NMR; red=MSDFIT)'})
        xlabel('HX Time (sec)')
        ylabel('D Fraction')
        %void=input('Press "Enter" to continue...'); %just for review the result and figure
        
        %SaveFigureName=['Sep14_FL2_Algo1_PF fit_Residue#',num2str(aaNum),'.fig'];
        SaveFigureName=['Sep26_FL3_Algo3k50_PF fit_Residue#',num2str(aaNum),'.fig'];
        
        saveas(figure(h),SaveFigureName)
        disp(' ')
        disp([SaveFigureName,' has been saved in MATLAB current directory!'])
        disp(' ')
    else
        disp(' ')
        disp('Plot is done. But the data is NOT qualified for PF fitting.')
        title(['Residue # ',num2str(aaNum),': No fitting for PF'])
        xlabel('HX Time (sec)')
        ylabel('D Fraction')
    end
    
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete

end

% %%%save 'pfFitResults' etc:
% disp(' ')
% SaveFileName=[SaveFileNamePrefix,'_MSDFIT_PF(',date,').mat'];
% save(SaveFileName,'SaveFileNamePrefix','proSeq','X','TP','msdfitTable_TP','msdfitTable_FD', ...
%     'HXdir', 'HXratio', 'HXallD', 'HXtemp', 'HXpH', ...
%     'pfFitAlgo', 'pfFitResults')
% disp(' ')
% disp([SaveFileName,' has been saved in MATLAB current directory for later use!'])










