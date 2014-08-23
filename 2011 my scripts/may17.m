

%%%first get 'currSeq':
[headers, sequences] = readfasta('ExMS sequences.fasta'); %call readfast.m
disp(' ')
disp('Proteins already in list(ExMS sequences.fasta): ')
for i=1:size(headers,2)
    disp(headers{i}(2:end))
end
disp(' ')
proteinName=input('Input the name of your protein (may not in list): ','s');
flag=0;
for i=1:size(headers,2)
    if strcmp(proteinName, headers{i}(2:end))==1
        currSeq=sequences{i}
        flag=1;
    end
end
if flag==0
    disp('Unknown protein!');
    currSeq=input('Input the sequence of your protein (one row & in capital): ','s')
end
clear headers sequences


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%'peptidesPool' format: col1=START, col2=END, col3=Charge, col4=m/z of mono,
%%%                     col5=maxND, col6=maxD,
%%%                     col7=RT(unit:min) of best identification in SEQUEST.
%%%                     col8=Xcorr score of SEQUEST
disp(' ')
disp('Now program will generate "peptidesPool"(experimental pool) based on MS/MS experiment results:')
disp(' by (default) using Bioworks/SEQUEST search (the result table saved as .xls file)')

disp(' ')
scoreSys=input('Input the score system to be used (1=XCorr; 2=Ppep): ');
switch scoreSys
    case 1
        XcorrThresholds=input('Input Xcorr score thresholds for different charge states of peptides: (e.g. [1,1,2,3,4] for +1~(+5&above))');
    case 2
        PpepThreshold=input('Input Ppep score threshold for filtering peptides: (e.g. 0.99) ');
    otherwise
        error('Wrong input!')
end

disp(' ')
numMSMS=input('How many MS/MS experiments(result tables of peptide search) to establish the "peptidesPool"?');
m=1;
clear selectPeps
MS2FileName={}; MS2PathName={};
for i=1:numMSMS
    disp(['Now select the SEQUEST result .xls file #', num2str(i), ' ...'])
    [MS2FileName{i},MS2PathName{i}] = uigetfile('*.xls','Select the Excel file');
    [num,txt,SequestOutput] = xlsread([MS2PathName{i},MS2FileName{i}]);
    
    for j=4:size(SequestOutput,1) %first 3 rows in .csv file are skipped
        if isnan(SequestOutput{j,1})~=1
            break %just select the top protein(assume is the target)
        end
        
        SequestPepCharge=SequestOutput{j,6}; %get z
        SequestPepPscore=SequestOutput{j,8}; %get P score
        SequestPepXscore=SequestOutput{j,9}; %get XCorr score
        
        flag=0;
        switch scoreSys
            case 1
                flag = (SequestPepXscore>=XcorrThresholds(min(SequestPepCharge,5))); %filter by Xcorr score threshold
            case 2
                flag = (SequestPepPscore<=PpepThreshold); %filter by P score threshold
        end
        if flag==1
            SequestPepRTinfo=SequestOutput{j,2};
            dashPosition=find(SequestPepRTinfo=='-');
            if size(dashPosition,2)==0 %just one RT value, not a range.
                SequestPepRT=str2double(SequestPepRTinfo);
            else
                SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-2))+...
                    str2double(SequestPepRTinfo(dashPosition+2:end)))/2; %calculate the mean RT.
            end
            SequestPepSeq=SequestOutput{j,3}(3:end-2); %get sequence
            flagExpand=0;
            ExpandSeq=SequestPepSeq; %initialize 'ExpandSeq'
            if SequestOutput{j,3}(1)~='-' %add left flanking residue help for finding match
                ExpandSeq=[SequestOutput{j,3}(1),ExpandSeq];
                flagExpand=1; %determine whether the left flanking residue exist
            end
            if SequestOutput{j,3}(end)~='-' %add right flanking residue help for finding match
                ExpandSeq=[ExpandSeq,SequestOutput{j,3}(end)];
            end
            startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
            if size(startPositions,2)==1 %one and only one match found along 'currSeq'
                selectPeps(m,1)=startPositions+flagExpand; %START
                selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq,2)-1; %END
                selectPeps(m,3)=SequestPepCharge; %Charge
                selectPeps(m,4)=SequestPepRT; %RT(unit:min)
                switch scoreSys
                    case 1
                        selectPeps(m,5)=SequestPepXscore; %Xcorr score
                    case 2
                        selectPeps(m,5)=SequestPepPscore; %P score
                end
                m=m+1;
            end
        end
    end
