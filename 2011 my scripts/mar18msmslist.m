% %%%2010-08-04&05 revised according to most recent exms_preload.m and reduce back the function just for making exclusion list for next MS/MS experiment use
% %%%2010-07-20 revised to expand the function
% %%%2010-07-18 msmslist.m: generate exclusion list from MS/MS Sequest result, modified from exms_preload.m
% 
% disp(' ')
% disp('This program is for making the exclusion list from SEQUEST search result of previous MS/MS run(s):')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%Refer to exms_preload.m:
% 
% %%%first get 'currSeq':
% [headers, sequences] = readfasta('ExMS sequences.fasta'); %call readfast.m
% disp(' ')
% disp('Proteins already in list(ExMS sequences.fasta): ')
% for i=1:size(headers,2)
%     disp(headers{i}(2:end))
% end
% disp(' ')
% proteinName=input('Input the name of your protein (may not in list): ','s');
% flag=0;
% for i=1:size(headers,2)
%     if strcmp(proteinName, headers{i}(2:end))==1
%         currSeq=sequences{i}
%         flag=1;
%     end
% end
% if flag==0
%     disp('Unknown protein!');
%     currSeq=input('Input the sequence of your protein (one row & in capital): ','s')
% end
% clear headers sequences
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%'peptidesPool' format: col1=START, col2=END, col3=Charge, col4=m/z of mono,
% %%%                     col5=maxND, col6=maxD,
% %%%                     col7=RT(unit:min) of best identification in SEQUEST.
% %%%                     col8=Xcorr score of SEQUEST
% disp(' ')
% disp('Now program will generate "peptidesPool"(experimental pool) based on MS/MS experiment results:')
% 
% disp(' ')
% disp('Used which MS/MS peptide search software?')
% disp('1: SEQUEST (result table as OpenOffice converted .csv format)')
% disp('2: SEQUEST (result table as Microsoft Excel converted .csv format)')
% flag=input('Input the number: ');
% disp(' ')
% 
% numMSMS=input('How many MS/MS experiments(result tables of peptide search) to establish the "peptidesPool"?');
% 
% PscoreThreshold=input('Input P score threshold for filtering peptides: (e.g. 0.1) ');
% XcorrThreshold=input('Input Xcorr score thresholds for filtering peptides with different charge states (e.g. [3,3,3,3,3] for +1~(+5&above)): ');
% 
% %%%get 'selectPeps' from SEQUEST results:
% switch flag
%     
%     case 1 %for OpenOffice converted .csv, the old default
%         m=1;
%         clear selectPeps
%         for i=1:numMSMS
%             disp(['Now import SEQUEST result .csv file #', num2str(i)])
%             SequestOutput=struct2cell(uiimport);
%             SequestOutput=SequestOutput{1};
%             for j=4:size(SequestOutput,1) %first 3 rows in .csv file are skipped
%                 SequestPepInfo=SequestOutput{j};
%                 if SequestPepInfo(1)~=',' || size(SequestPepInfo,2)<=17
%                     break %just select the top protein(assume is the target) && avoid last blank rows in .csv file
%                 end
%                 commaPositions=find(SequestPepInfo==',');
%                 SequestPepCharge=str2double(SequestPepInfo((commaPositions(5)+1):(commaPositions(6)-1))); %get z
%                 
%                 comma_P=7; %2010-09-03 added to fix a "bug" in Sequest table("CID" column)
%                 while SequestPepInfo((commaPositions(comma_P)-1))~='"'
%                     comma_P=comma_P+1;
%                 end
%                 SequestPepPscore=str2double(SequestPepInfo((commaPositions(comma_P)+1):(commaPositions(comma_P+1)-1))); %get P score
%               
%                 SequestPepXcorr=str2double(SequestPepInfo((commaPositions(comma_P+1)+1):(commaPositions(comma_P+2)-1))); %get Xcorr score
%                 
%                 if SequestPepPscore<=PscoreThreshold && SequestPepXcorr>=XcorrThreshold(min(SequestPepCharge,5))
%                     SequestPepRTinfo=SequestPepInfo((commaPositions(1)+2):(commaPositions(2)-2));
%                     dashPosition=find(SequestPepRTinfo=='-');
%                     if size(dashPosition,2)==0 %just one RT value, not a range.
%                         SequestPepRT=str2double(SequestPepRTinfo);
%                     else
%                         SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-2))+...
%                             str2double(SequestPepRTinfo(dashPosition+2:end)))/2; %calculate the mean RT.
%                     end
%                     SequestPepSeq=SequestPepInfo((commaPositions(2)+4):(commaPositions(3)-4)); %get sequence
%                     flagExpand=0;
%                     ExpandSeq=SequestPepSeq; %initialize 'ExpandSeq'
%                     if SequestPepInfo(commaPositions(2)+2)~='-' %add left flanking residue help for finding match
%                         ExpandSeq=[SequestPepInfo(commaPositions(2)+2),ExpandSeq];
%                         flagExpand=1; %determine whether the left flanking residue exist
%                     end
%                     if SequestPepInfo(commaPositions(3)-2)~='-' %add right flanking residue help for finding match
%                         ExpandSeq=[ExpandSeq,SequestPepInfo(commaPositions(3)-2)];
%                     end
%                     startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
%                     if size(startPositions,2)==1 %one and only one match found along 'currSeq'
%                         selectPeps(m,1)=startPositions+flagExpand; %START
%                         selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq,2)-1; %END
%                         selectPeps(m,3)=SequestPepCharge; %Charge
%                         selectPeps(m,4)=SequestPepRT; %RT(unit:min)
%                         selectPeps(m,5)=SequestPepPscore; %P score
%                         m=m+1;
%                     end
%                 end
%             end
%         end
%         
%         
%     case 2 %for Microsoft Excel converted .csv 2010-05-12 added
%         m=1;
%         clear selectPeps
%         for i=1:numMSMS
%             disp(['Now import SEQUEST result .csv file #', num2str(i)])
%             SequestOutput=struct2cell(uiimport);
%             if size(SequestOutput,1)==1
%                 SequestOutput=SequestOutput{1};
%             else
%                 SequestOutput=SequestOutput{2};
%             end
%             
%             for j=4:size(SequestOutput,1) %first 3 rows & last row in .csv file are skipped
%                 if size(SequestOutput{j,1},2)>0 && size(SequestOutput{j,1},2)<10
%                     break %just select the top protein (assume is the target protein)
%                 end
%                 
%                 if size(SequestOutput{j,1},1)>0 %all info in the first cell of the row
%                     
%                     SequestPepInfo=SequestOutput{j,1};
%                     commaPositions=find(SequestPepInfo==',');
%                     SequestPepCharge=str2double(SequestPepInfo((commaPositions(5)+1):(commaPositions(6)-1))); %get z
%                     
%                     comma_P=7; %2010-09-03 added to fix a "bug" in Sequest table("CID" column)
%                     if min(size(find(SequestPepInfo(commaPositions(6):commaPositions(7))=='-')))==0
%                         while SequestPepInfo((commaPositions(comma_P)-1))~='"' && SequestPepInfo((commaPositions(comma_P)-1))~='D'
%                             comma_P=comma_P+1;
%                         end
%                     end
%                     SequestPepPscore=str2double(SequestPepInfo((commaPositions(comma_P)+1):(commaPositions(comma_P+1)-1))); %get P score
%                    
%                     SequestPepXcorr=str2double(SequestPepInfo((commaPositions(comma_P+1)+1):(commaPositions(comma_P+2)-1))); %get Xcorr score
%                     
%                     if SequestPepPscore<=PscoreThreshold && SequestPepXcorr>=XcorrThreshold(min(SequestPepCharge,5))
%                         SequestPepRTinfo=SequestPepInfo((commaPositions(1)+1):(commaPositions(2)-1));
%                         dashPosition=find(SequestPepRTinfo=='-');
%                         if size(dashPosition,2)==0 %just one RT value, not a range.
%                             SequestPepRT=str2double(SequestPepRTinfo);
%                         else
%                             SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-1))+...
%                                 str2double(SequestPepRTinfo(dashPosition+1:end)))/2; %calculate the mean RT.
%                         end
%                         SequestPepSeq=SequestPepInfo((commaPositions(2)+3):(commaPositions(3)-3)); %get sequence
%                         flagExpand=0;
%                         ExpandSeq=SequestPepSeq; %initialize 'ExpandSeq'
%                         if SequestPepInfo(commaPositions(2)+1)~='-' %add left flanking residue help for finding match
%                             ExpandSeq=[SequestPepInfo(commaPositions(2)+1),ExpandSeq];
%                             flagExpand=1; %determine whether the left flanking residue exist
%                         end
%                         if SequestPepInfo(commaPositions(3)-1)~='-' %add right flanking residue help for finding match
%                             ExpandSeq=[ExpandSeq,SequestPepInfo(commaPositions(3)-1)];
%                         end
%                         startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
%                         if size(startPositions,2)==1 %one and only one match found along 'currSeq'
%                             selectPeps(m,1)=startPositions+flagExpand; %START
%                             selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq,2)-1; %END
%                             selectPeps(m,3)=SequestPepCharge; %Charge
%                             selectPeps(m,4)=SequestPepRT; %RT(unit:min)
%                             selectPeps(m,5)=SequestPepPscore; %P score
%                             m=m+1;
%                         end
%                     end
%                     
%                 else %%all info NOT in the first cell of the row
%                     
%                     SequestPepCharge=str2double(SequestOutput{j,6}); %get z
%                     SequestPepPscore=str2double(SequestOutput{j,8}); %get P score
%                     SequestPepXcorr=str2double(SequestOutput{j,9}); %get Xcorr score
%                     
%                     if SequestPepPscore<=PscoreThreshold && SequestPepXcorr>=XcorrThreshold(min(SequestPepCharge,5))
%                         SequestPepRTinfo=SequestOutput{j,2};
%                         dashPosition=find(SequestPepRTinfo=='-');
%                         if size(dashPosition,2)==0 %just one RT value, not a range.
%                             SequestPepRT=str2double(SequestPepRTinfo);
%                         else
%                             SequestPepRT=(str2double(SequestPepRTinfo(1:dashPosition-1))+...
%                                 str2double(SequestPepRTinfo(dashPosition+1:end)))/2; %calculate the mean RT.
%                         end
%                         SequestPepSeq=SequestOutput{j,3}; %get sequence
%                         flagExpand=0;
%                         ExpandSeq=SequestPepSeq(3:end-2); %initialize 'ExpandSeq'
%                         if SequestPepSeq(1)~='-' %add left flanking residue help for finding match
%                             ExpandSeq=[SequestPepSeq(1),ExpandSeq];
%                             flagExpand=1; %determine whether the left flanking residue exist
%                         end
%                         if SequestPepSeq(end)~='-' %add right flanking residue help for finding match
%                             ExpandSeq=[ExpandSeq,SequestPepSeq(end)];
%                         end
%                         startPositions=findstr(ExpandSeq, currSeq); %call MATLAB function findstr()
%                         if size(startPositions,2)==1 %one and only one match found along 'currSeq'
%                             selectPeps(m,1)=startPositions+flagExpand; %START
%                             selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq(3:end-2),2)-1; %END
%                             selectPeps(m,3)=SequestPepCharge; %Charge
%                             selectPeps(m,4)=SequestPepRT; %RT(unit:min)
%                             selectPeps(m,5)=SequestPepPscore; %P score
%                             m=m+1;
%                         end
%                     end
%                 end
%             end
%         end
%         
%     otherwise
%         error('Wrong input! Unkown MS/MS peptides search option.')
% end
% 
% disp('Establishing peptidesPool...')
% 
% %%%generate 'peptidesPool' col 1~3&7~8:
% clear peptidesPool peptidesPool_distND
% selectPeps=sortrows(selectPeps);
% peptidesPool(1,1:3)=selectPeps(1,1:3); %copy START, END & Charge
% peptidesPool(1,7)=selectPeps(1,4); %copy RT
% minPscore=selectPeps(1,5); %for P score comparison
% peptidesPool(1,8)=minPscore;
% m=2;
% for i=2:size(selectPeps,1)
%     if (selectPeps(i,1)~=selectPeps(i-1,1) || selectPeps(i,2)~=selectPeps(i-1,2) ...
%             || selectPeps(i,3)~=selectPeps(i-1,3) ) %merge same peptides
%         peptidesPool(m,1:3)=selectPeps(i,1:3);
%         peptidesPool(m,7)=selectPeps(i,4);
%         minPscore=selectPeps(i,5);
%         peptidesPool(m,8)=minPscore;
%         m=m+1;
%     else
%         if selectPeps(i,5)<minPscore
%             peptidesPool(m-1,7)=selectPeps(i,4); %RT assigned by the best(lowest P score) peptide
%             minPscore=selectPeps(i,5);
%         end
%     end
% end
% 
% %%%generate 'peptidesPool' col 4~6:
% for i=1:size(peptidesPool,1)
%     subSeq=currSeq(peptidesPool(i,1):peptidesPool(i,2));
%     [peptideMass, distND, maxND, maxD]=pepinfo(subSeq); %call my function pepinfo.m
%     peptidesPool(i,4)=peptideMass/peptidesPool(i,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton
%     peptidesPool(i,5)=maxND; %the observable isotope peaks number of this peptide of ND(allH) sample
%     peptidesPool(i,6)=maxD; %the exchangable amide hydrogens number of this peptide
%     peptidesPool_distND{i}=distND;
% end
% 
% disp('Done!')
% h=poolplot1(peptidesPool); %call poolplot1.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%generate the exclusion list:

disp(' ')
RTrange=input('Input the RT range (unit: minute) of the MS/MS experiments: (e.g. [0 14]) ');
RTwindow=input('What RT window (unit: minute) to use for the exclusion list? (e.g. 1) ');
disp('Establishing exclusion list...')
msmsList=[];
n=1;
for i=1:size(peptidesPool,1)
    distND=peptidesPool_distND{i};
    for j=1:size(distND,2) %//this part as suggested by Palani 2010-08-05
        if distND(j)>=1*max(distND) %0.2 is the height cutoff used
            msmsList(n,1)=peptidesPool(i,4)+(j-1)*1.00335/peptidesPool(i,3); %%1.00335 is the delta mass between C13(13.00335 u) and C12(12 u)
            msmsList(n,2)=max([0, RTrange(1), peptidesPool(i,7)-RTwindow]);
            msmsList(n,3)=min([RTrange(2), peptidesPool(i,7)+RTwindow]);
            n=n+1;
        end
    end
end
disp('Done!')
msmsList=sortrows(msmsList,1);

SaveTxtFileName=[proteinName,'_',date,'_MSMS Exclusion List.txt'];
save(SaveTxtFileName, 'msmsList', '-ascii', '-tabs')
disp([ SaveTxtFileName ' has been saved in MATLAB current directory!'])









