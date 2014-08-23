%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp(['There will be total ',num2str(size(usePeps,1)),' peptides to be used for fitting (and to be plotted in result Fig.2)'])
rowNum=1; colNum=1;
if size(usePeps,1)>1
    n=0;
    while rowNum*colNum<size(usePeps,1) %check
        if n>0
            disp('rowNum*colNum must > pepNum! Input again:')
        end
        rowNum=input('How many peptides want to be plotted in a column? '); %ask here for later auto save
        colNum=input('How many peptides want to be plotted in a row? ');
        n=n+1;
    end
end

%%%set fitting condition:
disp(' ')
Algo=input('Input the number of fitting algorithm to be used (1=lsqnonlin; 2=patternsearch; 3=multistart; 4=globalsearch): ');
D00=0.5 %input('Input the initial D% value for fitting (e.g., 0.5): ');
Dlb=0 %input('Input the lower limit real D% value (e.g., 0): ');
Dub=1 %input('Input the upper limit of D% value (e.g., 1): ');
fitSettings.Algo=Algo;
fitSettings.D00=D00;
fitSettings.Dlb=Dlb;
fitSettings.Dub=Dub;

disp(' ')
AnalyName=input('Give a name for this analysis: ','s');

%%%generate 'DIndex1', 'DIndex2' and 'D0':
consolidPool=consolid_pool(usePeps, 0, XN); %call consolid_pool.m
M=0;
D0=[];
DIndex1=zeros(size(consolidPool,1),max(consolidPool(:,2)-consolidPool(:,1))+1);
for i=1:size(consolidPool,1)
    if consolidPool(i,1)==consolidPool(i,2)
        if proSeq(consolidPool(i,1))~='P'
            M=M+1;
            D0(M)=D00;
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
            D0(M)=D00;
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
for i=(min(usePeps(:,1))+XN):max(usePeps(:,2))
    if proSeq(i)~='P'
        M=M+1;
        D0(M)=D00;
        DIndex2(M,1)=i;
    end
end
fitResults.DIndex1=DIndex1;
fitResults.DIndex2=DIndex2;

%%%Figure 1: peptides pool & fitting spots
h=figure;
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    if DIndex(i,2)>0
        for j=1:size(DIndex,2)
            if DIndex(i,j)>0
                p1=[DIndex(i,j),DIndex(i,j)];
                p2=[0,size(usePeps,1)+1];
                plot(p1,p2,'m','LineWidth',1)
                hold on
            end
        end
    else
        p1=[DIndex(i,1),DIndex(i,1)];
        p2=[0,size(usePeps,1)+1];
        plot(p1,p2,'r','LineWidth',1)
        hold on
    end
end
for i=1:size(usePeps,1)
    p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
    p2=[i,i];
    plot(p1,p2,'b','LineWidth',2)
    hold on
end
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, 0, size(usePeps,1)+1])
xlabel('Residue Number')
ylabel('Peptide Index')
title('Peptide Set(blue) & Fitted Amide Hydrogens Sites(red & magenta)')
SaveFigureName=['(',AnalyName,')_MSDFIT_Fig1.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])
disp(' ')


%%%global fitting:
switch fitLevel
    case 1
        msdfit_lev1 %call msdfit_lev1.m
    case 2
        msdfit_lev2
    case 3
        msdfit_lev3
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Figure 2A: peptides mass spectra obs/fit comparison
h=figure;
resSumVal=[0,0];
resSumNum=[0,0];
for i=1:size(usePeps,1)
    subplot(rowNum,colNum,i)
    START=usePeps(i,1);
    END=usePeps(i,2);
    %%%calculate simulated distribution
    pepD=zeros(1,END-START+1-XN);
    for j=(START+XN):END
        [r,c]=find(DIndex==j);
        if min(size(r))~=0
            pepD(j-START+1-XN)=DFit(r);
        end
    end
    [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN); %call pepinfo.m
    Distr=1;
    for j=(START+XN):END
        if proSeq(j)~='P'
            Distr=conv(Distr, [1-pepD(j-START+1-XN), pepD(j-START+1-XN)]);
        end
    end
    distSim=conv(distND, Distr);
    distSim=distSim/sum(distSim); %normalization
    centSim=centroid([(0:size(distSim,2)-1)', distSim']); %2011-06-20 added
    
    %%%get normalized experimental distribution:
    distObs=useData{i,1}(1,5:(5+maxND+maxD))/sum(useData{i,1}(1,5:(5+maxND+maxD)));
    centObs=centroid([(0:size(distObs,2)-1)', distObs']);  %2011-06-20 added
    
    stem(0:maxND+maxD, distObs, 'fill', 'k', 'MarkerSize', 3)
    hold on
    stem(0:maxND+maxD, distSim, 'r', 'MarkerSize', 3)
    hold on
    v3=min(min(distObs),min(distSim));
    v4=1.1*max(max(distObs),max(distSim));
    plot([centObs, centObs], [v3, v4],'b:','LineWidth',2)
    hold on
    plot([centSim, centSim], [v3, v4],'r:','LineWidth',2)
    hold on
    axis([-1, 1+maxND+maxD, v3, v4])
    if rowNum*colNum>20
        set(gca,'xtick',[],'ytick',[])
    else
        set(gca,'ytick',[])
    end
    if i==size(usePeps,1)
        xlabel('Delta Mass Above Monoisotopic')
    end
    title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])
    
    resSumVal(1)=resSumVal(1)+(centSim-centObs)^2;
    resSumNum(1)=resSumNum(1)+1;
    
    resSumVal(2)=resSumVal(2)+sum((distObs-distSim).^2);
    resSumNum(2)=resSumNum(2)+size(distObs,2);
