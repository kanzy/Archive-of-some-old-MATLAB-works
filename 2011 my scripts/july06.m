%%%july06.m: compare fillType 1 vs 2 of finalTable(20:end)
%%%2010-08-17 exms_whole_check_common.m: A common part in exms_whole_check.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%below is the finer method for filling finalTable(20:end): 2011-07-04 revised from msdfit_msdataextract.m and msdfit_msdataselect.m
if flagND==1 %for allH sample
    global mzXMLStruct_H
    %%establish 'mzXMLStruct_H':
    disp('Select .mzXML file of the ND(allH) sample...');
    [FileName_H,PathName_H] = uigetfile('*.mzXML','Select the mzXML file');
    mzXMLStruct_H = mzxmlread([PathName_H,FileName_H]); %function from MATLAB Bioinformatics Toolbox
else %for D sample
    global mzXMLStruct_D
    %%establish 'mzXMLStruct_D':
    disp('Select .mzXML file of the D sample...');
    [FileName_D,PathName_D] = uigetfile('*.mzXML','Select the mzXML file');
    mzXMLStruct_D = mzxmlread([PathName_D,FileName_D]); %function from MATLAB Bioinformatics Toolbox
end


finalTable_old=finalTable;


for checkNum=1:size(peptidesPool,1)
    if finalTable(checkNum,12)>=1
        
        Charge=finalTable(checkNum,3);
        monoMZ=finalTable(checkNum,4);
        maxND=peptidesPool(checkNum,5);
        maxD=peptidesPool(checkNum,6);
        selectPeaks=wholeResults{checkNum}.selectPeaks;
        
        mzMin=monoMZ-3/Charge;   %3 is arbitrary chosen just to include a little more m/z range.
        mzMax=monoMZ+(3+maxND+maxD)/Charge;
        
        startScanNum=finalTable(checkNum,5);
        endScanNum=finalTable(checkNum,6);
        if startScanNum>endScanNum || min(startScanNum, endScanNum)==0
            error('Something is wrong with finalTable col 5 & 6 !')
        end
        
        scansData=[];
        for ScanNum=startScanNum:endScanNum
            if flagND==1
                scanData=[mzXMLStruct_H.scan(ScanNum).peaks.mz(1:2:end), mzXMLStruct_H.scan(ScanNum).peaks.mz(2:2:end)];   %m/z~Int
                msLevel=mzXMLStruct_H.scan(ScanNum).msLevel;
            else
                scanData=[mzXMLStruct_D.scan(ScanNum).peaks.mz(1:2:end), mzXMLStruct_D.scan(ScanNum).peaks.mz(2:2:end)];   %m/z~Int
                msLevel=mzXMLStruct_D.scan(ScanNum).msLevel;
            end
            if msLevel==1
                n=1;
                scanSubData=[];
                for i=1:size(scanData,1)
                    if scanData(i,1)>=mzMin && scanData(i,1)<=mzMax
                        scanSubData(n,:)=scanData(i,:);
                        n=n+1;
                    end
                end
                scansData=[scansData; scanSubData];
                clear scanSubData
            end
        end
        clear scanData
        
        if size(scansData,1)==0 %2010-05-16 added
            msData=[];
            return
        end
        scansData=sortrows(scansData,1);
        
        msData=[]; %'msData' is the old 'scansAveData'
        k=1;
        msData(1,:)=scansData(1,:);
        for i=2:size(scansData,1)-1
            if scansData(i,1)~=scansData(i-1,1)
                k=k+1;
                msData(k,:)=scansData(i,:);
            else
                msData(k,2)=msData(k,2)+scansData(i,2);
            end
        end
        clear scansData
        
        msData(:,2)=msData(:,2)/(endScanNum-startScanNum+1);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%find peaks in data:
        [Peaks, PFWHH, PExt]=mspeaks(msData(:,1), msData(:,2), 'PeakLocation', 0); %call mspeaks( )
        
        mzThreshold=programSettings.mzThreshold2;
        [selectPeaksRawMZ, selectPeaks(:,2)]=peakselect(selectPeaks(:,1), Peaks, mzThreshold); %call peakselect.m
        
        %%%get 'selectData':
        peakDataSelectType=2; %1=FWHH; 2=Ext(full); 3=mix1&2
        peakDataIntType=2; %1=simple sum(only right for evenly spacing); 2=Trapezoidal numerical integration(get the peak volume)
        % selectData=[];
        selectDataInt=zeros(1,size(selectPeaks,1));
        for i=1:size(selectPeaks,1)
            x=find(selectPeaksRawMZ(i)==Peaks(:,1));
            if min(size(x))>0
                switch peakDataSelectType
                    case 1
                        xx=find(msData(:,1)>=PFWHH(x,1) & msData(:,1)<=PFWHH(x,2));
                    case 2
                        xx=find(msData(:,1)>=PExt(x,1) & msData(:,1)<=PExt(x,2));
                    case 3
                        xx=find(msData(:,1)>=(PFWHH(x,1)+PExt(x,1))/2 & msData(:,1)<=(PFWHH(x,2)+PExt(x,2))/2);
                end
                %         selectData=[selectData; msData(xx,:)];
                switch peakDataIntType
                    case 1
                        selectDataInt(i)=sum(msData(xx,2));
                    case 2
                        selectDataInt(i)=trapz(msData(xx,1),msData(xx,2)); %use trapz()
                end
            end
        end
        
        sizer=size(selectPeaks,1);
        finalTable(checkNum,20:(19+sizer))=selectDataInt;
        
        
        close all
        figure
        plot(msData(:,1), msData(:,2)/max(msData(:,2)), 'k')
        hold on
        stem(selectPeaks(:,1), finalTable_old(checkNum,20:(19+sizer))/max(finalTable_old(checkNum,20:(19+sizer))),'b')
        hold on
        stem(selectPeaks(:,1), finalTable(checkNum,20:(19+sizer))/max(finalTable(checkNum,20:(19+sizer))),'r')
        v=axis;
        axis([selectPeaks(1,1)-1, selectPeaks(end,1)+1, v(3), v(4)*1.1])
        
        disp(' ')
        checkNum
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    end
end































