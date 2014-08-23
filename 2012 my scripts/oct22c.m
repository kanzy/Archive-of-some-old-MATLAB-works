%%%2012-06-20 revised the order of some parts
%%%2012-01-06 revised for BXC
%%%2011-06-17, 2011-08-31 major revised
%%%2011-01-28 msdfit.m: simplified functional version of nhx_simfit.m; working on D% level.

close all
clear 
clear fitSettings fitResults


% XN=input('Input how many N-term residues (XN) to be excluded (1 or 2): ');
XN=2

global flagBXC %2012-01-06 added

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
disp('3: To fit for directly getting individual protection factor of HX sites (MSPFIT) -- OUTDATED')
disp('4: To batch processing a dataset containing multiple HX time points')
disp('5: To fit for directly getting exchange rate of HX sites (MSKFIT)')
disp('6: Read help')
disp(' ')

flag=1 %input('Input the number of choice: ');
switch flag
    case 1
        flagBXC=0 %input('Want to do back exchange correction?(1=yes,0=no) ');
        if flagBXC==1
            flag=input('Load a previously saved all-D BXC result? (1=yes,0=no) ');
            if flag==1
                disp('Now import the MSDFIT_bxc.mat: ')
                uiimport
                void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
                if XN~=XN_BXC
                    flag2=input('Warning! XN~=XN_BXC. Want to continue using this BXC data? (1=yes,0=no): ');
                    if flag2~=1
                        msdfit_bxc
                    end
                end
            else
                msdfit_bxc %call msdfit_bxc.m 2012-01-06 added
            end
        end
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
        msdfit_bat %call msdfit_bat.m
        disp(' ')
        disp('Program over.') 
        return
    case 5
        mskfit %call mskfit.m
        disp(' ')
        disp('Program over.')
        return
    case 6
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
InputDataType=1 %input('Use experimental or simulated HX data as input?(1=exp, 2=sim, 3=multiple exp): ');
if flagBXC==1 && InputDataType~=1 %2012-01-08 added
    error('flagBXC==1, currently it is only for option 1 here.')
end
switch InputDataType
    case 1
        disp(' ')
        disp('This program need an ExMS style "finalTable" as input.')
        disp('Now import the ExMS_wholeResults_afterCheck.mat file containing the "finalTable": ')
        uiimport
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
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
k=1;
goodPeps=[];
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        goodPeps(k,:)=finalTable(i,1:3);
        k=k+1;
    end
end
disp(' ')
disp('See the resolution map of the available peptide set for analysis ...')
consolid_pool(goodPeps, 1, XN); %call consolid_pool.m

