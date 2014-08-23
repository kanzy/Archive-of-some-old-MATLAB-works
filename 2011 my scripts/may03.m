
wholeResults=wholeResults_HSP_D;

result=ones(22,2);

result(1,1)=size(peptidesPool,1);

uniqPool=uniqpool(peptidesPool);
result(2,1)=size(uniqPool,1);


record=[];
record2=[];
n=0;
inputPool=[];
% figure
for i=1:size(wholeResults,1)
    m=size(wholeResults{i}.findScansRanges,1);
%     stem(i,m)
%     hold on
    if m>0
        n=n+1;
        inputPool(n,:)=peptidesPool(i,1:3);
        
        skipTests=wholeResults{i}.skipTests;
        record=[record; [repmat(peptidesPool(i,1:3),size(skipTests,1),1) skipTests]];
        
        if finalTable(i,12)<1 
            record2=[record2; [repmat(peptidesPool(i,1:3),size(skipTests,1),1) skipTests]];
        end
    end
end

result(23,1)=n;
result(23,2)=n/size(peptidesPool,1);

uniqPool=uniqpool(inputPool);
result(24,1)=size(uniqPool,1);
result(24,2)=size(uniqPool,1)/result(2,1);



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

result(3,1)=size(record,1);
result(4:10,1)=n;
result(4:10,2)=n/size(record,1);
    
    
n=0;
inputPool=[];
for i=1:size(wholeResults,1)
    if wholeResults{i}.flagSkip==1
        n=n+1;
        inputPool(n,:)=peptidesPool(i,1:3);
    end
end
result(11,1)=n;
result(11,2)=n/size(peptidesPool,1);

uniqPool=uniqpool(inputPool);
result(12,1)=size(uniqPool,1);
result(12,2)=size(uniqPool,1)/result(2,1);



n1=0;
n2=0;
inputPool=[];
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        n1=n1+1;
        inputPool(n1,:)=peptidesPool(i,1:3);
    else
        n2=n2+1;
    end
end
result(13,1)=n1;
result(13,2)=n1/size(peptidesPool,1);

uniqPool=uniqpool(inputPool);
result(14,1)=size(uniqPool,1);
result(14,2)=size(uniqPool,1)/result(2,1);
    
result(15,1)=size(peptidesPool,1)-result(13,1);
result(15,2)=result(15,1)/size(peptidesPool,1);


n=zeros(1,6);
m=0;
for i=1:size(record2,1)
    if sum(record2(i,4:9))<6
        m=m+1;
        for j=1:6
            if record2(i,3+j)==0
                n(j)=n(j)+1;
            end
        end
    end
end
result(16,1)=m;
result(17:22,1)=n;
result(17:22,2)=n/m;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


        