end
SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2A.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])
fitResults.RMSE1=(resSumVal(1)/resSumNum(1))^0.5;
fitResults.RMSE2=(resSumVal(2)/resSumNum(2))^0.5;


if fitLevel==3
    %%%Figure 2B: peptides mass spectra obs/fit comparison
    h=figure;
    resSumVal=0;
    resSumNum=0;
    for i=1:size(usePeps,1)
        subplot(rowNum,colNum,i)
        START=usePeps(i,1);
        END=usePeps(i,2);
        Charge=usePeps(i,3);
        %%%calculate simulated distribution
        pepD=zeros(1,END-START+1-XN);
        for j=(START+XN):END
            [r,c]=find(DIndex==j);
            if min(size(r))~=0
                pepD(j-START+1-XN)=DFit(r);
            end
        end
        monoMZ=peptidesMass(i)/Charge+1.007276; %1.007276 is the mass of proton
        resolution=resolutionFit*(monoMZ/400).^0.5; %just for Orbitrap data: the resolution decreases with square root of mass (FT-ICR MS resolution decreases linearly with mass; TOF diff ...)
        [~, simData]=pepsim(proSeq(START:END), Charge, [zeros(1,XN), pepD], XN, useData{i,2}(:,1)', resolution, 0);
        useDataNorm=useData{i,2};
        useDataNorm(:,2)=useDataNorm(:,2)/sum(useDataNorm(:,2));
        plot(useDataNorm(:,1), useDataNorm(:,2), 'k.--')
        hold on
        plot(simData(:,1), simData(:,2), 'r.--')
        if rowNum*colNum>20
            set(gca,'xtick',[],'ytick',[])
        else
            set(gca,'ytick',[])
        end
        if i==size(usePeps,1)
            xlabel('m/z')
        end
        axis([simData(1,1)-2/Charge,simData(end,1)+2/Charge,min(min(simData(:,2)),min(useDataNorm(:,2))),1.1*max(max(simData(:,2)),max(useDataNorm(:,2)))])
        title([num2str(START),'--',num2str(END),'+',num2str(Charge)])
        
        resSumVal=resSumVal+sum((simData(:,2)-useDataNorm(:,2)).^2);
        resSumNum=resSumNum+size(simData,1);
    end
    SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2B.fig'];
    saveas(figure(h),SaveFigureName)
    disp(' ')
    disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    fitResults.RMSE3=(resSumVal/resSumNum)^0.5;
end


%%%Figure 3: initial/fitted PF plot & recovery plot
h=figure;
subplot(2,1,1)
if InputDataType==2
    for i=min(usePeps(:,1)):max(usePeps(:,2))
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
            stem(DIndex(i,j), D00, 'MarkerSize', 7, 'Marker','square')
            hold on
            [r,c]=find(DIndex2==DIndex(i,j));
            stem(DIndex(i,j), DFit(r), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
            hold on
            if InputDataType==2
                A=[A, DFit(r)];
                B=[B, simDarray(DIndex(i,j))];
            end
            p1=[p1, DIndex(i,j)];
            p2=[p2, DFit(r)];
        end
    end
    if InputDataType==2
        A=sort(A);
        B=sort(B);
        DiffNorm=DiffNorm+sum((A-B).^2);
    end
    if min(size(p1))>0
        plot(p1,p2,'m:')
        hold on
    end
end
if InputDataType==2
    DiffNorm=DiffNorm/size(DFit,2);
    fitResults.RMSE_D=DiffNorm.^0.5;
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
ylabel('D%')
if InputDataType==2
    title({'Fitting Result (blue cycle=real D%; blue square=fitting initial D%; red=fitted D%)'; ...
        ['RMSE of D%=',num2str(fitResults.RMSE_D)]})
else
    title('Fitting Result (blue=initial D%; red=fitted D%)')
end

subplot(2,1,2)
for i=1:size(usePeps,1)
    recovD=recovd(useData{i,1}(1,5:end), usePeps(i,1), usePeps(i,2), proSeq, XN); %call recovd.m
    p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
    p2=[recovD,recovD];
    plot(p1,p2,'b','LineWidth',2)
    hold on
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
xlabel('Residue Number')
ylabel('D%')
title('Deuterons Recovery of Peptide Set')
SaveFigureName=['(',AnalyName,')_','MSDFIT_Fig3.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])


%%%Save above result:
SaveFileName=['(',AnalyName,')_MSDFIT.mat'];
if InputDataType==2
    save(SaveFileName,'simSettings','fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults')
else
    save(SaveFileName,'fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults')
end
disp(' ')
disp([SaveFileName,' has been saved in MATLAB current directory!'])

% disp(' ')
% disp(['There are ', num2str(size(DFit,2)), ' fitted residues.'])
% disp(['Average used peptide number per fitted residue is: ', num2str(size(usePeps,1)/size(DFit,2))]);
% disp(['Average used data number per fitted residue is: ', num2str(resSumNum/size(DFit,2))]);
% disp(['resNorm=',num2str(resNorm)])
% if InputDataType==2
%     disp(['DiffNorm=',num2str(DiffNorm)])
% end

fillForm=[fitLevel, Algo, tElapsed, fitResults.RMSE1, fitResults.RMSE2, NaN, NaN, NaN];
if fitLevel==3
    fillForm(6)=fitResults.RMSE3;
    fillForm(8)=fitResults.resolutionFit;
end
if InputDataType==2
    fillForm(7)=fitResults.RMSE_D;
end
DFit_sort=sort(fitResults.DFit);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
flag=input('Want to run "singlex.m" to calculate "kex" and "pf"? (1=yes,0=no) ');
if flag==0
    disp(' ')
    disp('Program over.')
    return
end

clear hxPara
hxPara.D0=input('Input intial D% (0~1) of the HX process: ');
hxPara.time=input('Input the HX time (sec): ');
hxPara.temp=input('Input the HX temperature (C): ');
hxPara.pH=input('Input pH value in the HX solution: ');
hxPara.hxDir=input('Input the HX direction (1: H->D; 2: D->H): ');

[kchPro, kex, pf] = singlex(DFit, DIndex2', proSeq, hxPara); %call singlex.m

SaveFileName=['(',AnalyName,')_MSDFIT_singlex.mat'];
save(SaveFileName,'proSeq','hxPara','DFit','kchPro','kex','pf')

h=figure;
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    n=0;
    p1=[];
    p2=[];
    if DIndex(i,2)>0
        Color='m';
    else
        Color='r';
    end
    for j=1:size(DIndex,2)
        if DIndex(i,j)>0
            stem(DIndex(i,j), log10(kchPro(DIndex(i,j))), 'k','MarkerSize', 7, 'Marker','square')
            hold on
            [r,c]=find(DIndex2==DIndex(i,j));
            stem(DIndex(i,j), log10(kex(r)), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
            hold on
            text(DIndex(i,j), log10(kchPro(DIndex(i,j)))*1.05, proSeq(DIndex(i,j)))
            hold on
            p1=[p1, DIndex(i,j)];
            p2=[p2, log10(kex(r))];
        end
    end
    if min(size(p1))>0
        plot(p1,p2,'m:')
        hold on
    end
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
xlabel('Residue Number')
ylabel('log_1_0(k)')
if hxPara.hxDir==1
    string1='Calculated Hyrogen Exchange Rates (H->D)';
else
    string1='Calculated Hyrogen Exchange Rates (D->H)';
end
title({string1; ...
    ['based on Temperature=',num2str(hxPara.temp),' C; pH=',num2str(hxPara.pH),'; HX Time=',num2str(hxPara.time),' (sec); D0=',num2str(hxPara.D0)]; ...
    '(black: intrinsic rate; red/magenta: exchange rate)';})

SaveFigureName=['(',AnalyName,')_','MSDFIT_singlex.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])

disp(' ')
disp('Program over.')






