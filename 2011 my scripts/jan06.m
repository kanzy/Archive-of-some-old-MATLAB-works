%%%2010-08-04 revised
%%%2010-07-08~10 revised, Now use SEQUEST P-score system
%%%2010-05-20 exms_preload.m: changed to current name
%%%2010-02-25, 2010-05-12 revised
%%%2010-01-05 newdxms_preload.m: prepare variables for newdxms.m including: 'proteinName', 'currSeq', 'peptidesPool', 'theoryPool'


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

disp(' ')
disp('Used which MS/MS peptide search software?')
disp('1: SEQUEST (result table as OpenOffice converted .csv format)')
disp('2: SEQUEST (result table as Microsoft Excel converted .csv format)')
% disp('3: MassLynx (result table as .csv format)')
flag=input('Input the number: ');
disp(' ')

numMSMS=input('How many MS/MS experiments(result tables of peptide search) to establish the "peptidesPool"?');

%%%get 'selectPeps' from SEQUEST results:
PscoreThresholds=[NaN NaN]; %to store 'PscoreThreshold1' & 'PscoreThreshold2'
switch flag
    
    case 1 %for OpenOffice converted .csv, the old default
        PscoreThreshold1=input('Input P score threshold for filtering peptides: (e.g. 0.99) ');
        PscoreThresholds(1)=PscoreThreshold1;
        m=1;
        clear selectPeps
        for i=1:numMSMS
            disp(['Now import SEQUEST result .csv file #', num2str(i)])
            SequestOutput=struct2cell(uiimport);
            SequestOutput=SequestOutput{1};
            for j=4:size(SequestOutput,1) %first 3 rows in .csv file are skipped
                SequestPepInfo=SequestOutput{j};
                if SequestPepInfo(1)~=',' || size(SequestPepInfo,2)<=17
                    break %just select the top protein(assume is the target) && avoid last blank rows in .csv file
                end
                commaPositions=find(SequestPepInfo==',');
                SequestPepCharge=str2double(SequestPepInfo((commaPositions(5)+1):(commaPositions(6)-1))); %get z
                
                comma_P=7; %2010-09-03 added to fix a "bug" in Sequest table("CID" column)
                while SequestPepInfo((commaPositions(comma_P)-1))~='"'
                    comma_P=comma_P+1;
                end
                SequestPepPscore=str2double(SequestPepInfo((commaPositions(comma_P)+1):(commaPositions(comma_P+1)-1))); %get P score
                SequestPepXscore=str2double(SequestPepInfo((commaPositions(comma_P+1)+1):(commaPositions(comma_P+2)-1)));
                
                if SequestPepPscore<=PscoreThreshold1 %filter by P score threshold
                    SequestPepRTinfo=SequestPepInfo((commaPositions(1)+2):(commaPositions(2)-2));
                    dashPosition=find(SequestPepRTinfo=='-');
                    if size(dashPosition,2)==0 %just one RT value, not a range.
                        SequestPepRT=str2double(SequestPepRTinfo);
                    else
                        SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-2))+...
                            str2double(SequestPepRTinfo(dashPosition+2:end)))/2; %calculate the mean RT.
                    end
                    SequestPepSeq=SequestPepInfo((commaPositions(2)+4):(commaPositions(3)-4)); %get sequence
                    flagExpand=0;
                    ExpandSeq=SequestPepSeq; %initialize 'ExpandSeq'
                    if SequestPepInfo(commaPositions(2)+2)~='-' %add left flanking residue help for finding match
                        ExpandSeq=[SequestPepInfo(commaPositions(2)+2),ExpandSeq];
                        flagExpand=1; %determine whether the left flanking residue exist
                    end
                    if SequestPepInfo(commaPositions(3)-2)~='-' %add right flanking residue help for finding match
                        ExpandSeq=[ExpandSeq,SequestPepInfo(commaPositions(3)-2)];
                    end
                    startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
                    if size(startPositions,2)==1 %one and only one match found along 'currSeq'
                        selectPeps(m,1)=startPositions+flagExpand; %START
                        selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq,2)-1; %END
                        selectPeps(m,3)=SequestPepCharge; %Charge
                        selectPeps(m,4)=SequestPepRT; %RT(unit:min)
                        selectPeps(m,5)=SequestPepPscore; %P score
                        selectPeps(m,6)=SequestPepXscore; %P score
                        m=m+1;
                    end
                end
            end
        end
        
        
    case 2 %for Microsoft Excel converted .csv 2010-05-12 added
        PscoreThreshold1=input('Input P score threshold for filtering peptides: (e.g. 0.99) ');
        PscoreThresholds(1)=PscoreThreshold1;
        m=1;
        clear selectPeps
        for i=1:numMSMS
            disp(['Now import SEQUEST result .csv file #', num2str(i)])
            SequestOutput=struct2cell(uiimport);
            if size(SequestOutput,1)==1
                SequestOutput=SequestOutput{1}; %for single protein database search
            else
                SequestOutput=SequestOutput{2}; %for multiple proteins database search
            end
            
            for j=4:size(SequestOutput,1) %first 3 rows & last row in .csv file are skipped
                if size(SequestOutput{j,1},2)>0 && size(SequestOutput{j,1},2)<10
                    break %just select the top protein (assume is the target protein)
                end
                
                if size(SequestOutput{j,1},1)>0 %all info in the first cell of the row

                    SequestPepInfo=SequestOutput{j,1};
                    commaPositions=find(SequestPepInfo==',');
                    SequestPepCharge=str2double(SequestPepInfo((commaPositions(5)+1):(commaPositions(6)-1))); %get z
                    
                    comma_P=7; %2010-09-03 added to fix a "bug" in Sequest table("CID" column)
                    if min(size(find(SequestPepInfo(commaPositions(6):commaPositions(7))=='-')))==0
                        while SequestPepInfo((commaPositions(comma_P)-1))~='"' && SequestPepInfo((commaPositions(comma_P)-1))~='D'
                            comma_P=comma_P+1;
                        end
                    end
                    SequestPepPscore=str2double(SequestPepInfo((commaPositions(comma_P)+1):(commaPositions(comma_P+1)-1))); %get P score

                    if SequestPepPscore<=PscoreThreshold1 %filter by P score threshold
                        SequestPepRTinfo=SequestPepInfo((commaPositions(1)+1):(commaPositions(2)-1));
                        dashPosition=find(SequestPepRTinfo=='-');
                        if size(dashPosition,2)==0 %just one RT value, not a range.
                            SequestPepRT=str2double(SequestPepRTinfo);
                        else
                            SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-1))+...
                                str2double(SequestPepRTinfo(dashPosition+1:end)))/2; %calculate the mean RT.
                        end
                        SequestPepSeq=SequestPepInfo((commaPositions(2)+3):(commaPositions(3)-3)); %get sequence
                        flagExpand=0;
                        ExpandSeq=SequestPepSeq; %initialize 'ExpandSeq'
                        if SequestPepInfo(commaPositions(2)+1)~='-' %add left flanking residue help for finding match
                            ExpandSeq=[SequestPepInfo(commaPositions(2)+1),ExpandSeq];
                            flagExpand=1; %determine whether the left flanking residue exist
                        end
                        if SequestPepInfo(commaPositions(3)-1)~='-' %add right flanking residue help for finding match
                            ExpandSeq=[ExpandSeq,SequestPepInfo(commaPositions(3)-1)];
                        end
                        startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
                        if size(startPositions,2)==1 %one and only one match found along 'currSeq'
                            selectPeps(m,1)=startPositions+flagExpand; %START
                            selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq,2)-1; %END
                            selectPeps(m,3)=SequestPepCharge; %Charge
                            selectPeps(m,4)=SequestPepRT; %RT(unit:min)
                            selectPeps(m,5)=SequestPepPscore; %P score
                            m=m+1;
                        end 
                    end
                    
                else %%all info NOT in the first cell of the row
                    
                    SequestPepCharge=str2double(SequestOutput{j,6}); %get z
                    SequestPepPscore=str2double(SequestOutput{j,8}); %get P score
                    if SequestPepPscore<=PscoreThreshold1 %filter by P score threshold
                        SequestPepRTinfo=SequestOutput{j,2};
                        dashPosition=find(SequestPepRTinfo=='-');
                        if size(dashPosition,2)==0 %just one RT value, not a range.
                            SequestPepRT=str2double(SequestPepRTinfo);
                        else
                            SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-1))+...
                                str2double(SequestPepRTinfo(dashPosition+1:end)))/2; %calculate the mean RT.
                        end
                        SequestPepSeq=SequestOutput{j,3}; %get sequence
                        flagExpand=0;
                        ExpandSeq=SequestPepSeq(3:end-2); %initialize 'ExpandSeq'
                        if SequestPepSeq(1)~='-' %add left flanking residue help for finding match
                            ExpandSeq=[SequestPepSeq(1),ExpandSeq];
                            flagExpand=1; %determine whether the left flanking residue exist
                        end
                        if SequestPepSeq(end)~='-' %add right flanking residue help for finding match
                            ExpandSeq=[ExpandSeq,SequestPepSeq(end)];
                        end
                        startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
                        if size(startPositions,2)==1 %one and only one match found along 'currSeq'
                            selectPeps(m,1)=startPositions+flagExpand; %START
                            selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq(3:end-2),2)-1; %END
                            selectPeps(m,3)=SequestPepCharge; %Charge
                            selectPeps(m,4)=SequestPepRT; %RT(unit:min)
                            selectPeps(m,5)=SequestPepPscore; %P score
                            m=m+1;
                        end
                    end
                end
            end
        end
        
