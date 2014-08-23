%%%2011-09-29 AR: added option to distribute intensity from filtered scans
%%%2011-09-19 AR: added filter to check for uniform mz grids among scans 
%%%2010-05-20 exms_msdataextract.m: changed to current name
%%%2010-02-05 revision: greatly speed up multiple scans data extraction
%%%2010-02-04 revision: correct previous bug (mzRange not included in single scan case)
%%%2010-01-06 newdxms_msdataextract.m: modify msdataextract.m for NEWDXMS
%%%2009-11-18 msdataextract.m

% function scansSumData = exms_msdataextract(extractScansRange, extractMzRange, flagND)

% global mzXMLStruct_H mzXMLStruct_D programSettings
clear scansSumData

mzAcceptRatio=1.1;  %AR: Ratio of accepted mz grid spacing to minimal value, between 1.0 and 1.5 allows for variance
mzMin=extractMzRange(1);
mzMax=extractMzRange(2);

%%%size check:
if mzMin>=mzMax || extractScansRange(1)>extractScansRange(2)
    error('Input ScansRange or mzRange error!')
end

%%%for extract single scan data:
if extractScansRange(1)==extractScansRange(2)
    ScanNum=extractScansRange(1);
    
    if flagND==1
        scanData =[mzXMLStruct_H.scan(ScanNum).peaks.mz(1:2:end), mzXMLStruct_H.scan(ScanNum).peaks.mz(2:2:end)];   %m/z~Int
    else
        scanData =[mzXMLStruct_D.scan(ScanNum).peaks.mz(1:2:end), mzXMLStruct_D.scan(ScanNum).peaks.mz(2:2:end)];   %m/z~Int
    end
    
    n=1;
    scansSumData=[];
    for i=1:size(scanData,1)
        if scanData(i,1)>=mzMin && scanData(i,1)<=mzMax
            scansSumData(n,:)=scanData(i,:);
            n=n+1;
        end
    end
    clear scanData


%%%for multiple scans data
else
    startScanNum=max([1, extractScansRange(1)]);
    if flagND==1
        endScanNum=min([size(mzXMLStruct_H.scan,1), extractScansRange(2)]);
    else
        endScanNum=min([size(mzXMLStruct_D.scan,1), extractScansRange(2)]);
    end
    
    if endScanNum-startScanNum>100 || mzMax-mzMin>100 %display only when there is a lot of data
        disp('Extracting scans data... Please wait!')
    end
    
    scansData=[];
    evalMzData=[];
    expectMz=peakexpect(flagND);  %call peakexpect
    
    for ScanNum=startScanNum:endScanNum
        if flagND==1
            scanData=[mzXMLStruct_H.scan(ScanNum).peaks.mz(1:2:end), mzXMLStruct_H.scan(ScanNum).peaks.mz(2:2:end)];  %m/z~Int
            msLevel=mzXMLStruct_H.scan(ScanNum).msLevel;
        else
            scanData=[mzXMLStruct_D.scan(ScanNum).peaks.mz(1:2:end), mzXMLStruct_D.scan(ScanNum).peaks.mz(2:2:end)];  %m/z~Int
            msLevel=mzXMLStruct_D.scan(ScanNum).msLevel;
        end
        if msLevel==1
            n=1;
            p=1;
            scanSubData=[];
            evalMzSubData=[];
            
            for i=1:size(scanData,1)
                if scanData(i,1)>=mzMin && scanData(i,1)<=mzMax
                    scanSubData(n,:)=[ScanNum, scanData(i,:)];
                    n=n+1;
                    
