%%%2011-06-17, 2011-08-31 major revised
%%%2011-01-28 msdfit.m: simplified functional version of nhx_simfit.m; working on D% level.

disp(' ')
AnalyName=[num2str(START),'-',num2str(END),'+',num2str(CS),'_testNum',num2str(testNum),'_FL',num2str(usedFitLevel),'_Algo',num2str(usedFitAlgo)] %input('Give a name for this analysis: ','s');

close all
clear fitSettings fitResults

XN=2 %exclude N-terminal 1 or 2 residues
% XN=input('Input XN value (0 or 1 or 2): ');

disp(' ')
disp('**********************************************************************************')
disp(' ')
disp('MSDFIT: HX-MS Single Residue Resolution Information Analysis Programs in MATLAB')
disp(' ')
disp('Kan Zhongyuan, Englander Lab')
disp('University of Pennsylvania, 2011')
disp(' ')
disp('**********************************************************************************')

disp(' ')
disp('1: To fit for getting individual D% of HX sites')
disp('2: To plot HX curves and calculate protection factors based on result of 1')
disp('3: To fit for directly getting individual protection factor of HX sites (MSPFIT)')
disp('4: Read help')
disp(' ')

flag=1 %input('Input the number of choice: ');
switch flag
    case 1
        %do nothing here, continue to next part
    case 2
        msdfit_pf %call msdfit_pf.m
        disp(' ')
        disp('Program over.')
        return
    case 3
        mspfit %call mspfit.m
        disp(' ')
        disp('Program over.')
        return
    case 4
        disp(' ')
        disp('MSDFIT help.txt has not been released yet. Contact kanz@upenn.edu for any questions')
        % open('MSDFIT help.txt')
        return
    otherwise
        disp(' ')
        disp('Wrong input!')
        msdfit %go back to the top
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('MSDFIT fitting algorithm may work on three levels: ')
disp('1: Using peptide delta mass (centroid) info only')
disp('2: Using peptide isotopic peaks gross structure (envelope) info')
disp('3: Using peptide isotopic peaks fine structure (lineshape) info')

disp(' ')
fitLevel=usedFitLevel %input('Input the number of choice: ');
if fitLevel<1 || fitLevel>3
    error('Wrong input!')
end
fitSettings.fitLevel=fitLevel;

disp(' ')
InputDataType=1 %input('Use experimental or simulated HX data as input?(1=exp, 2=sim, 3=multiple exp): ');
switch InputDataType
    case 1
        disp(' ')
%         disp('This program need an ExMS style "finalTable" as input.')
%         disp('Now import the ExMS_wholeResults_afterCheck.mat file containing the "finalTable": ')
%         uiimport
%         void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
        proSeq=currSeq;
        
    case 2
        flag=input('Use a previously saved simulated data set? (1=yes,0=no) ');
        if flag==1
            disp('Now import the MSDFIT_SimInput.mat: ')
            uiimport
            void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
            proSeq=simSettings.proSeq;
            simDarray=simSettings.simDarray;
        else
            msdfit_siminput %call msdfit_siminput.m
        end
        
    case 3 %combine more than one protease column conditions 2011-08-03 added
        disp(' ')
        disp('Option 3: Combine more than one protease digestion data.')
        flag=input('How many datasets to be used together? ');
        disp('This program need ExMS style "finalTable" as input.')
        finalTableCombine=[];
        wholeResultsCombine={};
        for i=1:flag
            disp(['Now import the ExMS_wholeResults_afterCheck.mat file of used dataset #',num2str(i),': '])
            uiimport
            void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
            x=size(finalTableCombine,2)-size(finalTable,2);
            if x>=0
                finalTableCombine=[finalTableCombine; [finalTable, zeros(size(finalTable,1),x)]];
            end
            if x<0 && i>1
                finalTableCombine=[[finalTableCombine, zeros(size(finalTableCombine,1),-x)]; finalTable];
            end
            if x<0 && i==1
                finalTableCombine=[finalTableCombine; finalTable];
            end
            wholeResultsCombine=[wholeResultsCombine; wholeResults];
        end
        proSeq=currSeq;
        finalTable=finalTableCombine;
        wholeResults=wholeResultsCombine;
        
    otherwise
        error('Wrong input!')
end

%%%show available peptides (and resolution map) for analysis:
% k=1;
% goodPeps=[];
% for i=1:size(finalTable,1)
%     if finalTable(i,12)>=1
%         goodPeps(k,:)=finalTable(i,1:3);
%         k=k+1;
%     end
% end
% disp(' ')
% disp('See the resolution map of the available peptide set for analysis ...')
% consolid_pool(goodPeps, 1, XN); %call consolid_pool.m