%     case 3 %for MassLynx generated .csv 2010-05-12 added
%         scoreThresholds=input('Input score thresholds for different charge states of peptides (e.g. [1,1,1,1,1] for +1~(+5&above)): ');
%         m=1;
%         clear selectPeps
%         for i=1:numMSMS
%             disp(['Now import MassLynx result .csv file #', num2str(i)])
%             MassLynx=uiimport;
%             for j=1:size(MassLynx.data,1)
%                 pepCharge=round(str2double(MassLynx.textdata{j+1,3})); %get z
%                 pepScore=str2double(MassLynx.textdata{j+1,7}); %get score
%                 if pepScore>=scoreThresholds(min(pepCharge,5)) %filter by Xcorr score threshold
%                     pepRT=str2double(MassLynx.textdata{j+1,11}); %get RT, unit: min
%                     pepSeq=MassLynx.textdata{j+1,10};
%                     flagExpand=0;
%                     ExpandSeq=pepSeq(4:end-3); %initialize 'ExpandSeq'
%                     if pepSeq(2)~='-' %add left flanking residue help for finding match
%                         ExpandSeq=[pepSeq(2),ExpandSeq];
%                         flagExpand=1; %determine whether the left flanking residue exist
%                     end
%                     if pepSeq(end-1)~='+' %add right flanking residue help for finding match
%                         ExpandSeq=[ExpandSeq,pepSeq(end-1)];
%                     end
%                     startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
%                     if size(startPositions,2)==1 %one and only one match found along 'currSeq'
%                         selectPeps(m,1)=startPositions+flagExpand; %START
%                         selectPeps(m,2)=selectPeps(m,1)+size(pepSeq,2)-1; %END
%                         selectPeps(m,3)=pepCharge; %Charge
%                         selectPeps(m,4)=pepRT; %RT(unit:min)
%                         selectPeps(m,5)=pepScore; %score
%                         m=m+1;
%                     end
%                 end
%             end
%         end
        
    otherwise
        error('Wrong input! Unkown MS/MS peptides search option.')
