close all
clear fitSettings fitResults


% XN=input('Input how many N-term residues (XN) to be excluded (1 or 2): ');
XN=2;

global flagBXC %2012-01-06 added

disp(' ')
disp('**********************************************************************************')
disp(' ')
disp('HDsite: Protein HX MS Residue Resolution Analysis Programs in MATLAB')
disp(' ')
disp('Englander Laboratory')
disp('Copyright © 2010-2013 University of Pennsylvania')
disp(' ')
disp('**********************************************************************************')

disp(' ')
disp('1: Single time point HX data fitting to site D occupancy (GUI mode)')
disp('2: Single time point HX data fitting to site D occupancy (Command line mode)')
disp('3: Time-course HX dataset batch fitting to site D occupancy and HX rate (GUI mode)')
disp('4: Time-course HX dataset batch fitting to site D occupancy and HX rate (Command line mode)')
disp('5: Time-course HX dataset overall direct fitting to site HX rate (Command line mode)')
disp('6: Read "HDsite Quick Guide"')

%%%old options (before 2013-08-17):
% disp('1: To fit for getting individual D% of HX sites (D-Fit)')
% disp('2: To plot HX curves and calculate protection factors based on result of 1')
% disp('3: To batch processing a dataset containing multiple HX time points')
% disp('4: To fit for directly getting exchange rate of HX sites (K-Fit)')
% disp('5: To fit for directly getting individual protection factor of HX sites (P-Fit) -- OUTDATED')
% disp('6: Read help')
disp(' ')

flag=4 %input('Input the number of choice: ');



%%%2012-01-06 revised for BXC
%%%2011-12-06 msdfit_bat.m: for batch processing
%%%2011-06-17, 2011-08-31 major revised
%%%2011-01-28 msdfit.m: simplified functional version of nhx_simfit.m; working on D% level.

close all
clear fitSettings fitResults


disp(' ')
disp('Batch processing (HX time points) options:')
disp(' ')
disp('1: To fit for getting individual D% of HX sites (will generate "HDsite_batTable.xls")')
disp('2: To plot residue HX curves from HDsite_batTable "Data"') %copy dec08.m(2011)
disp('3: To further plot/fit each residue HX curve (by full model)') %copy dec14.m(2011)
disp('4: To further plot/fit each residue HX curve (by single exponential)')
%disp('5(NEW): To further plot/fit single residue resolved sites (by single exponential) & switchable sites (by stretched exponential)') %2013-03-31 added //2013-08-29 temp removed
disp(' ')
% disp('(5: To prepare "MSDFit_batTable.xls" from older version msdfit_bat result)') %end part of msdfit_bat.m(2012-01-15 added)
% disp(' ')

flagBat=input('Input the number of choice: ');
if flagBat==5
    msdfit_bat_post5 %2013-03-31 added
    return
end
if flagBat~=1
    msdfit_bat_post %call msdfit_bat_post.m for option 2~4
    return
end


disp(' ')
flagBXC=input('Want to do back exchange correction?(1=yes,0=no) ');
if flagBXC==1
    flag=input('Load a previously saved all-D BXC result? (1=yes,0=no) ');
    if flag==1
        disp('Now import the HDsite_bxc.mat: ')
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

InputDataType=1;  %input('Use experimental or simulated HX data as input?(1=exp, 2=sim, 3=multiple exp): ');

disp(' ')
disp('This program will analyze available peptides in a range. ');
AnalyStart=input('Input the start residue number of analysis range: ');
AnalyEnd=input('Input the end residue number of analysis range: ');


disp(' ')
totalSampleNum=input('How many samples to be run in sequence (It should be all-D control + HX time points): ');
disp(' ')
flag=input('Load and use a previously saved "HDsite_batAnalysis_sampleSet.mat"? (1=yes,0=no): ');
if flag==1
    disp('Now import the HDsite_batAnalysis_sampleSet.mat file containing "usePepsSet", "useDataSet" and "sampleNameSet"...')
    uiimport
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    if size(sampleNameSet,2)~=totalSampleNum
        error('Size not match! Probably wrong imported file.')
    end
