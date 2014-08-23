%%%2012-10-24 oct24.m: revised from exms_preload.m for processing the Excel file given by Sierra Analytic

proteinName='ATMTAN';

XN=2;
currSeq='GSHMAPHGDGLSDIEEPEVDAQSEILRPISSVVFVIAMQAEALPLVNKFGLSETTDSPLGKGLPWVLYHGVHKDLRINVVCPGRDAALGIDSVGTVPASLITFASIQALKPDIIINAGTCGGFKVKGANIGDVFLVSDVVFHDRRIPIPMFDLYGVGLRQAFSTPNLLKELNLKIGRLSTGDSLDMSTQDETLIIANDATLKDMEGAAVAYVADLLKIPVVFLKAVTDLVDGDKPTAEEFLQNLTVVTAALEGTATKVINFINGRNLSDL';
[MS2FileName,MS2PathName] = uigetfile('*.xls','Select the Excel file');
[num,txt,SequestOutput] = xlsread([MS2PathName,MS2FileName]);

XcorrThresholds=input('Input Xcorr score thresholds for different charge states of peptides (e.g. [1,1,2,3,4] for +1~(+5&above)): ');
selectPeps=[];
m=1;
for j=2:size(SequestOutput,1) %first 3 rows in .csv file are skipped
    
    SequestPepCharge=SequestOutput{j,2}; %get z
    SequestPepXscore=SequestOutput{j,4}; %get XCorr score
    
    flag = (SequestPepXscore>=XcorrThresholds(min(SequestPepCharge,5))); %filter by Xcorr score threshold

    if flag==1
        SequestPepRT=SequestOutput{j,3};
        SequestPepSeq=SequestOutput{j,1}; %get sequence
        startPositions=strfind(currSeq, SequestPepSeq); %call MATLAB function strfind() //2011-07-06 revised
        if size(startPositions,2)==1 %one and only one match found along 'currSeq'
            selectPeps(m,1)=startPositions; %START
            selectPeps(m,2)=selectPeps(m,1)+size(SequestPepSeq,2)-1; %END
            selectPeps(m,3)=SequestPepCharge; %Charge
            selectPeps(m,4)=SequestPepRT; %RT(unit:min)
            selectPeps(m,5)=SequestPepXscore; %Xcorr score
            m=m+1;
        end
    end
end


%%%generate 'peptidesPool' col 1~3&7~8:
clear peptidesPool peptidesPool_distND
selectPeps=sortrows(selectPeps);
peptidesPool(1,1:3)=selectPeps(1,1:3); %copy START, END & Charge
peptidesPool(1,7)=selectPeps(1,4); %copy RT

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
                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%generate 'peptidesPool' col 4~6:
for i=1:size(peptidesPool,1)
    subSeq=currSeq(peptidesPool(i,1):peptidesPool(i,2));
    [peptideMass, distND, maxND, maxD]=pepinfo(subSeq, XN); %call my function pepinfo.m
    peptidesPool(i,4)=peptideMass/peptidesPool(i,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton
    peptidesPool(i,5)=maxND; %the observable isotope peaks number of this peptide of ND(allH) sample
    peptidesPool(i,6)=maxD; %the exchangable amide hydrogens number of this peptide
    peptidesPool_distND{i}=distND;
end
disp('Done!')

% disp(' ')
% flag=input('Want to expand peptidesPool by listing all charge states for identified peptides? (1=yes,0=no) ');
% if flag==1
%     exms_preload_expand %call exms_preload_expand.m 2011-02-27 added
% else
%     disp('The expansion step is skipped.')
% end

h=poolplot1(peptidesPool); %call poolplot1.m
SaveFigureName=[proteinName '_ExMS_preload(Oct24 SierraTest)_peptidesPool.fig'];
saveas(h,SaveFigureName)

flagTheor=0; 

%%%save all above variables to a file for later use:
SaveFileName=[proteinName '_ExMS_preload(Oct24 SierraTest).mat'];
save(SaveFileName,'proteinName','currSeq','MS2FileName','MS2PathName','selectPeps','peptidesPool','peptidesPool_distND','XcorrThresholds','flagTheor')
 
disp(' ')
disp([SaveFileName, ' & ', SaveFigureName ' has been saved in MATLAB current directory!'])
