%%%nov02b.m: for Nov02 Tests Plot 2

figure
m=0;
deltaRT=[];
deltaDeltaD=[];
for i=54:57 %86:89 %71:74 %61:65 %1:size(finalTable,1)
    
    if finalTable716(i,1)~=finalTable721(i,1) || finalTable716(i,2)~=finalTable721(i,2) || finalTable716(i,3)~=finalTable721(i,3)
        error('Not match!')
    end
    
    if finalTable716(i,12)>=1 && finalTable721(i,12)>=1
        
        m=m+1;
    
        START=finalTable(i,1);
        END=finalTable(i,2);
        CS=finalTable(i,3);
        
%         deltaD=finalTable(i,10);
        %%%2013-10-28 corrected:
        [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), 2);
        
        deltaD1=(finalTable716(i,9)-finalTable716(i,4))*CS-centroid([(0:size(distND,2)-1)',distND']);
        deltaD2=(finalTable721(i,9)-finalTable721(i,4))*CS-centroid([(0:size(distND,2)-1)',distND']);
        
        deltaDeltaD(m)=deltaD2-deltaD1;
        
%         pepIntens(i)=sum(finalTable(i,20:end)); %2013-10-28 added
%         pepLens(i)=END-START+1;
        
        meanRT1=mean(finalTable716(i,7:8));
        meanRT2=mean(finalTable721(i,7:8));
        
        deltaRT(m)=meanRT2-meanRT1;
        
        plot(meanRT1, deltaD1, 'bo')
        hold on
        plot(meanRT2, deltaD2, 'ro')
        hold on
        plot([meanRT1, meanRT2], [deltaD1, deltaD2], 'k:')
        hold on
        
        text(meanRT1,deltaD1, num2str(i));
        hold on

    end
end

xlabel('Experimental Mean RT (min)')
ylabel('Experimental delta D)')
title('WB two all-D data: Blue=July16, Red=July21')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(1,2,1)
hist(deltaRT)
title('Distribution of MeanRT(721) - MeanRT(716)')
subplot(1,2,2)
hist(deltaDeltaD)
title('Distribution of deltaD(721) - deltaD(716)')












