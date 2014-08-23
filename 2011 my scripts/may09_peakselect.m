%%%2010-05-16 revision: add ouput 'selectPeaksRawMZ'
%%%2010-01-22 peakselect.m: renamed and change the output, now may be called by multiple common places. 
%%%2010-01-21 newdxms_sa_leland_inter.m: should be called by newdxms_sa_leland.m

function [selectPeaksRawMZ, selectPeaksInten]=may09_peakselect(selectPositions, expPeaks, mzThresholdAbs)

mzWeight=100; %weight coefficent of m/z closeness: exp(mzDiff*mzWeight)

selectPeaksRawMZ=zeros(size(selectPositions)); %2010-05-16 added, to store selectPeaks original m/z values
selectPeaksInten=zeros(size(selectPositions)); %'selectPositions' should be a column vector, so is 'selectPeaksInten'
for i=1:size(selectPositions,1)
    peaksIndices=find(abs(selectPositions(i,1)-expPeaks(:,1))<mzThresholdAbs); %search by m/z closeness
    if size(peaksIndices,1)>0 %peak found!
        candidatePeaks=expPeaks(peaksIndices,:);
        maxScore=0;
        for k=1:size(candidatePeaks,1)
            mzDiff=abs(selectPositions(i,1)-candidatePeaks(k,1));
            currScore=candidatePeaks(k,2)/exp(mzDiff*mzWeight);
            if currScore>maxScore
                selectPeaksRawMZ(i,1)=candidatePeaks(k,1);  %2010-05-16 added
                selectPeaksInten(i,1)=candidatePeaks(k,2);
                maxScore=currScore;
            end
        end
    end
end


% %%%2010-05-16 test revision for low-resolution data 
% selectPeaksRawMZ=zeros(size(selectPositions));
% selectPeaksInten=zeros(size(selectPositions)); %'selectPositions' should be a column vector, so is 'selectPeaksInten'
% for i=1:size(selectPositions,1)
%     peaksIndices=find(abs(selectPositions(i,1)-expPeaks(:,1))<mzThreshold); %search by m/z closeness
%     if size(peaksIndices,1)>0 %peak found!
%         candidatePeaks=expPeaks(peaksIndices,:);
%         selectPeaksRawMZ(i,1)=centroid(candidatePeaks);
%         selectPeaksInten(i,1)=sum(candidatePeaks(:,2));
%     end
% end

