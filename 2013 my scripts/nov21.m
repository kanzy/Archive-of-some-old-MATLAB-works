
%%%pre-load: (18-Nov-2013_102to125)_HDsite_batAnalysis_sampleSet(only keep 1st CS plus manual removed noisy pep).mat

%%%pre-run:
allPeps=[];
for i=1:11
    allPeps=[allPeps; usePepsSet{i}];
end
allPeps=sortrows(unique(allPeps,'rows'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
totalSampleNum=input('How many samples to be run in sequence (It should be all-D control + HX time points): ');

finalTableSet=cell(1,totalSampleNum);
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
    finalTableSet{currSampleNum}=finalTable;
end



HXtimes=[10 60 300 1500 6000 26220 107700 259200 518400 1229400 2339400]

figure
finalTable1=finalTableSet{1};
for i=1:30
    subplot(5,6,i)
    xx=find(finalTable1(:,1)==allPeps(i,1) & finalTable1(:,2)==allPeps(i,2) & finalTable1(:,3)==allPeps(i,3));
    
    n=0;
    meanPoints=[];
    minPoint=100;
    maxPoint=0;
    for j=1:11
        currHXtime=HXtimes(j);
        finalTable=finalTableSet{j};
        if finalTable(xx,12)>=1
            n=n+1;
            
            START=finalTable(xx,1);
            END=finalTable(xx,2);
            CS=finalTable(xx,3);
            RT=finalTable(xx,7:8);
            
            minPoint=min([minPoint, min(RT)]);
            maxPoint=max([maxPoint, max(RT)]);
            
            semilogx([currHXtime currHXtime], RT, 'r')
            hold on
            
            meanPoints(n,1)=currHXtime;
            meanPoints(n,2)=mean(RT);
        end
    end
    
    semilogx(meanPoints(:,1), meanPoints(:,2), 'k:')
    hold on
    
    axis([3, max(HXtimes)*3, minPoint-0.1, maxPoint+0.1])
    set(gca,'XTick',[100,1e4,1e6])
    set(gca,'XTickLabel',{'1e2','1e4','1e6'})
    
    title([num2str(START), '-' , num2str(END), ' +', num2str(CS)],'FontWeight','bold')
    
    if i==27
        xlabel('HX Time (sec)')
    end
    
    if i==13
        ylabel('RT (min)')
    end
    
end






