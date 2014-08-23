
record=[];
record2=[]; %just for real 

wholeResults=wholeResults_HSP_D;
figure
for i=1:size(wholeResults,1)
    m=size(wholeResults{i}.findScansRanges,1);
    stem(i,m)
    hold on
    if m>0
        skipTests=wholeResults{i}.skipTests;
        record=[record; [repmat(peptidesPool(i,1:3),size(skipTests,1),1) skipTests]];
        
        if finalTable(i,12)<1 
            record2=[record2; [repmat(peptidesPool(i,1:3),size(skipTests,1),1) skipTests]];
        end
    end
end

ratio=zeros(1,6);
for i=1:6
    ratio(i)=100*(1-sum(record(:,i+3))/size(record,1));
end

ratio


n=zeros(1,7);
for i=1:size(record,1)
    if sum(record(i,4:9))==6
        n(1)=n(1)+1;
    end
    for j=1:6
    if record(i,3+j)==0
        n(1+j)=n(1+j)+1;
    end
    end
end
n
n/size(record,1)
    
    
n=0;
for i=1:size(wholeResults,1)
    if wholeResults{i}.flagSkip==1
        n=n+1;
        inputPool(n,:)=peptidesPool(i,1:3);
    end
end
n
uniqPool=uniqpool(inputPool);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


        