end

disp('Establishing peptidesPool...')

%%%generate 'peptidesPool' col 1~3&7~8:
clear peptidesPool peptidesPool_distND
selectPeps=sortrows(selectPeps);
peptidesPool(1,1:3)=selectPeps(1,1:3); %copy START, END & Charge
peptidesPool(1,7)=selectPeps(1,4); %copy RT
minPscore=selectPeps(1,5); %for P score comparison
peptidesPool(1,8)=minPscore;
peptidesPool(1,9)=selectPeps(1,6);
m=2;
for i=2:size(selectPeps,1)
    if (selectPeps(i,1)~=selectPeps(i-1,1) || selectPeps(i,2)~=selectPeps(i-1,2) ...
            || selectPeps(i,3)~=selectPeps(i-1,3) ) %merge same peptides
        peptidesPool(m,1:3)=selectPeps(i,1:3);
        peptidesPool(m,7)=selectPeps(i,4);
        minPscore=selectPeps(i,5);
        peptidesPool(m,8)=minPscore;
        peptidesPool(m,9)=selectPeps(i,6);
        m=m+1;
    else
        if selectPeps(i,5)<minPscore
            peptidesPool(m-1,7)=selectPeps(i,4); %RT assigned by the best(lowest P score) peptide
            minPscore=selectPeps(i,5);
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

