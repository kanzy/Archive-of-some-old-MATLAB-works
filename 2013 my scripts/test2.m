

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Figure 2A: peptides mass spectra obs/fit comparison
resSumVal=[0,0];
resSumNum=[0,0];
totalFigNum=ceil(size(usePeps,1)/(rowNum*colNum));
for figNum=1:totalFigNum
    h=figure;
    n=0;
    for i=(rowNum*colNum)*(figNum-1)+1:(rowNum*colNum)*figNum
        if i>size(usePeps,1)
            break
        end
        n=n+1;
        subplot(rowNum,colNum,n)
        START=usePeps(i,1);
        END=usePeps(i,2);
        %%%calculate simulated distribution
        pepD=zeros(1,END-START+1-XN);
        for j=(START+XN):END
            [r,c]=find(DIndex==j);
            if min(size(r))~=0
                if flagBXC==0
                    pepD(j-START+1-XN)=DFit(r);
                else %2012-01-06 added:
                    bxTime=useData{i,3}(1,1);
                    kcDH=fbmme_dh(proSeq(START:END), bxPH, bxTemp, 'poly');
                    pepD(j-START+1-XN)=DFit(r)*exp(-kcDH(j-START+1)*bxTime);
                end
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
        if flagBXC==0 %2012-01-08 added
            title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])
        else
            title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])
        end
        
        resSumVal(1)=resSumVal(1)+(centSim-centObs)^2;
        resSumNum(1)=resSumNum(1)+1;
        
        resSumVal(2)=resSumVal(2)+sum((distObs-distSim).^2);
        resSumNum(2)=resSumNum(2)+size(distObs,2);
    end
    SaveFigureName=['(',AnalyName,')_HDsite_Fig2A_Part',num2str(figNum),'of',num2str(totalFigNum),'.fig'];
    saveas(figure(h),SaveFigureName)
    saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
    disp(' ')
    disp([SaveFigureName,' has been saved in MATLAB current directory!'])
end
fitResults.RMSD1=(resSumVal(1)/resSumNum(1))^0.5;
fitResults.RMSD2=(resSumVal(2)/resSumNum(2))^0.5;



return


%%%Figure 3: initial/fitted PF plot & recovery plot
h=figure;
subplot(2,1,1)
if InputDataType==2
    for i=min(usePeps(:,1)):max(usePeps(:,2))
        if proSeq(i)~='P'
            stem(i, simDarray(i), 'MarkerSize', 8, 'color','k')
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
        Color='b';
    else
        Color='r';
    end
    for j=1:size(DIndex,2)
        if DIndex(i,j)>0
            %             stem(DIndex(i,j), D0(j), 'MarkerSize', 7, 'Marker','square') %2011-07-26 changed
            %             hold on
            [r,c]=find(DIndex2==DIndex(i,j));
            if fitLevel==1
                r=i; %2013-03-18 added
            end
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
        plot(p1,p2,'b:')
        hold on
    end
end
if InputDataType==2
    DiffNorm=DiffNorm/size(DFit,2);
    fitResults.RMSD_D=DiffNorm.^0.5;
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
ylabel('D')
if flagBXC==0 %2012-01-08 added
    bxcTitle='  [BXC off]';
else
    bxcTitle='  [BXC on]';
end
if InputDataType==2
    %     title({['Fitting Result (blue cycle=real D; blue square=fitting initial D; red=fitted D)',bxcTitle]; ...
    title({['Fitting Result (black cycle=real D; red=fitted D)',bxcTitle]; ...
        ['RMSD of D=',num2str(fitResults.RMSD_D)]})
else
    %title(['Fitting Result (blue=initial D; red=fitted D)',bxcTitle])
    title(['Fitting Result (red=resolved sites; blue=switchables)',bxcTitle]) %2013-08-29 revised
end

subplot(2,1,2)
for i=1:size(usePeps,1)
    recovD=recovd(useData{i,1}(1,5:end), usePeps(i,1), usePeps(i,2), proSeq, XN); %call recovd.m
    p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
    p2=[recovD*100,recovD*100]; %2012-11-20 revised
    plot(p1,p2,'k','LineWidth',2)
    hold on
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
xlabel('Residue Number')
ylabel('D%')
title('Observed Deuteration at the Peptide Level')
SaveFigureName=['(',AnalyName,')_','HDsite_Fig3.fig'];
saveas(figure(h),SaveFigureName)
saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])


%%%Save above result:
SaveFileName=['(',AnalyName,')_HDsite result.mat'];
HDsiteTable=[DIndex2, NaN*zeros(size(DIndex2,1),3)]; %2013-03-18 revised
for i=1:size(HDsiteTable,1)
    [r,c]=find(DIndex1==HDsiteTable(i,1));
    n=0;
    for j=1:size(DIndex1,2)
        if DIndex1(r,j)~=0
            n=n+1;
        end
    end
    HDsiteTable(i,2)=DFit(r);  %2013-03-18 revised
    HDsiteTable(i,3)=n; %how many (exchangeable) sites in its group
    HDsiteTable(i,4)=r; %it is the r-th group in DIndex1
end
if fitLevel~=1
    HDsiteTable(:,2)=DFit';   %2013-03-18 revised
end
if InputDataType==2
    save(SaveFileName,'XN','simSettings','fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','HDsiteTable')
else
    save(SaveFileName,'XN','fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','HDsiteTable')
end
SaveTxtFileName=['(',AnalyName,')_HDsite table.txt']; %2011-08-22 added
save(SaveTxtFileName, 'HDsiteTable', '-ascii', '-tabs')
disp(' ')
disp([SaveFileName,' and ',SaveTxtFileName,' have been saved in MATLAB current directory!'])



fillForm=[fitLevel, Algo, tElapsed, fitResults.RMSD1, fitResults.RMSD2, NaN, NaN, NaN];
if fitLevel==3
    fillForm(6)=fitResults.RMSD3;
    fillForm(8)=fitResults.resolutionFit;
end
if InputDataType==2
    fillForm(7)=fitResults.RMSD_D;
end
DFit_sort=sort(fitResults.DFit);

