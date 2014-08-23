global mzXMLStruct_H mzXMLStruct_D
close all

flag=input('mzXMLStruct_D in workspace now?(1=yes, 0=no) ');
if flag==0
    %%%establish 'mzXMLStruct_D':
    disp('Select .mzXML file of the D sample...');
    [FileName_D,PathName_D] = uigetfile('*.mzXML','Select the mzXML file');
    mzXMLStruct_D = mzxmlread([PathName_D,FileName_D]); %function from MATLAB Bioinformatics Toolbox
    %%%establish a list of scan number ~ retention time of D sample:
    Scans_RT_list_D=zeros(1,mzXMLStruct_D.mzXML.msRun.scanCount);
    for i=1:mzXMLStruct_D.mzXML.msRun.scanCount
        Scans_RT_list_D(i)=str2double(mzXMLStruct_D.scan(i).retentionTime(3:end-1));    %unit: second
    end
    %%%establish a list of scan number ~ MS level (1 or 2...) of D sample: 2010-02-04 added
    Scans_msLevel_list_D=zeros(1,mzXMLStruct_D.mzXML.msRun.scanCount);
    for i=1:mzXMLStruct_D.mzXML.msRun.scanCount
        Scans_msLevel_list_D(i)=mzXMLStruct_D.scan(i).msLevel;
    end
end


% START=34
% END=37
% CS=2
% intNum=4
% totalScansRange=[585 603];

% START=125
% END=140
% CS=3
% totalScansRange=[490 520]
% intNum=7

% START=104
% END=113
% CS=2
% totalScansRange=[336 354]
% intNum=4

% START=15
% END=25
% CS=1
% totalScansRange=[459 478]
% intNum=4

% START=1
% END=14
% CS=2
% totalScansRange=[213 246]
% intNum=7

START=26
END=34
CS=2
totalScansRange=[516 546]
intNum=7


usedFitLevel=input('Input used fit level#: ');
usedFitAlgo=input('Input used fit algo#: ');
ifCheckEach=input('if check each? (1=yes, 0=no) ');

pepIndex=find(peptidesPool(:,1)==START & peptidesPool(:,2)==END & peptidesPool(:,3)==CS);
monoMZ=peptidesPool(pepIndex,4);
Charge=peptidesPool(pepIndex,3);
maxND=peptidesPool(pepIndex,5);
maxD=peptidesPool(pepIndex,6);
selectPeaks=wholeResults{pepIndex}.selectPeaks;

mzLb=monoMZ-2/Charge;   %3 is arbitrary chosen just to include a little more m/z range.
mzUb=monoMZ+(2+maxND+maxD)/CS;


fillFormSet=[];
DFit_sortSet=[];
for testNum=1:floor((totalScansRange(2)-totalScansRange(1))/intNum)+1
    if testNum==floor((totalScansRange(2)-totalScansRange(1))/intNum)+1
        scansRange=totalScansRange;
    else
        scansRange=[totalScansRange(1)+(testNum-1)*intNum, totalScansRange(1)+testNum*intNum-1];
    end
    msData = exms_msdataextract(scansRange, [mzLb, mzUb], 0);
    msDataSet{testNum}=msData;
    selectData=[];
    [Peaks, PFWHH, PExt]=mspeaks(msData(:,1), msData(:,2), 'PeakLocation', 0); %call mspeaks( ) to re-find peaks
    selectPeaksRawMZ=peakselect(selectPeaks(:,1), Peaks, 20); %call peakselect.m
    selectDataInt=zeros(1,size(selectPeaks,1));
    for i=1:size(selectPeaks,1)
        if selectPeaks(i,2)~=0
            x=find(selectPeaksRawMZ(i)==Peaks(:,1));
            if min(size(x))>0
                xx=find(msData(:,1)>=PExt(x,1) & msData(:,1)<=PExt(x,2));
                selectData=[selectData; msData(xx,:)];
                selectDataInt(i)=trapz(msData(xx,1),msData(xx,2)); %call trapz(): Trapezoidal numerical integration(get the peak volume)
            end
        end
    end
    finalTable(pepIndex,20:(19+size(selectPeaks,1)))=selectDataInt;
    wholeResults{pepIndex}.selectData=selectData;
    
    sep12_msdfit
    
    fillFormSet(testNum,:)=[scansRange, fillForm];
    DFit_sortSet(testNum,:)=[scansRange, DFit_sort];
    
end

SaveFileName=['(SEP13)__',num2str(START),'-',num2str(END),'+',num2str(CS),'_FL',num2str(usedFitLevel),'_Algo',num2str(usedFitAlgo)]; 
save(SaveFileName,'fillFormSet','DFit_sortSet')

hh=figure;
for i=1:testNum
    subplot(testNum,2,i*2-1)
    msData=msDataSet{i};
%     stem(selectPeaks(:,1),max(msData(:,2))*ones(size(selectPeaks,1),1),'y:')
%     hold on
    plot(msData(:,1),msData(:,2),'k')
    hold on
    axis([monoMZ-1/Charge,monoMZ+(maxD+maxND)/CS,0,max(msData(:,2))*1.1])
    if i~=testNum
        set(gca,'xtick',[])
    else
        xlabel('m/z')
    end
    if i~=testNum
        title(['Scan #',num2str(totalScansRange(1)+(i-1)*intNum),'~',num2str(totalScansRange(1)+i*intNum-1)])
    else
        title(['Scan #',num2str(totalScansRange(1)),'~',num2str(totalScansRange(2))])
    end
    
    subplot(testNum,2,i*2)
    DFit_sort=DFit_sortSet(i,3:end);
    stem(1:size(DFit_sort,2), DFit_sort, 'r')
    hold on
    if i~=testNum
        set(gca,'xtick',[])
    else
        xlabel('Fitted Site Number')
    end
    axis([0.5,size(DFit_sort,2)+0.5,0,1])
end

SaveFigureName=[SaveFileName,'_Scans Figure.fig'];
saveas(figure(hh),SaveFigureName)
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    