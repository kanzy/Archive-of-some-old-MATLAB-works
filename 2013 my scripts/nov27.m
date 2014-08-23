%%%2011-06-21 revision
%%%2011-01-28 msdfit_siminput.m: generate simulated "finalTable" for msdfit.m use; ref to dec02.m & nov30.m.
global flagBXC

XN=2

clear simSettings

disp(' ')
disp('*************************************')
disp('Start of Simulator ...')
disp(' ')

%%%first get 'currSeq': copied from exms_preload.m
[headers, sequences] = readfasta('ExMS sequences.fasta'); %call readfast.m
disp('Proteins already in list(ExMS sequences.fasta): ')
for i=1:size(headers,2)
    disp(headers{i}(2:end))
end
disp(' ')
proteinName='SNase' %input('Input the name of your protein (may not in list): ','s');
flag=0;
for i=1:size(headers,2)
    if strcmp(proteinName, headers{i}(2:end))==1
        proSeq=sequences{i}
        flag=1;
    end
end
clear headers sequences
simSettings.proteinName=proteinName;
simSettings.proSeq=proSeq;

disp(' ')
SimStart=1 %input('Input the start residue number of simulation range of the protein: ');
SimEnd=10 %input('Input the end residue number of simulation range of the protein: ');
if SimStart>=SimEnd || SimStart<1 || SimEnd>size(proSeq,2)
    error('Wrong input!')
end
N=SimEnd-SimStart+1;
simSettings.SimStart=SimStart;
simSettings.SimEnd=SimEnd;