else
    usePepsSet=cell(1,totalSampleNum);
    useDataSet=cell(1,totalSampleNum);
    sampleNameSet=cell(1,totalSampleNum);
    for currSampleNum=1:totalSampleNum
        disp(' ')
        disp('****************************************************************************************')
        disp(['Now import the ExMS_wholeResults_afterCheck.mat file containing the "finalTable" for sample # ',num2str(currSampleNum),': '])
        if currSampleNum==1
            disp('(This should be the all-D control sample!)')
        else
            disp(['(This should be the #', num2str(currSampleNum-1), ' HX time point (from shortest to longest)!)'])
        end
        uiimport
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
        proSeq=currSeq;
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
        resmap(goodPeps); %call consolid_pool.m //2013-08-30 changed to resmap.m
        %%%get 'useData' and 'usePeps':
        pepNum=0;
        useData={};
        usePeps=[];
        usePepsRecord=zeros(size(finalTable,1),1); %2011-08-24 added
        disp(' ')
        AnalyType=2; %input('Want to analyze a specific peptide (input 1) or available peptides in a range (input 2)? ');
        switch AnalyType
            case 1
                
            case 2
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
                        %                         RecordName=input('To save for future use, give a name for the record of used peptide set: ','s');
                        SaveFileName=['(',date,'_',sampleName,')_HDsite_usePepsRecord.mat'];
                        save(SaveFileName,'usePepsRecord')
                        disp(' ')
                        disp([SaveFileName,' has been saved in MATLAB current directory!'])
                    case 2
                        disp('Now import the previously saved HDsite_usePepsRecord.mat:')
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
        %         disp(' ')
        %         sampleName=input('Give a name for this analysis of this sample (e.g. Jan01_30secHX): ','s');
        usePepsSet{currSampleNum}=usePeps;
        useDataSet{currSampleNum}=useData;
        sampleNameSet{currSampleNum}=sampleName;
    end
    disp(' ')
    disp('All samples done!')
    disp('To save current "usePepsSet", "useDataSet" and "sampleNameSet" for future use,')
    RecordName=[date,'_',num2str(AnalyStart),'to',num2str(AnalyEnd)];
    %     RecordName=input('Give a prefix name for this _batAnalysis_sampleSet.mat (e.g., Feb27_1to61): ','s');
    SaveFileName=['(',RecordName,')_HDsite_batAnalysis_sampleSet.mat'];
    save(SaveFileName,'usePepsSet','useDataSet','sampleNameSet','proSeq')
    disp(' ')
    disp([SaveFileName,' has been saved in MATLAB current directory!'])
end


disp(' ')
disp('HDsite fitting algorithm may work on three levels: ')
disp('1: Using peptide delta mass (centroid) info only')
disp('2: Using peptide isotopic peaks gross structure (envelope) info')
disp('3: Using peptide isotopic peaks fine structure (lineshape) info')

disp(' ')
fitLevel=input('Input the number of choice: ');
if fitLevel<1 || fitLevel>3
    error('Wrong input!')
end
fitSettings.fitLevel=fitLevel;


%%%set fitting condition:
disp(' ')
Algo=input('Input the number of fitting algorithm to be used (1=lsqnonlin; 2=patternsearch; 3=multistart; 4=globalsearch): ');
if Algo==3
    k_nsp=input('Input the number of start points to run (e.g. 50): ');
end
fitSettings.Algo=Algo;

% disp(' ')
% batAnalyName=input('Give a name for this batch analysis (e.g. "Feb27_1to61_XN1_FL2_Algo1_BXC"): ','s');
if Algo==3
    batAnalyName=[date,'_',num2str(AnalyStart),'to',num2str(AnalyEnd),'_XN',num2str(XN),'_FL',num2str(fitLevel),'_Algo3k',num2str(k_nsp),'_BXC',num2str(flagBXC)];
