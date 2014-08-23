

match=zeros(618,3);
n1=0;
n2=0;
inputPool=[];
inputPoolA=[];
for i=1:618
    if wholeResults_HSP_allH{i}.flagSkip==1
        match(i,1)=1;
        n1=n1+1;
        inputPool(n1,:)=peptidesPool(i,1:3);
    end
    
    %     if wholeResults_HSP_DA{i}.flagSkip==1
    %         match(i,2)=1;
    %         n2=n2+1;
    %         inputPoolA(n2,:)=peptidesPool(i,1:3);
    %     end
    
    
    if finalTable(i,12)>=1
        match(i,2)=1;
        n2=n2+1;
        inputPoolA(n2,:)=peptidesPool(i,1:3);
    end
    
    %     if wholeResults_HSP_D{i}.flagSkip==wholeResults_HSP_DA{i}.flagSkip
    if wholeResults_HSP_allH{i}.flagSkip==1 && finalTable(i,12)<1
        i
        match(i,3)=1;
    end
end

uniqPool=uniqpool(inputPool);
uniqPoolA=uniqpool(inputPoolA);
        