%%%get 'useData' and 'usePeps':
pepNum=0;
useData={};
usePeps=[];
usePepsRecord=zeros(size(finalTable,1),1); %2011-08-24 added
disp(' ')
AnalyType=2 %input('Want to analyze a specific peptide (input 1) or available peptides in a range (input 2)? ');
switch AnalyType
    case 1
        disp('All available peptides (in "finalTable") are:')
        disp('START  END  Charge')
        for i=1:size(finalTable,1)
            if finalTable(i,12)>=1
                disp(finalTable(i,1:3))
            end
        end
        AnalyStart=input('Input the start residue number of the peptide: ');
        AnalyEnd=input('Input the end residue number of the peptide: ');
        AnalyCharge=input('Input the charge state of the peptide: ');
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
        msdfit_common %call msdfit_common.m
        if flag~=1
            error('Bad peptide. No data to use.')
        end
        usePeps(pepNum,:)=[START, END, CS];
        deltaD=finalTable(pepIndex,10);
        useData{pepNum,1}=[START, END, CS, deltaD, selectPeaks(:,2)'];
        useData{pepNum,2}=selectData;
        if flagBXC==1
            if size(bxTimeFitSet,1)~=size(finalTable,1)
                error('BXC wrong size match!')
            end
            useData{pepNum,3}=bxTimeFitSet(pepIndex,:); %2012-01-06 added
        end
        
    case 2
        AnalyStart=1 %input('Input the start residue number of analysis range: ');
        AnalyEnd=40 %input('Input the end residue number of analysis range: ');
        disp(' ')
        disp('To determine which peptides within this range to be used in fitting,')
        disp('1. Visually check and determine every peptide;')
        disp('2. Load and use a previously saved check record;')
        disp('3. Skip the check: use all available peptides;')
        flagC=3 %input('Input the number of choice: ');
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
                            if flagBXC==1
                                if size(bxTimeFitSet,1)~=size(finalTable,1)
                                    error('BXC wrong size match!')
                                end
                                useData{pepNum,3}=bxTimeFitSet(pepIndex,:); %2012-01-06 added
                            end
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

%%%set fitting condition:
disp(' ')
disp('MSDFIT fitting algorithm may work on three levels: ')
disp('1: Using peptide delta mass (centroid) info only')
disp('2: Using peptide isotopic peaks gross structure (envelope) info')
disp('3: Using peptide isotopic peaks fine structure (lineshape) info')
disp(' ')
fitLevel=1 %input('Input the number of choice: ');
if fitLevel<1 || fitLevel>3
    error('Wrong input!')
end
fitSettings.fitLevel=fitLevel;

disp(' ')
disp('There are six fitting algorithms available: ')
disp('1: LsqNonLin')
disp('2: PatternSearch')
disp('3: MultiStart')
disp('4: GlobalSearch')
disp('5: SimulAnnealbnd')
disp('6: GeneticAlgo')
disp(' ')
Algo=1 %input('Input the number of choice: ');
if Algo==3
    k_nsp=input('Input the number of start points to run (e.g. 50): ');
    fitSettings.k_nsp=k_nsp;
end
fitSettings.Algo=Algo;


% disp(' ')
% AnalyName=input('Give a name for this analysis: ','s');
if Algo==3
AnalyName=[date,'_',sampleName,'_',proteinName,'_',num2str(AnalyStart),'to',num2str(AnalyEnd),'_XN',num2str(XN),'_FL',num2str(fitLevel),'_Algo3k',num2str(k_nsp),'_BXC',num2str(flagBXC)];    
else
AnalyName=[date,'_',sampleName,'_',proteinName,'_',num2str(AnalyStart),'to',num2str(AnalyEnd),'_XN',num2str(XN),'_FL',num2str(fitLevel),'_Algo',num2str(Algo),'_BXC',num2str(flagBXC)];
end


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
    rowNum=6 %input('How many peptides want to be plotted in a column? '); %ask here for later auto save
    colNum=7 %input('How many peptides want to be plotted in a row? ');
end

disp(' ')
D00=0.5 %input('Input the initial D% value for fitting (e.g., 0.5): ');
Dlb=0 %input('Input the lower limit of real D% value (e.g., 0): ');
Dub=1 %input('Input the upper limit of real D% value (e.g., 1): ');
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
        msdfit_lev2
    case 3
        msdfit_lev3
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
            title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3)),'  [BXC off]'])
        else
            title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3)),'  [BXC on]'])
        end
        
        resSumVal(1)=resSumVal(1)+(centSim-centObs)^2;
        resSumNum(1)=resSumNum(1)+1;
        
        resSumVal(2)=resSumVal(2)+sum((distObs-distSim).^2);
        resSumNum(2)=resSumNum(2)+size(distObs,2);
    end
    SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2A_Part',num2str(figNum),'of',num2str(totalFigNum),'.fig'];
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
                    if flagBXC==0
                        pepD(j-START+1-XN)=DFit(r);
                    else %2012-01-06 added:
                        bxTime=useData{i,3}(1,1);
                        kcDH=fbmme_dh(proSeq(START:END), bxPH, bxTemp, 'poly');
                        pepD(j-START+1-XN)=DFit(r)*exp(-kcDH(j-START+1)*bxTime);
                    end
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
            if flagBXC==0 %2012-01-08 added
                title([num2str(START),'--',num2str(END),'+',num2str(Charge),'  [BXC off]'])
            else
                title([num2str(START),'--',num2str(END),'+',num2str(Charge),'  [BXC on]'])
            end
            
            resSumVal=resSumVal+sum((simData(:,2)-useDataNorm(:,2)).^2);
            resSumNum=resSumNum+size(simData,1);
        end
        SaveFigureName=['(',AnalyName,')_MSDFIT_Fig2B_Part',num2str(figNum),'of',num2str(totalFigNum),'.fig'];
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
%             stem(DIndex(i,j), D0(j), 'MarkerSize', 7, 'Marker','square') %2011-07-26 changed
%             hold on
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
if flagBXC==0 %2012-01-08 added
    bxcTitle='  [BXC off]';
else
    bxcTitle='  [BXC on]';
end
if InputDataType==2
    title({['Fitting Result (blue cycle=real D%; blue square=fitting initial D%; red=fitted D%)',bxcTitle]; ...
        ['RMSE of D%=',num2str(fitResults.RMSE_D)]})
else
    title(['Fitting Result (blue=initial D%; red=fitted D%)',bxcTitle])
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
title('Observed Deuterons Recovery of Peptide Set')
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
    save(SaveFileName,'XN','simSettings','fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','msdfitTable')
else
    save(SaveFileName,'XN','fitSettings','AnalyName','InputDataType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','msdfitTable')
end
SaveTxtFileName=['(',AnalyName,')_MSDFIT table.txt']; %2011-08-22 added
save(SaveTxtFileName, 'msdfitTable', '-ascii', '-tabs')
disp(' ')
disp([SaveFileName,' and ',SaveTxtFileName,' have been saved in MATLAB current directory!'])


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
flag=0; %input('Want to run "singlex.m" to calculate "kex" and "pf" based on a single HX process assumption? (1=yes,0=no) ');
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