else
    batAnalyName=[date,'_',num2str(AnalyStart),'to',num2str(AnalyEnd),'_XN',num2str(XN),'_FL',num2str(fitLevel),'_Algo',num2str(Algo),'_BXC',num2str(flagBXC)];
end


D00=0.5 %input('Input the initial D% value for fitting (e.g., 0.5): ');
Dlb=input('Input the lower limit of real D% value (e.g., 0): ');
Dub=input('Input the upper limit of real D% value (e.g., 1): ');
fitSettings.D00=D00;
fitSettings.Dlb=Dlb;
fitSettings.Dub=Dub;


rowNum=5; %input('How many peptides want to be plotted in a column? '); %ask here for later auto save
colNum=5; %input('How many peptides want to be plotted in a row? ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%start analysis of loop of samples:
HDsiteBatTable=zeros(AnalyEnd-AnalyStart,3*totalSampleNum); %2012-01-15 added
for currSampleNum=1:totalSampleNum
    
    close all
    
    disp(' ')
    disp('****************************************************************************************')
    disp(['Now analyzing sample # ',num2str(currSampleNum),' ...'])
    
    usePeps=usePepsSet{currSampleNum};
    useData=useDataSet{currSampleNum};
    sampleName=sampleNameSet{currSampleNum};
    
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
                    plot(p1,p2,'b','LineWidth',1)
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
        plot(p1,p2,'k','LineWidth',2)
        hold on
    end
    axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, 0, size(usePeps,1)+1])
    xlabel('Residue Number')
    ylabel('Peptide Index')
    title('The Fitted Peptide Set (black) & Fitted Sites (red=resolved; blue=switchables)')
    SaveFigureName=['(',sampleName,')_',batAnalyName,'_HDsite_Fig1.fig'];
    saveas(figure(h),SaveFigureName)
    saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
    disp(' ')
    disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    disp(' ')
    
    %%%global fitting:
    switch fitLevel
        case 1
            msdfit_bat_lev1 %call msdfit_lev1.m
        case 2
            nov20_msdfit_bat_lev2
        case 3
            msdfit_bat_lev3
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
            title([num2str(usePeps(i,1)),'--',num2str(usePeps(i,2)),'+',num2str(usePeps(i,3))])
            
            resSumVal(1)=resSumVal(1)+(centSim-centObs)^2;
            resSumNum(1)=resSumNum(1)+1;
            
            resSumVal(2)=resSumVal(2)+sum((distObs-distSim).^2);
            resSumNum(2)=resSumNum(2)+size(distObs,2);
        end
        SaveFigureName=['(',sampleName,')_',batAnalyName,'_HDsite_Fig2A_Part',num2str(figNum),'of',num2str(totalFigNum),'.fig'];
        saveas(figure(h),SaveFigureName)
        saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
        disp(' ')
        disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    end
    fitResults.RMSD1=(resSumVal(1)/resSumNum(1))^0.5;
    fitResults.RMSD2=(resSumVal(2)/resSumNum(2))^0.5;
    
    
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
                title([num2str(START),'--',num2str(END),'+',num2str(Charge)])
                
                resSumVal=resSumVal+sum((simData(:,2)-useDataNorm(:,2)).^2);
                resSumNum=resSumNum+size(simData,1);
            end
            SaveFigureName=['(',sampleName,')_',batAnalyName,'_HDsite_Fig2B_Part',num2str(figNum),'of',num2str(totalFigNum),'.fig'];
            saveas(figure(h),SaveFigureName)
            saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
            disp(' ')
            disp([SaveFigureName,' has been saved in MATLAB current directory!'])
        end
        fitResults.RMSD3=(resSumVal/resSumNum)^0.5;
    end
    
    
    %%%Figure 3: initial/fitted PF plot & recovery plot
    h=figure;
    subplot(2,1,1)
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
                %                 stem(DIndex(i,j), D0(j), 'MarkerSize', 7, 'Marker','square') %2011-07-26 changed
                %                 hold on
                [r,c]=find(DIndex2==DIndex(i,j));
                if fitLevel==1
                    r=i; %2013-03-18 added
                end
                stem(DIndex(i,j), DFit(r), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
                hold on
                p1=[p1, DIndex(i,j)];
                p2=[p2, DFit(r)];
            end
        end
        if min(size(p1))>0
            plot(p1,p2,'b:')
            hold on
        end
    end
    v=axis;
    axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
    ylabel('D%')
    if flagBXC==0 %2012-01-08 added
        bxcTitle='  [BXC off]';
    else
        bxcTitle='  [BXC on]';
    end
    title(['Fitting Result (red=resolved sites; blue=switchables)',bxcTitle])
    
    subplot(2,1,2)
    for i=1:size(usePeps,1)
        recovD=recovd(useData{i,1}(1,5:end), usePeps(i,1), usePeps(i,2), proSeq, XN); %call recovd.m
        p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
        p2=[recovD,recovD];
        plot(p1,p2,'k','LineWidth',2)
        hold on
    end
    v=axis;
    axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
    xlabel('Residue Number')
    ylabel('D%')
    title('Observed Deuteration at the Peptide Level')
    SaveFigureName=['(',sampleName,')_',batAnalyName,'_HDsite_Fig3.fig'];
    saveas(figure(h),SaveFigureName)
    saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-11-08 added
    disp(' ')
    disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    
    
    %%%Save above result:
    SaveFileName=['(',sampleName,')_',batAnalyName,'_HDsite result.mat'];    
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
    save(SaveFileName,'fitSettings','sampleName','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults','HDsiteTable')
    SaveTxtFileName=['(',sampleName,')_',batAnalyName,'_HDsite table.txt']; %2011-08-22 added
    save(SaveTxtFileName, 'HDsiteTable', '-ascii', '-tabs')
    disp(' ')
    disp([SaveFileName,' and ',SaveTxtFileName,' have been saved in MATLAB current directory!'])
    
    
    %%%2012-01-15 added:
    HDsiteBatTable(1:size(fitResults.DIndex2,1),currSampleNum*3-2)=fitResults.DIndex2;
    if fitLevel==1 %2013-04-15 revised (for below 2013-04-09)
        for i=1:size(fitResults.DIndex2,1) %2013-04-09 revised
            [r,c]=find(fitResults.DIndex1==fitResults.DIndex2(i));
            HDsiteBatTable(i,currSampleNum*3-1)=fitResults.DFit(r);
        end
    else
        HDsiteBatTable(1:size(fitResults.DIndex2,1),currSampleNum*3-1)=fitResults.DFit';
    end
    grpNum=0;
    for i=1:size(fitResults.DIndex1,1)
        n=0;
        for j=1:size(fitResults.DIndex1,2)
            if fitResults.DIndex1(i,j)>0
                n=n+1;
            end
        end
        if n>1
            grpNum=grpNum+1;
        end
        for j=1:size(fitResults.DIndex1,2)
            if fitResults.DIndex1(i,j)>0
                x=find(fitResults.DIndex1(i,j)==HDsiteBatTable(:,currSampleNum*3-2));
                if n>1
                    HDsiteBatTable(x,currSampleNum*3)=grpNum; %non-single residue resolved group #
                end
            end
        end
    end
    
end

SaveXlsFileName=['(',batAnalyName,')_HDsite_batTable.xls']; %2012-01-15 added
xlswrite(SaveXlsFileName, HDsiteBatTable);
disp(' ')
disp([SaveXlsFileName, ' has been saved in MATLAB current directory!'])






