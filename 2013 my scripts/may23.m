

goodPool=[];
n=0;
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        n=n+1;
        goodPool(n,:)=finalTable(i,1:3);
    end
end
consolidPool=may23_resmap(goodPool);