%%%get 'useData' and 'usePeps':
pepNum=0;
useData={};
usePeps=[];
usePepsRecord=zeros(size(finalTable,1),1); %2011-08-24 added
disp(' ')
AnalyType=1 %input('Want to analyze a specific peptide (input 1) or available peptides in a range (input 2)? ');
switch AnalyType
    case 1
%         disp('All available peptides (in "finalTable") are:')
%         disp('START  END  Charge')
%         for i=1:size(finalTable,1)
%             if finalTable(i,12)>=1
%                 disp(finalTable(i,1:3))
%             end
%         end
        AnalyStart=START %input('Input the start residue number of the peptide: ');
        AnalyEnd=END %input('Input the end residue number of the peptide: ');
        AnalyCharge=CS %input('Input the charge state of the peptide: ');
        pepIndex=find(finalTable(:,1)==AnalyStart & finalTable(:,2)==AnalyEnd & finalTable(:,3)==AnalyCharge & finalTable(:,12)>=1);
        while min(size(pepIndex))==0
            disp(' ')
            disp('Error: The input peptide does NOT exist or valid in "finalTable"! Inut again:')
            AnalyStart=input('Input the start residue number of the peptide: ');
            AnalyEnd=input('Input the end residue number of the peptide: ');
            AnalyCharge=input('Input the charge state of the peptide: ');
            pepIndex=find(finalTable(:,1)==AnalyStart & finalTable(:,2)==AnalyEnd & finalTable(:,3)==AnalyCharge & finalTable(:,12)>=1);
        end
        pepIndex=pepIndex(1); %avoid multiple peptides
        pepNum=1;
        sep12_msdfit_common %call msdfit_common.m
        if flag~=1
            error('Bad peptide. No data to use.')
        end
        usePeps(pepNum,:)=[START, END, CS];
        deltaD=finalTable(pepIndex,10);
        useData{pepNum,1}=[START, END, CS, deltaD, selectPeaks(:,2)'];
        useData{pepNum,2}=selectData;
        
    case 2
        AnalyStart=input('Input the start residue number of analysis range: ');
        AnalyEnd=input('Input the end residue number of analysis range: ');
        disp(' ')
        disp('To determine which peptides within this range to be used in fitting,')
        disp('1. Visually check and determine every peptide;')
        disp('2. Load and use a previously saved check record;')
        disp('3. Skip the check: use all available peptides;')
        flagC=input('Input the number of choice: ');
        switch flagC
            case 1
                for pepIndex=1:size(finalTable,1)
                    if finalTable(pepIndex,2)<=AnalyEnd && finalTable(pepIndex,1)+XN>=AnalyStart && finalTable(pepIndex,12)>=1
                        msdfit_common %call msdfit_common.m
                        if flag==1
                            pepNum=pepNum+1;
                            usePeps(pepNum,:)=[START, END, CS];
                            deltaD=finalTable(pepIndex,10);
                            useData{pepNum,1}=[START, END, CS, deltaD, selectPeaks(:,2)'];
                            useData{pepNum,2}=selectData;
                            usePepsRecord(pepIndex)=1;
                        end
                    end
                end
                disp(' ')
                disp('Done!')
                RecordName=input('To save for future use, give a name for the record of used peptide set: ','s');
                SaveFileName=['(',RecordName,')_MSDFIT_usePepsRecord.mat'];
                save(SaveFileName,'usePepsRecord')
                disp(' ')
                disp([SaveFileName,' has been saved in MATLAB current directory!'])
                
            case 2
                disp('Now import the previously saved MSDFIT_usePepsRecord.mat:')
                uiimport
                void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
                if size(finalTable,1)~=size(usePepsRecord,1)
                    error('Wrong import! Size not match!')
                end
                for pepIndex=1:size(finalTable,1)
                    if finalTable(pepIndex,2)<=AnalyEnd && finalTable(pepIndex,1)+XN>=AnalyStart && finalTable(pepIndex,12)>=1
                        if usePepsRecord(pepIndex)==1
                            msdfit_common2 %call msdfit_common2.m
                        end
                    end
                end
                
            case 3
                for pepIndex=1:size(finalTable,1)
                    if finalTable(pepIndex,2)<=AnalyEnd && finalTable(pepIndex,1)+XN>=AnalyStart && finalTable(pepIndex,12)>=1
                        msdfit_common2 %call msdfit_common2.m
                    end
                end
                
            otherwise
                error('Wrong input!')
        end
        if pepNum==0
            error('No data for the input analysis range!')
        end
        
    otherwise
        error('Wrong input!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp(['There will be total ',num2str(size(usePeps,1)),' peptides to be used for fitting (and to be plotted in result Fig.2)'])
rowNum=1; colNum=1;
if size(usePeps,1)>1
%     n=0;
%     while rowNum*colNum<size(usePeps,1) %check
%         if n>0
%             disp('rowNum*colNum must > pepNum! Input again:')
%         end
%         rowNum=input('How many peptides want to be plotted in a column? '); %ask here for later auto save
%         colNum=input('How many peptides want to be plotted in a row? ');
%         n=n+1;
%     end
    disp('(If there are too many peptides, may use multiple pages for Fig.2)')
    rowNum=input('How many peptides want to be plotted in a column? '); %ask here for later auto save
    colNum=input('How many peptides want to be plotted in a row? ');
end

%%%set fitting condition:
disp(' ')
Algo=usedFitAlgo %input('Input the number of fitting algorithm to be used (1=lsqnonlin; 2=patternsearch; 3=multistart; 4=globalsearch): ');
D00=0.5 %input('Input the initial D% value for fitting (e.g., 0.5): ');
Dlb=0 %input('Input the lower limit real D% value (e.g., 0): ');
Dub=1 %input('Input the upper limit of D% value (e.g., 1): ');
fitSettings.Algo=Algo;
fitSettings.D00=D00;
fitSettings.Dlb=Dlb;
fitSettings.Dub=Dub;


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
% for i=(min(usePeps(:,1))+XN):max(usePeps(:,2))
%     if proSeq(i)~='P'
%         M=M+1;
%         D0(M)=D00;
%         DIndex2(M,1)=i;
%     end
% end
for i=1:size(DIndex1,1)
    for j=1:size(DIndex1,2)
        if DIndex1(i,j)~=0
            M=M+1;
            D0(M)=D00;
            DIndex2(M,1)=DIndex1(i,j); %2011-08-22 corrected
        end
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

% %%%2011-07-26 test: input previous fitResults.DFit as D0 of re-fit
% D0=[0.907233188012857,0.306284191256640,0.928532514925053,0.276408620339049,0.478526808207426,0.442179156337006,0.907210312084486,0.912405594579861,0.118713094629508,0.392071588632269,0.0667601444950675,0.612545297928230];

%%%global fitting:
switch fitLevel
    case 1
        msdfit_lev1 %call msdfit_lev1.m
    case 2
        sep12_msdfit_lev2
    case 3
        sep12_msdfit_lev3
end

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
    SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2A_Part',num2str(figNum),'.fig'];
    saveas(figure(h),SaveFigureName)
    disp(' ')
    disp([SaveFigureName,' has been saved in MATLAB current directory!'])
end
fitResults.RMSE1=(resSumVal(1)/resSumNum(1))^0.5;
fitResults.RMSE2=(resSumVal(2)/resSumNum(2))^0.5;


if fitLevel==3
    %%%Figure 2B: peptides mass spectra obs/fit comparison
    resSumVal=0;
    resSumNum=0;
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
            resolution=resolutionFit*(400/monoMZ).^0.5; %just for Orbitrap data: the resolution decreases with square root of mass (FT-ICR MS resolution decreases linearly with mass; TOF diff ...)
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
        SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2B_Part',num2str(figNum),'.fig'];
        saveas(figure(h),SaveFigureName)
        disp(' ')
        disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    end
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
            %           stem(DIndex(i,j), D00, 'MarkerSize', 7, 'Marker','square')
            stem(DIndex(i,j), D0(j), 'MarkerSize', 7, 'Marker','square') %2011-07-26 changed
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
msdfitTable=[DIndex2, DFit'];
for i=1:size(msdfitTable,1)
    [r,c]=find(DIndex1==msdfitTable(i,1));
    n=0;
    for j=1:size(DIndex1,2)
        if DIndex1(r,j)~=0
            n=n+1;
        end
    end
    msdfitTable(i,3)=n; %how many (exchangeable) sites in its group
    msdfitTable(i,4)=r; %it is the r-th group in DIndex1
end
if InputDataType==2
    save(SaveFileName,'simSettings','fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','msdfitTable')
else
    save(SaveFileName,'fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','msdfitTable')
end
% SaveTxtFileName=['(',AnalyName,')_MSDFIT table.txt']; %2011-08-22 added
% save(SaveTxtFileName, 'msdfitTable', '-ascii', '-tabs')
% disp(' ')
% disp([SaveFileName,' and ',SaveTxtFileName,' have been saved in MATLAB current directory!'])


fillForm=[fitLevel, Algo, tElapsed, fitResults.RMSE1, fitResults.RMSE2, NaN, NaN, NaN];
if fitLevel==3
    fillForm(6)=fitResults.RMSE3;
    fillForm(8)=fitResults.resolutionFit;
end
if InputDataType==2
    fillForm(7)=fitResults.RMSE_D;
end
DFit_sort=sort(fitResults.DFit);