%%%generate 'peptidesPool_isobaricTable':
mzThreshold=20; %0.01 should work the same
peptidesPool_isobaricTable=[];
n=1;
for i=1:size(peptidesPool,1)
    START=peptidesPool(i,1);
    END=peptidesPool(i,2);
    Charge=peptidesPool(i,3);
    isobaricPeptides=simpep(START, END, Charge, peptidesPool, 1, mzThreshold); %call simpep.m
    if size(isobaricPeptides,1)>1
        peptidesPool_isobaricTable(n,1:9)=peptidesPool(i,:);
        peptidesPool_isobaricTable(n,10)=i; %index in 'peptidesPool'
        peptidesPool_isobaricTable=sortrows(peptidesPool_isobaricTable,4); %sort by m/z
        n=n+1;
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2010 July optional part
% %%%Additional code for removing relative bad isobaric peptides from peptidesPool: //SEEMS NOT NECESSARY
%
% %%%generate 'peptidesPool_isobaricSets':
% if size(peptidesPool_isobaricTable,1)>0
%     isobaricSets={};
%     m=1;
%     n=1;
%     for i=1:size(peptidesPool_isobaricTable,1)
%         if i==1
%             isobaricSets{m}(n,:)=peptidesPool_isobaricTable(i,:);
%             n=n+1;
%         else
%             diff=abs(peptidesPool_isobaricTable(i,4)-peptidesPool_isobaricTable(i-1,4));
%             if diff<=mzThreshold
%                 isobaricSets{m}(n,:)=peptidesPool_isobaricTable(i,:);
%                 n=n+1;
%             else
%                 m=m+1;
%                 n=1;
%                 isobaricSets{m}(n,:)=peptidesPool_isobaricTable(i,:);
%                 n=n+1;
%             end
%         end
%     end
%     M=m; %number of isobaric peptide groups
% else
%     M=0;
% end
%
% %%%remove bad isobaric peptides from peptidesPool:
% if flag==1 || flag==2 %now just for SEQUEST
%     if M>0 %there are still isobaric peptides in the pool
%         PscoreThreshold2=input('Input P score threshold for removing incorrect isobaric peptides: (e.g. 0.01) ');
%         PscoreThresholds(2)=PscoreThreshold2;
%         %%%get 'removeIndex':
%         removeIndex=[];
%         x=1;
%         for i=1:M
%             isobaricSet=isobaricSets{i};
%             isobaricSet=sortrows(isobaricSet,8);
%             if isobaricSet(1,8)>PscoreThreshold2 %all bad & to be removed
%                 for j=1:size(isobaricSet,1)
%                     removeIndex(x)=isobaricSet(j,9);
%                     x=x+1;
%                 end
%             else
%                 if isobaricSet(2,8)>PscoreThreshold2 || abs(isobaricSet(1,7)-isobaricSet(2,7))<0.5 %only keep the best one
%                     for j=2:size(isobaricSet,1)
%                         removeIndex(x)=isobaricSet(j,9);
%                         x=x+1;
%                     end
%                 else %keep two good isobaric peptides
%                     if size(isobaricSet,1)>2
%                         for j=3:size(isobaricSet,1)
%                             removeIndex(x)=isobaricSet(j,9);
%                             x=x+1;
%                         end
%                     end
%                 end
%             end
%         end
%         %%%get new 'peptidesPool':
%         peptidesPool_raw=peptidesPool;
%         peptidesPool_distND_raw=peptidesPool_distND;
%         peptidesPool=[];
%         peptidesPool_distND={};
%         n=1;
%         for i=1:size(peptidesPool_raw,1)
%             if size(find(removeIndex==i),2)==0 %filter by 'removeIndex'
%                 peptidesPool(n,:)=peptidesPool_raw(i,:);
%                 peptidesPool_distND{n}=peptidesPool_distND_raw{i};
%                 n=n+1;
%             end
%         end
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2010 July optional part
% 
disp('Done!')
% h=poolplot1(peptidesPool); %call poolplot1.m
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%'theoryPool' format: col1=START, col2=END, col3=Charge, col4=m/z of mono,
% %%%                     col5=maxND, col6=maxD.
% clear theoryPool
% disp(' ')
% flagTheor=input('Want to generate "theoryPool" for finding potential identical peptides outside experimental pool?(1=yes,0=skip)');
% if flagTheor==1
%     disp('Now program will generate "theoryPool"')
%     disp(['Specify the theoryPool to be generated from sequence of ', proteinName,', should cover the experimental pool:'])
%     peptideLengthMin=input('Input the minimum peptide length(e.g. 3): ');
%     peptideLengthMax=input('Input the maximum peptide length(e.g. 40): ');
%     peptideChargeMin=input('Input the minimum peptide charge(e.g. 1): ');
%     peptideChargeMax=input('Input the maximum peptide charge(e.g. 5): ');
%     mzDetectMin=input('Input the minimum m/z detect limit(e.g. 200): ');
%     mzDetectMax=input('Input the maximum m/z detect limit(e.g. 2000): ');
%     
%     disp('Establishing theoryPool... Please wait!')
%     tpCt=0; %theoryPool count
%     for i=1:size(currSeq,2)
%         for j=peptideLengthMin:peptideLengthMax %peptide length loop
%             if i+j-1<=size(currSeq,2) %sequence range check
%                 subSeq=currSeq(i:i+j-1);
%                 [peptideMass, distND, maxND, maxD]=pepinfo(subSeq); %call my function pepinfo.m
%                 for k=peptideChargeMin:peptideChargeMax %peptide charge loop
%                     monoMZ=peptideMass/k+1.007276; %1.007276 is the mass of proton
%                     if monoMZ>=mzDetectMin && monoMZ<=mzDetectMax %m/z range check
%                         theoryPool(tpCt+1,1)=i; %START
%                         theoryPool(tpCt+1,2)=i+j-1; %END
%                         theoryPool(tpCt+1,3)=k; %Charge
%                         theoryPool(tpCt+1,4)=monoMZ; %m/z of mono
%                         theoryPool(tpCt+1,5)=maxND; %the observable isotope peaks number of this peptide of ND(allH) sample
%                         theoryPool(tpCt+1,6)=maxD; %the exchangable hydrogen number of this peptide
%                         tpCt=tpCt+1; %theoryPool count
%                     end
%                 end
%             end
%         end
%     end
%     disp('Done!')
%     disp(['There are total ', num2str(size(theoryPool,1)), ' peptides in this established theoretical peptide pool.'])
% else
%     theoryPool=[];
% end
% 
% 
% %%%save all above variables to a file for later use:
% SaveFileName=[proteinName '_ExMS_preload(' date ').mat'];
% if flag==1 || flag==2 %for SEQUEST
%     save(SaveFileName,'proteinName','currSeq','peptidesPool','peptidesPool_distND','theoryPool','flagTheor','PscoreThresholds')
% % else %for MassLynx
% %     save(SaveFileName,'proteinName','currSeq','peptidesPool','peptidesPool_distND','peptidesPool_isobaricTable','theoryPool','flagTheor','scoreThresholds')
% end
% SaveFigureName=[proteinName '_ExMS_preload(' date ')_peptidesPool.fig'];
% saveas(h,SaveFigureName)
% disp(' ')
% disp([SaveFileName, ' & ', SaveFigureName ' has been saved in MATLAB current directory!'])
% 
% 
% 
% 
% 
% 
% 
