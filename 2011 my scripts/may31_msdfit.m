%%%2011-01-28 msdfit.m: simplified functional version of nhx_simfit.m;
%%%working on D% level.

X=2; %exclude N-terminal 1 or 2 residues

%%%get 'useData':
disp(' ')
AnalyStart=1;%input('Input the start residue number of analysis range: ');
AnalyEnd=12; %input('Input the end residue number of analysis range: ');
n=1;
useData={};
for i=1:size(finalTable,1)
    if finalTable(i,2)<=AnalyEnd && finalTable(i,1)+1>=AnalyStart && finalTable(i,12)>=1
        useData{n,1}=finalTable(i,1:3);
        useData{n,2}=finalDataSet{i};
        n=n+1;
    end
end
if n==1
    error('No data for the input analysis range!')
end

disp(' ')
disp(['There will be total ',num2str(size(useData,1)),' peptides to be plotted (in result Fig.2):'])
rowNum=1;%input('How many peptides want to be plotted in a column? ');
colNum=1;%input('How many peptides want to be plotted in a row? ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%set fitting condition:
disp(' ')
fitCondition.D0=0.5;%input('Input the initial D% value for fitting (e.g., 0.5): ');
fitCondition.lb=0;%input('Input the lower limit real D% value (e.g., 0): ');
fitCondition.ub=1;%input('Input the upper limit of D% value (e.g., 1): ');

usePool=[];
for i=1:size(useData,1)
    usePool(i,:)=useData{i,1};
end
consolidPool=consolid_pool(usePool, 1, X); %call consolid_pool.m

M=0;
D0=[];
DIndex1=zeros(size(consolidPool,1),max(consolidPool(:,2)-consolidPool(:,1))+1);
for i=1:size(consolidPool,1)
    if consolidPool(i,1)==consolidPool(i,2)
        if proSeq(consolidPool(i,1))~='P'
            M=M+1;
            D0(M)=fitCondition.D0;
            DIndex1(M,1)=consolidPool(i,1);
        end
    else
        flagAllP=1;
        for j=consolidPool(i,1):consolidPool(i,2)
            if proSeq(j)~='P'
                flagAllP=0;
            end
        end
        if flagAllP==0
            M=M+1;
            D0(M)=fitCondition.D0;
            k=1;
            for j=consolidPool(i,1):consolidPool(i,2)
                if proSeq(j)~='P'
                    DIndex1(M,k)=j;
                    k=k+1;
                end
            end
        end
    end
end

M=0;
D0=[];
DIndex2=[];
for i=(min(usePool(:,1))+X):max(usePool(:,2))
    if proSeq(i)~='P'
        M=M+1;
        D0(M)=fitCondition.D0;
        DIndex2(M,1)=i;
    end
end
Dx0=[D0, 60000];

%%%global fitting:
DIndex=DIndex2; %to fit exchangable sites individually
Algo=input('Input the number of fitting algorithm to be used (1=lsqnonlin; 2=patternsearch; 3=multistart; 4=globalsearch): ');
lb  = [ones(1,M)*fitCondition.lb, 15000];
ub  = [ones(1,M)*fitCondition.ub, 300000];
        
tic %start time counting
switch Algo
%     case 1
%         disp('Running nonlinear least-squares curve fitting of mass spectra... Please wait!')
%         f = @(D)msdfit_algo1(D, DIndex, useData, proSeq, X); %use simfit1_fita.m
%         [DFit,resnorm,residual,exitflag,output] = lsqnonlin(f,D0,lb,ub); %use MATLAB nonlinear least-squares curve fitting
%         
%     case 2
%         disp('Running pattern search fitting of mass spectra... Please wait!')
%         f = @(D)msdfit_algo2(D, DIndex, useData, proSeq, X);
%         [DFit,fval,exitflag,output] = patternsearch(f, D0,[],[],[],[],lb,ub); %use MATLAB "pattern search" fitting method
%         
    case 3
        k=input('Input the number of start points to run (e.g. 50): ');
        disp('Running multi-start global fitting of mass spectra... Please wait!')
        f = @(Dx)may31_msdfit_algo1(Dx, DIndex, useData, proSeq, X);
        problem = createOptimProblem('lsqnonlin','objective',f,'x0',Dx0,'lb',lb,'ub',ub);
        ms = MultiStart;
        [DxFit,fval,exitflag,output,solutions] = run(ms,problem,k); 
        
    case 4
        disp('Running global search fitting of mass spectra... Please wait!')
        f = @(Dx)may31_msdfit_algo2(Dx, DIndex, useData, proSeq, X);
        problem = createOptimProblem('fmincon','objective',f,'x0',Dx0,'lb',lb,'ub',ub);
        gs = GlobalSearch;
        [DxFit,fval,exitflag,output,solutions] = run(gs,problem);
        
    otherwise
        error('Unkown fitting method!')
end
tElapsed=toc %stop time counting(unit: sec)

DFit=DxFit(1:end-1);
resolutionFit=DxFit(end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plot above result:

%%%Figure 1: peptides pool & fitting spots
h=figure;
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    if DIndex(i,2)>0
        for j=1:size(DIndex,2)
            if DIndex(i,j)>0
                p1=[DIndex(i,j),DIndex(i,j)];
                p2=[0,size(usePool,1)+1];
                plot(p1,p2,'m','LineWidth',1)
                hold on
            end
        end
    else
        p1=[DIndex(i,1),DIndex(i,1)];
        p2=[0,size(usePool,1)+1];
        plot(p1,p2,'r','LineWidth',1)
        hold on
    end
end
for i=1:size(usePool,1)
    p1=[usePool(i,1),usePool(i,2)]; % start and end aa# of each peptide
    p2=[i,i];
    plot(p1,p2,'b','LineWidth',2)
    hold on
end
axis([min(usePool(:,1))-0.5, max(usePool(:,2))+0.5, 0, size(usePool,1)+1])
xlabel('Residue Number')
ylabel('Peptide Index')
title('Peptide Set(blue) & Fitted Amide Hydrogens Sites(red & magenta)')
SaveFigureName=['(',AnalyName,')_May31_MSDFIT_fig1.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])


%%%Figure 2: peptides mass spectra obs/fit comparison
h=figure;
DIndex=DIndex2;
resSumVal=0;
resSumNum=0;
for i=1:size(usePool,1)
    subplot(rowNum,colNum,i)
    START=usePool(i,1);
    END=usePool(i,2);
    Charge=usePool(i,3);
    %%%calculate simulated distribution
    pepD=ones(1,END-START+1-X);
    for j=(START+X):END
        [r,c]=find(DIndex==j);
        if min(size(r))~=0
            pepD(j-START+1-X)=DFit(r);
        end
    end
    
    ifPlot=0;
    [~, simData]=pepsim(proSeq(START:END), Charge, [zeros(1,X), pepD], X, useData{i,2}(:,1)', resolutionFit, ifPlot);

    useDataNorm=useData{i,2};
    useDataNorm(:,2)=useDataNorm(:,2)/sum(useDataNorm(:,2));
    
    plot(useDataNorm(:,1), useDataNorm(:,2), 'k*-')
    hold on
    plot(simData(:,1), simData(:,2), 'r*-')

%     set(gca,'xtick',[],'ytick',[])
    title([num2str(usePool(i,1)),'--',num2str(usePool(i,2)),'+',num2str(usePool(i,3))])
    resSumVal=resSumVal+sum((simData(:,2)-useDataNorm(:,2)).^2);
    resSumNum=resSumNum+size(simData,1);
end
SaveFigureName=['(',AnalyName,')_May31_MSDFIT_fig2.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])

resNorm=resSumVal/resSumNum;



%%%Figure 3: initial/fitted PF plot & recovery plot
h=figure;

% subplot(2,1,1)
if exist('simDarray','var')==1
    for i=min(useData(:,1)):max(useData(:,2))
        if proSeq(i)~='P'
            stem(i, simDarray(i), 'MarkerSize', 8)
            hold on
        end
    end
    DiffNorm=0;
end
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    n=0;
    A=[];
    B=[];
    p1=[];
    p2=[];
    if DIndex(i,2)>0
        Color='m';
    else
        Color='r';
    end
    for j=1:size(DIndex,2)
        if DIndex(i,j)>0
            stem(DIndex(i,j), fitCondition.D0, 'MarkerSize', 7, 'Marker','square')
            hold on
            [r,c]=find(DIndex2==DIndex(i,j));
            stem(DIndex(i,j), DFit(r), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
            hold on
            if exist('simDarray','var')==1
                A=[A, DFit(r)];
                B=[B, simDarray(DIndex(i,j))];
            end
            p1=[p1, DIndex(i,j)];
            p2=[p2, DFit(r)];
        end
    end
    if exist('simDarray','var')==1
        A=sort(A);
        B=sort(B);
        DiffNorm=DiffNorm+sum((A-B).^2);
    end
    if min(size(p1))>0
        plot(p1,p2,'m:')
        hold on
    end
end
if exist('simDarray','var')==1
    DiffNorm=DiffNorm/size(DFit,2);
end
v=axis;
axis([min(usePool(:,1))-0.5, max(usePool(:,2))+0.5, v(3), v(4)])
ylabel('D%')
if exist('simDarray','var')==1
    title({'Fitting Result (blue cycle=real D%; blue square=fitting initial D%; red=fitted D%)'; ...
        ['resNorm=',num2str(resNorm),'; DiffNorm=',num2str(DiffNorm)]})
else
    title({'Fitting Result (blue=initial D%; red=fitted D%)'; ['resNorm=',num2str(resNorm)]})
end

% subplot(2,1,2)
% for i=1:size(usePool,1)
%     recovD=recovd(useData(i,4:end), useData(i,1), useData(i,2), proSeq, X); %call recovd.m
%     p1=[useData(i,1),useData(i,2)]; % start and end aa# of each peptide
%     p2=[recovD,recovD];
%     plot(p1,p2,'b','LineWidth',2)
%     hold on
% end
% v=axis;
% axis([min(useData(:,1))-0.5, max(useData(:,2))+0.5, v(3), v(4)])
% xlabel('Residue Number')
% ylabel('D%')
% title('Deuterons Recovery of Peptide Set')
SaveFigureName=['(',AnalyName,')_','May31_MSDFIT_fig3.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])





%%%Save above result:
SaveFileName=['(',AnalyName,')_May31_MSDFIT.mat'];
if exist('simDarray','var')==1
    save(SaveFileName,'data','finalTable','proSeq','AnalyStart','AnalyEnd','useData','fitCondition','Algo','DIndex1','DIndex2','DFit','resNorm','DiffNorm','output')
else
    save(SaveFileName,'data','finalTable','proSeq','AnalyStart','AnalyEnd','useData','fitCondition','Algo','DIndex1','DIndex2','DFit','resNorm','output')
end

disp(' ')
disp(['There are ', num2str(size(DFit,2)), ' fitted residues.'])
disp(['Average peptide number per fitted residue is: ', num2str(size(useData,1)/size(DFit,2))]);
disp(['Average data points number per fitted residue is: ', num2str(resSumNum/size(DFit,2))]);
disp(['resNorm=',num2str(resNorm)])
if exist('simDarray','var')==1
    disp(['DiffNorm=',num2str(DiffNorm)])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp(' ')
% flag=0;%input('Want to run "singlex.m" to calculate "kex" and "pf"? (1=yes,0=no) ');
% if flag==0
%     return
% end
% 
% clear hxPara
% hxPara.D0=input('Input intial D% (0~1) of the HX process: ');
% hxPara.time=input('Input the HX time (sec): ');
% hxPara.temp=input('Input the HX temperature (C): ');
% hxPara.pH=input('Input pH value in the HX solution: ');
% hxPara.hxDir=input('Input the HX direction (1: H->D; 2: D->H): ');
% 
% [kchPro, kex, pf] = singlex(DFit, DIndex2', proSeq, hxPara); %call singlex.m
% 
% SaveFileName=['(',AnalyName,')_MSDFIT_singlex.mat'];
% save(SaveFileName,'proSeq','hxPara','DFit','kchPro','kex','pf')
% 
% h=figure;
% DIndex=DIndex1;
% DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
% for i=1:size(DIndex,1)
%     n=0;
%     p1=[];
%     p2=[];
%     if DIndex(i,2)>0
%         Color='m';
%     else
%         Color='r';
%     end
%     for j=1:size(DIndex,2)
%         if DIndex(i,j)>0
%             stem(DIndex(i,j), log10(kchPro(DIndex(i,j))), 'k','MarkerSize', 7, 'Marker','square')
%             hold on
%             [r,c]=find(DIndex2==DIndex(i,j));
%             stem(DIndex(i,j), log10(kex(r)), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
%             hold on
%             text(DIndex(i,j), log10(kchPro(DIndex(i,j)))*1.05, proSeq(DIndex(i,j)))
%             hold on
%             p1=[p1, DIndex(i,j)];
%             p2=[p2, log10(kex(r))];
%         end
%     end
%     if min(size(p1))>0
%         plot(p1,p2,'m:')
%         hold on
%     end
% end
% v=axis;
% axis([min(useData(:,1))-0.5, max(useData(:,2))+0.5, v(3), v(4)])
% xlabel('Residue Number')
% ylabel('log_1_0(k)')
% if hxPara.hxDir==1
%     string1='Calculated Hyrogen Exchange Rates (H->D)';
% else
%     string1='Calculated Hyrogen Exchange Rates (D->H)';
% end
% title({string1; ...
%     ['based on Temperature=',num2str(hxPara.temp),' C; pH=',num2str(hxPara.pH),'; HX Time=',num2str(hxPara.time),' (sec); D0=',num2str(hxPara.D0)]; ...
%     '(black: intrinsic rate; red/magenta: exchange rate)';})
% 
% SaveFigureName=['(',AnalyName,')_','MSDFIT_singlex.fig'];
% saveas(figure(h),SaveFigureName)
% disp(' ')
% disp([SaveFigureName,' has been saved in MATLAB current directory!'])
% 