%                     %AR: Grab data to check mz deviations
%                     if p<=size(expectMz,1) && scanData(i,1)>=expectMz(p)   %&& scanData(i-1,1)<expectMz(p) %Kan
%                         evalMzSubData(p,:)=[ScanNum, expectMz(p), scanData(i,1), scanData(i-1,1)];
%                         p=p+1;
%                     end

                      for p=1:size(expectMz,1)
                          if scanData(i,1)>=expectMz(p) && scanData(i-1,1)<expectMz(p) %Kan
                              evalMzSubData(p,:)=[ScanNum, expectMz(p), scanData(i,1), scanData(i-1,1)];
                          end
                      end
                      
                end
            end
            
			scansData=[scansData; scanSubData];
            evalMzData=[evalMzData; evalMzSubData];
            clear scanSubData evalMzSubData
            
        end
    end
    clear scanData
    
    numScansData=size(scansData,1);
    if numScansData==0 %2010-05-16 added
        scansSumData=[];
        return
    end
    
    allScansList=unique(scansData(:,1));
    
    programSettings.mzSumScanFilter=2; %Kan
    %AR: Option for different summed data output
    switch programSettings.mzSumScanFilter
        case 0  %No filter
            k=1;
            scansData=sortrows([scansData(:,2),scansData(:,3)],1);
            scansSumData(1,:)=scansData(1,:);
            for i=2:numScansData
                if scansData(i,1)~=scansData(i-1,1)
                    k=k+1;
                    scansSumData(k,:)=scansData(i,:);
                else
                    scansSumData(k,2)=scansSumData(k,2)+scansData(i,2);
                end
            end
            clear scansData
        
        
        case {1,2}  %Filter/correct according to most abundant mz grid in scans
            %AR: Find lowest sampled single scan mz point spread
            mzPointSpreads=evalMzData(:,3)-evalMzData(:,4);  %upper mz - lower mz
            mzPointSpread=min(mzPointSpreads);  %assume smallest point spread is real
            
            %AR: Ignore points that are too spread -- peakexpect may search adjacent to 0 intensity
            vettMzData=[];
            listMeasMz=[];
            i=1;
            for evalDex=1:size(evalMzData,1)
                if evalMzData(evalDex,3)-evalMzData(evalDex,4)<mzPointSpread*mzAcceptRatio
                    pointMeasMz=evalMzData(evalDex,2);
                    vettMzData(i,:)=[evalMzData(evalDex,1), pointMeasMz, pointMeasMz-(evalMzData(evalDex,3)+evalMzData(evalDex,4))/2];
                    
                    %AR: Find consistent measure mzs through scans -- assume one exists (safe if deltamass.m is accurate)
                    if vettMzData(i,1)==vettMzData(1,1)  %first scan
                        listMeasMz=[listMeasMz; pointMeasMz];
                        
                    else  %not first scan
                        if vettMzData(i,1)~=vettMzData(i-1,1)  %just moved to new scan
                            prevMeasMz=listMeasMz;
                            listMeasMz=[];
                        end
                        if not(isempty(find(prevMeasMz==pointMeasMz)))  %only add if seen in all previous scans
                            listMeasMz=[listMeasMz; pointMeasMz];
                        end
                    end
                    
                    i=i+1;
                end
            end
            
            %AR: Compute deviation scansStats for each scan
            scansList=unique(vettMzData(:,1));
            scansStats=zeros(size(scansList,1),1);
            for vettDex=1:size(vettMzData,1)
                if not(isempty(find(listMeasMz==vettMzData(vettDex,2))))
                    scanDex=find(scansList==vettMzData(vettDex,1));  %stats paired with scansList index
                    scansStats(scanDex)=scansStats(scanDex)+vettMzData(vettDex,3);  
                end
            end
            
            %AR: Count occurences of each deviation stat
            countStats=[scansStats(1), 1];
            for statDex=2:size(scansStats,1)
                found=0;
                for j=1:size(countStats,1)
                    if countStats(j,1)==scansStats(statDex)
                        countStats(j,2)=countStats(j,2)+1;
                        found=1;
                    elseif found==0 && j==size(countStats,1)
                        countStats=[countStats; scansStats(statDex), 1];
                    end
                end
            end
            
            %AR: Flag good and bad scans
            sortedCountStats=sortrows(countStats,-2);  %descending count, first come first serve if bimodal
            normCountStats=[(sortedCountStats(:,1)-sortedCountStats(1,1)*ones(size(sortedCountStats,1),1))/size(listMeasMz,1), ...
                sortedCountStats(:,2)];
            normCountStats=sortrows(normCountStats,-1);  %descending mz grid deviation, looks prettiest
            scansGood=scansList(find(scansStats==sortedCountStats(1,1)));
            
            j=1;
            k=1;
            scansData=sortrows(scansData,2);
            while isempty(find(scansGood==scansData(j,1),1))   %AR: Requires PRIMER to be from good scan
                j=j+1;
            end
            
            %AR: Nested switch to split filtering from correction
            switch programSettings.mzSumScanFilter
                case 1  %AR: Filter for abundant gridding, no correction to scans
                    scansSumData(k,:)=[scansData(j,2),scansData(j,3)];  %AR: PRIMER
                    for i=j+1:numScansData
                        if not(isempty(find(scansGood==scansData(i,1),1)))  %AR: FILTER
                            if scansData(i,2)~=scansSumData(k,1)
                                k=k+1;
                                scansSumData(k,:)=[scansData(i,2),scansData(i,3)];
                            else
                                scansSumData(k,2)=scansSumData(k,2)+scansData(i,3);
                            end
                        end
                    end
                    
                    clear scansData
                    
                    
                case 2  %AR: Correct scans with rare gridding
                    scansSumData(k,:)=[scansData(j,2),scansData(j,3)];  %AR: PRIMER
                    numFoundGoodScan=0;  %AR: Need mz value of next datapoint
                    
                    for i=j+1:numScansData
                        if not(isempty(find(scansGood==scansData(i,1),1)))  %AR: Uncorrected
                            if scansData(i,2)~=scansSumData(k,1)  %New mz-grid point
                                k=k+1;
                                scansSumData(k,1)=scansData(i,2);
                                scansSumData(k,2)=scansSumData(k,2)+scansData(i,3);
                            else  %Later scan of same mz-grid point
                                scansSumData(k,2)=scansSumData(k,2)+scansData(i,3);
                            end
                            
                        else  %AR: Filtered for correction
                            if i>numFoundGoodScan  %AR: Use previous found good scan unless starting or passed
                                numToGoodScan=1;  %AR: Guess smallest value
                                done=0;
                                if i+numToGoodScan<=numScansData
                                    goodScan=find(scansGood==scansData(i+numToGoodScan,1),1);
                                else
                                    done=1;
                                end
                                while isempty(goodScan) && not(done)  
                                    numToGoodScan=numToGoodScan+1;
                                    if i+numToGoodScan<=numScansData   %AR: Check for end of dataset
                                        goodScan=find(scansGood==scansData(i+numToGoodScan,1),1);  %AR: Nonempty if scan is good
                                    else  %AR: End of the dataset -- ESCAPE
                                        done=1;
                                    end
                                end
                                
                                if not(done)
                                    numFoundGoodScan=i+numToGoodScan;
                                end
                            end
                            
                            if not(done)  %AR: Data surrounded by good mz gridding
                                mzLocalPointSpread=scansData(numFoundGoodScan,2)-scansSumData(k,1);
                                mzDist=scansData(i,2)-scansSumData(k,1);
                                if mzDist<mzLocalPointSpread && mzLocalPointSpread<mzPointSpread*mzAcceptRatio
                                    %AR: Split instensity according to percent distance from mz grid
                                    scansSumData(k,2)=scansSumData(k,2)+scansData(i,3)*(mzLocalPointSpread-mzDist)/mzLocalPointSpread;
                                    if size(scansSumData,1)>k
                                        scansSumData(k+1,2)=scansSumData(k+1,2)+scansData(i,3)*mzDist/mzLocalPointSpread;
                                    else
                                        scansSumData=[scansSumData;0,scansData(i,3)*mzDist/mzLocalPointSpread];
                                    end
                                end
                                
                            else  %AR: Data on right of last good grid point
                                mzLocalPointSpread=scansSumData(k,1)-scansSumData(k-1,1);
                                mzDist=scansData(i,2)-scansSumData(k,1);
                                if mzDist<mzLocalPointSpread && mzLocalPointSpread<mzPointSpread*mzAcceptRatio
                                    scansSumData(k,2)=scansSumData(k,2)+scansData(i,3)*(mzLocalPointSpread-mzDist)/mzLocalPointSpread;
                                end
                            end
                        end
                    end
                    
                    if j>1  %AR: Data on left of first good grid point
                        l=1;
                        mzLocalPointSpread=scansSumData(2,1)-scansSumData(1,1);
                        while scansSumData(1,1)-scansData(l,2)>mzLocalPointSpread  %AR: Prime scansData to relevant data
                            l=l+1;
                        end
                        
                        if mzLocalPointSpread<mzPointSpread*mzAcceptRatio && l<j-1
                            for i=l:j-1  %AR: Up to last point skipped
                                mzDist=scansSumData(1,1)-scansData(i,2);
                                if mzDist<mzLocalPointSpread
                                    scansSumData(1,2)=scansSumData(1,2)+scansData(i,3)*(mzLocalPointSpread-mzDist)/mzLocalPointSpread;
                                end
                            end
                        end
                    end
                    
                    clear scansData
                    
                    
            %AR: Save flagged scans to wholeResults? search at start for flagged scans (if consistent!)
            %numEmptyScans=size(allScansList,1)-size(scansList,1);
            %numUsePeakRatio=size(listMeasMz,1)/size(expectMz,1);
            
            %disp(numUsePeakRatio)
            %disp(size(allScansList,1))
            %disp(numEmptyScans)
            %disp(normCountStats)
            %disp(scansGood)
            
            end
    end
end