end

disp('Establishing peptidesPool...')

%%%generate 'peptidesPool' col 1~3&7~8:
clear peptidesPool peptidesPool_distND
selectPeps=sortrows(selectPeps);
peptidesPool(1,1:3)=selectPeps(1,1:3); %copy START, END & Charge
peptidesPool(1,7)=selectPeps(1,4); %copy RT

switch scoreSys
    case 1
        maxXscore=selectPeps(1,5); %for X score comparison
        peptidesPool(1,8)=maxXscore;
        m=2;
        for i=2:size(selectPeps,1)
            if (selectPeps(i,1)~=selectPeps(i-1,1) || selectPeps(i,2)~=selectPeps(i-1,2) ...
                    || selectPeps(i,3)~=selectPeps(i-1,3) ) %merge same peptides
                peptidesPool(m,1:3)=selectPeps(i,1:3);
                peptidesPool(m,7)=selectPeps(i,4);
                maxXscore=selectPeps(i,5);
                peptidesPool(m,8)=maxXscore;
                m=m+1;
            else
                if selectPeps(i,5)>maxXscore
                    peptidesPool(m-1,7)=selectPeps(i,4); %RT assigned by the best(lowest P score) peptide
                    peptidesPool(m-1,8)=selectPeps(i,5);
                    maxXscore=selectPeps(i,5);
                end
            end
        end
        
    case 2
        minPscore=selectPeps(1,5); %for P score comparison
        peptidesPool(1,8)=minPscore;
        m=2;
        for i=2:size(selectPeps,1)
            if (selectPeps(i,1)~=selectPeps(i-1,1) || selectPeps(i,2)~=selectPeps(i-1,2) ...
                    || selectPeps(i,3)~=selectPeps(i-1,3) ) %merge same peptides
                peptidesPool(m,1:3)=selectPeps(i,1:3);
                peptidesPool(m,7)=selectPeps(i,4);
                minPscore=selectPeps(i,5);
                peptidesPool(m,8)=minPscore;
                m=m+1;
            else
                if selectPeps(i,5)<minPscore
                    peptidesPool(m-1,7)=selectPeps(i,4); %RT assigned by the best(lowest P score) peptide
                    peptidesPool(m-1,8)=selectPeps(i,5);
                    minPscore=selectPeps(i,5);
                end
            end
        end
end

