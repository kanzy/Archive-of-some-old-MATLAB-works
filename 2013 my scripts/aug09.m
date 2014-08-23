%%%from dsms.m

featureRTthreshold=1; %unit: minutes
precursorRTwindow=30; %unit: seconds
mzThreshold0=15; %ppm //20 probably is necessary (known from 2013July04 test run on MDTCS 20130620 data), but 15 might be the best setting (to avoid too many false positive matches)
MS2Threshold=0.1; %amu //for dsms_sequest.m use

%%%make 'FeatureList' & 'FeatureListMerge':
FeatureList=NaN*zeros(size(Features,2),5);
for i=1:size(Features,2)
    if ~isfield(Features{i},'scanSet') %2013-05-20 added
        break
    end
    scanSet=Features{i}.scanSet;
    mzSet=Features{i}.mzSet;
    CS=Features{i}.CS;
    FeatureList(i,1)=i; %index in 'Features'
    FeatureList(i,2)=mzSet(1); %assume mono m/z
    FeatureList(i,3)=CS; %charge state
    FeatureList(i,4)=Peaklist_TimeIndex(scanSet(1))/60; %start RT (unit:min)
    FeatureList(i,5)=Peaklist_TimeIndex(scanSet(end))/60; %end RT
end
FeatureListSort=sortrows(FeatureList,2:5);
n=1;
FeatureListMerge=FeatureListSort;
for i=2:size(FeatureListSort,1)
    if abs(FeatureListSort(i,2)-FeatureListMerge(n,2))<mzThreshold*FeatureListMerge(n,2) && FeatureListSort(i,3)==FeatureListMerge(n,3)
        if FeatureListSort(i,4)-FeatureListMerge(n,5)>featureRTthreshold || FeatureListMerge(n,4)-FeatureListSort(i,5)>featureRTthreshold %if too far apart, take as two different features
            n=n+1;
            FeatureListMerge(n,:)=FeatureListSort(i,:);
        else %merge as one feature
            FeatureListMerge(n,2)=(FeatureListSort(i,2)+FeatureListMerge(n,2))/2; %use mean m/z
            FeatureListMerge(n,4)=min(FeatureListSort(i,4), FeatureListMerge(n,4));
            FeatureListMerge(n,5)=max(FeatureListSort(i,5), FeatureListMerge(n,5)); %merge RT
        end
    else %different feature
        n=n+1;
        FeatureListMerge(n,:)=FeatureListSort(i,:);
    end
end
FeatureListMerge=FeatureListMerge(1:n,:);

List1=FeatureListMerge(1:131,:);
List1=sortrows(FeatureList1,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

List2=flipdim(sortrows(RNaseAallHMSMS1,3),1);

figure
for i=1:size(List1,1)
    monoMZ=List1(i,2);
    RT=60*List1(i,4:5);
    CS=List1(i,3);
    
    plot(RT,[monoMZ,monoMZ],'b')
    hold on
    text(RT(2),monoMZ,num2str(CS),'Color','b')
    hold on
end
for i=1:size(List2,1)
    monoMZ=List2(i,2);
    RT=List2(i,9:10);
    CS=List2(i,4);
    
    plot(RT,[monoMZ,monoMZ],'r')
    hold on
    text(RT(2),monoMZ,num2str(CS),'Color','r')
    hold on
end

