%%%generate D% array
for currTest=1:11
    
    inputD=[0, 0, (currTest-1)*0.05*ones(1,4), 1-(currTest-1)*0.05*ones(1,4)] %input(['Input D% array of all the residues (e.g. 0.5*ones(1,',num2str(N),') or [0.1,0.2,...]): ']);
    
    simDarray=NaN*ones(1,size(proSeq,2)); %initialize
    simDarray(SimStart:SimEnd)=inputD;
    
    disp(' ')
    disp('Checking D% at Proline residues...')
    for i=SimStart:SimEnd
        if proSeq(i)=='P'
            disp(['Residue #',num2str(i),' is Proline, D% at this position is reset to 0!'])
            simDarray(i)=0;
        end
    end
    disp('Done! "simDarray" has been generated.')
    simSettings.simDarray=simDarray;
    
    disp(' ')
    disp('To simulate the input peptide set, below scenarios of peptide overlapping are available:')
    disp(' ')
    %%%re-number below on 2012-11-07:
    disp('1: Common end set')
    disp('2: Staggered set')
    disp('3: Staggered set (heavier coverage)')
    disp('4: Random set')
    disp('5: Single peptide (will span the whole simulation range)')
    disp('6: Import a previous saved peptide set')
    disp(' ')
    overlapType=5 %input('Input the number of choice: ');
    simSettings.overlapType=overlapType;
    
    switch overlapType
        case 5 %old 6
            finalTable=[];
            START=max(1, SimStart-XN);
            finalTable(1,1)=START;
            finalTable(1,2)=SimEnd;
            finalTable(1,3)=msdfit_siminput_cs(finalTable(1,1), finalTable(1,2));
            finalTable(1,10)=sum(simDarray((START+XN):SimEnd));
            finalTable(1,12)=1;
    end
    
    for pepNum=1:size(finalTable,1)
        START=finalTable(pepNum,1); %Start residue# of the peptide
        END=finalTable(pepNum,2); %End residue# of the peptide
        [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN); %call pepinfo.m
        finalTable(pepNum,4)=peptideMass/finalTable(pepNum,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton;
        finalTable(pepNum,7)=(END-START+1)/2; %assume mean RT(minutes)=half of the peptide length 2012-11-08 added
        finalTable(pepNum,8)=(END-START+1)/2;
        Distr=1;
        for i=(START+XN):END
            if proSeq(i)~='P'
                Distr=conv(Distr, [1-simDarray(i), simDarray(i)]);
            end
        end
        obsDistr=conv(distND, Distr);
        finalTable(pepNum,20:19+max(size(obsDistr)))=obsDistr/sum(obsDistr); %normalization
    end
    
    %%%Save above result:
    simDataSet={};
    simDataSet{1}=[];
    SaveFileName=['{',proteinName,'_',num2str(SimStart),'to',num2str(SimEnd),'_overlapType',num2str(overlapType),...
        '_SimDarray(',num2str(currTest),')}_HDsite_SimInput.mat'];
    sampleName=[date,'Simulation'];
    currSeq=proSeq;
    save(SaveFileName,'proteinName','sampleName','finalTable','currSeq','simSettings','simDataSet')
    disp(' ')
    disp([SaveFileName,' has been saved in MATLAB current directory!'])
    disp(' ')
    disp('End of Simulator.')
    disp('*************************************')
    disp(' ')
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%below is revised from msdfit.m:
    
    
    %%%2012-10-23 msdfit.m: now called by hdsite.m, is the main body of previous msdfit.m
    
    disp(' ')
    flagBXC=0 %input('Want to do back exchange correction?(1=yes,0=no) ');
    
    proSeq=simSettings.proSeq;
    simDarray=simSettings.simDarray;
    
    %%%show available peptides (and resolution map) for analysis:
    k=1;
    goodPeps=[];
    for i=1:size(finalTable,1)
        if finalTable(i,12)>=1
            goodPeps(k,:)=finalTable(i,1:3);
            k=k+1;
        end
    end
    
    %%%get 'useData' and 'usePeps':
    pepNum=0;
    useData={};
    usePeps=[];
    usePepsRecord=zeros(size(finalTable,1),1); %2011-08-24 added
    disp(' ')
    AnalyType=2 %input('Want to analyze a specific peptide (input 1) or available peptides in a range (input 2)? ');
    InputDataType=2
    switch AnalyType
        case 2
            AnalyStart=1 %input('Input the start residue number of analysis range: ');
            AnalyEnd=10 %input('Input the end residue number of analysis range: ');
            flagC=3; %input('Input the number of choice: ');
            switch flagC
                case 1
                    
                case 2
                    
                case 3
                    for pepIndex=1:size(finalTable,1)
                        if finalTable(pepIndex,2)<=AnalyEnd && finalTable(pepIndex,1)+XN>=AnalyStart && finalTable(pepIndex,12)>=1
                            msdfit_common2 %call msdfit_common2.m
                        end
                    end
            end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%set fitting condition:
    disp(' ')
    disp('HDsite fitting algorithm may work on three levels: ')
    disp('1: Using peptide delta mass (centroid) info only')
    disp('2: Using peptide isotopic peaks gross structure (envelope) info')
    disp('3: Using peptide isotopic peaks fine structure (lineshape) info')
    disp(' ')
    fitLevel=2 %input('Input the number of choice: ');
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
    disp('[7]: LsqNonLin multiple runs with random start points (fitting landscape plot)') %2013-04-18 added
    disp(' ')
    Algo=6 %input('Input the number of choice: ');
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
    
    Dlb=0; %input('Input the lower limit of real D occupancy value (e.g., 0): ');
    Dub=1; %input('Input the upper limit of real D occupancy value (e.g., 1): ');
    fitSettings.Dlb=Dlb;
    fitSettings.Dub=Dub;
    
    disp(' ')
    D00=0.5 %input('Input the initial D value for fitting (e.g., 0.5): ');
    fitSettings.D00=D00;
    
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
    if fitLevel~=1 %2013-03-18 revised
        D0=[];
    end
    DIndex2=[];
    for i=1:size(DIndex1,1)
        for j=1:size(DIndex1,2)
            if DIndex1(i,j)~=0
                M=M+1;
                if fitLevel~=1 %2013-03-18 revised
                    D0(M)=D00;
                end
                DIndex2(M,1)=DIndex1(i,j); %2011-08-22 corrected
            end
        end
    end
    
    fitResults.DIndex1=DIndex1;
    fitResults.DIndex2=DIndex2;
    
    % %%%Figure 1: peptides pool & fitting spots
    % h=figure;
    % DIndex=DIndex1;
    % DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
    % for i=1:size(DIndex,1)
    %     if DIndex(i,2)>0
    %         for j=1:size(DIndex,2)
    %             if DIndex(i,j)>0
    %                 p1=[DIndex(i,j),DIndex(i,j)];
    %                 p2=[0,size(usePeps,1)+1];
    %                 plot(p1,p2,'b','LineWidth',1)
    %                 hold on
    %             end
    %         end
    %     else
    %         p1=[DIndex(i,1),DIndex(i,1)];
    %         p2=[0,size(usePeps,1)+1];
    %         plot(p1,p2,'r','LineWidth',1)
    %         hold on
    %     end
    % end
    % for i=1:size(usePeps,1)
    %     p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
    %     p2=[i,i];
    %     plot(p1,p2,'k','LineWidth',2)
    %     hold on
    % end
    % axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, 0, size(usePeps,1)+1])
    % xlabel('Residue Number')
    % ylabel('Peptide Index')
    % title('The Fitted Peptide Set (black) & Fitted Sites (red=resolved; blue=switchables)')
    % SaveFigureName=['(',AnalyName,')_HDsite_Fig1.fig'];
    % saveas(figure(h),SaveFigureName)
    % saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
    % disp(' ')
    % disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    % disp(' ')
    
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
            plot([centObs, centObs], [v3, v4],'b--','LineWidth',1)
            hold on
            plot([centSim, centSim], [v3, v4],'r--','LineWidth',1)
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
                title({'simDarray: '; num2str(simDarray(3:10))})
            else
                title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])
            end
            
            resSumVal(1)=resSumVal(1)+(centSim-centObs)^2;
            resSumNum(1)=resSumNum(1)+1;
            
            resSumVal(2)=resSumVal(2)+sum((distObs-distSim).^2);
            resSumNum(2)=resSumNum(2)+size(distObs,2);
        end
        SaveFigureName=[num2str(currTest),'_(',AnalyName,')_HDsite_Fig2A_Part',num2str(figNum),'of',num2str(totalFigNum),'.fig'];
        saveas(figure(h),SaveFigureName)
        saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
        disp(' ')
        disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    end
    fitResults.RMSD1=(resSumVal(1)/resSumNum(1))^0.5;
    fitResults.RMSD2=(resSumVal(2)/resSumNum(2))^0.5;
    
    
    %%%Figure 3: initial/fitted PF plot & recovery plot
    h=figure;
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
    
    DFitSort=sort(DFit)
    
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
                [r,c]=find(DIndex2==DIndex(i,j));
                if fitLevel==1
                    r=i; %2013-03-18 added
                end
                stem(DIndex(i,j), DFitSort(j), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
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
%         if min(size(p1))>0
%             plot(p1,p2,'b:')
%             hold on
%         end
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
        title({'black cycle=real D; blue=fitted D'; ...
            ['RMSD of D=',num2str(fitResults.RMSD_D)]})
    else
        %title(['Fitting Result (blue=initial D; red=fitted D)',bxcTitle])
        title(['Fitting Result (red=resolved sites; blue=switchables)',bxcTitle]) %2013-08-29 revised
    end
    
%     subplot(2,1,2)
%     for i=1:size(usePeps,1)
%         recovD=recovd(useData{i,1}(1,5:end), usePeps(i,1), usePeps(i,2), proSeq, XN); %call recovd.m
%         p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
%         p2=[recovD*100,recovD*100]; %2012-11-20 revised
%         plot(p1,p2,'k','LineWidth',2)
%         hold on
%     end
%     v=axis;
%     axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
%     xlabel('Residue Number')
%     ylabel('D%')
%     title('Observed Deuteration at the Peptide Level')
    SaveFigureName=[num2str(currTest),'_(',AnalyName,')_','HDsite_Fig3.fig'];
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
    
    
    close all
    
end