%%%generate 'peptidesPool' col 4~6:
for i=1:size(peptidesPool,1)
    subSeq=currSeq(peptidesPool(i,1):peptidesPool(i,2));
    [peptideMass, distND, maxND, maxD]=pepinfo(subSeq); %call my function pepinfo.m
    peptidesPool(i,4)=peptideMass/peptidesPool(i,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton
    peptidesPool(i,5)=maxND; %the observable isotope peaks number of this peptide of ND(allH) sample
    peptidesPool(i,6)=maxD; %the exchangable amide hydrogens number of this peptide
    peptidesPool_distND{i}=distND;
end
disp('Done!')

disp(' ')
flag=input('Want to expand peptidesPool by listing all charge states for identified peptides? (1=yes,0=no) ');
if flag==1
    exms_preload_expand %call exms_preload_expand.m 2011-02-27 added
else
    disp('The expansion step is skipped.')
end

h=poolplot1(peptidesPool); %call poolplot1.m
SaveFigureName=[proteinName '_ExMS_preload(' date ')_peptidesPool.fig'];
saveas(h,SaveFigureName)

%%%generate 'peptidesPool_isobaricTable':
disp(' ')
disp('Now program will find all the isobaric peptides in pool.')
mzThreshold=input('Input m/z threshold (in ppm) for finding isobaric peptides (e.g. 20): ');
peptidesPool_isobaricTable=[];
n=1;
for i=1:size(peptidesPool,1)
    START=peptidesPool(i,1);
    END=peptidesPool(i,2);
    Charge=peptidesPool(i,3);
    isobaricPeptides=simpep(START, END, Charge, peptidesPool, 1, mzThreshold); %call simpep.m
    if size(isobaricPeptides,1)>1
        peptidesPool_isobaricTable(n,1:8)=peptidesPool(i,:);
        peptidesPool_isobaricTable(n,9)=i; %index in 'peptidesPool'
        peptidesPool_isobaricTable=sortrows(peptidesPool_isobaricTable,4); %sort by m/z
        n=n+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%'theoryPool' format: col1=START, col2=END, col3=Charge, col4=m/z of mono,
%%%                     col5=maxND, col6=maxD.
clear theoryPool
disp(' ')
flagTheor=input('Want to generate "theoryPool" for finding potential identical peptides outside experimental pool?(1=yes,0=skip)');
if flagTheor==1
    disp('Now program will generate "theoryPool"')
    disp(['Specify the theoryPool to be generated from sequence of ', proteinName,', should cover the experimental pool:'])
    peptideLengthMin=input('Input the minimum peptide length(e.g. 3): ');
    peptideLengthMax=input('Input the maximum peptide length(e.g. 40): ');
    peptideChargeMin=input('Input the minimum peptide charge(e.g. 1): ');
    peptideChargeMax=input('Input the maximum peptide charge(e.g. 5): ');
    mzDetectMin=input('Input the minimum m/z detect limit(e.g. 200): ');
    mzDetectMax=input('Input the maximum m/z detect limit(e.g. 2000): ');
    
    disp('Establishing theoryPool... Please wait!')
    tpCt=0; %theoryPool count
    for i=1:size(currSeq,2)
        for j=peptideLengthMin:peptideLengthMax %peptide length loop
            if i+j-1<=size(currSeq,2) %sequence range check
                subSeq=currSeq(i:i+j-1);
                [peptideMass, distND, maxND, maxD]=pepinfo(subSeq); %call my function pepinfo.m
                for k=peptideChargeMin:peptideChargeMax %peptide charge loop
                    monoMZ=peptideMass/k+1.007276; %1.007276 is the mass of proton
                    if monoMZ>=mzDetectMin && monoMZ<=mzDetectMax %m/z range check
                        theoryPool(tpCt+1,1)=i; %START
                        theoryPool(tpCt+1,2)=i+j-1; %END
                        theoryPool(tpCt+1,3)=k; %Charge
                        theoryPool(tpCt+1,4)=monoMZ; %m/z of mono
                        theoryPool(tpCt+1,5)=maxND; %the observable isotope peaks number of this peptide of ND(allH) sample
                        theoryPool(tpCt+1,6)=maxD; %the exchangable hydrogen number of this peptide
                        tpCt=tpCt+1; %theoryPool count
                    end
                end
            end
        end
    end
    disp('Done!')
    disp(['There are total ', num2str(size(theoryPool,1)), ' peptides in this established theoretical peptide pool.'])
else
    theoryPool=[];
end


%%%save all above variables to a file for later use:
SaveFileName=[proteinName '_ExMS_preload(' date ').mat'];
switch scoreSys
    case 1
        save(SaveFileName,'proteinName','currSeq','MS2FileName','MS2PathName','selectPeps','peptidesPool','peptidesPool_distND','peptidesPool_isobaricTable','theoryPool','flagTheor','XcorrThresholds')
    case 2
        save(SaveFileName,'proteinName','currSeq','MS2FileName','MS2PathName','selectPeps','peptidesPool','peptidesPool_distND','peptidesPool_isobaricTable','theoryPool','flagTheor','PpepThreshold')
end
disp(' ')
disp([SaveFileName, ' & ', SaveFigureName ' has been saved in MATLAB current directory!'])



