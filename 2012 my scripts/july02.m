
newTable=[];
n=0;
for i=1:size(finalTable,1)
    if finalTable(i,12)>0
        n=n+1;
        newTable(n,1:4)=finalTable(i,1:4);
        newTable(n,5)=finalTable(i,4)+sum(peptidesPool(i,5:6))/peptidesPool(i,3);
        newTable(n,6:7)=finalTable(i,5:6);
        newTable(n,8)=sum(finalTable(i,20:end));
    end
end
newTable=flipud(sortrows(newTable,8));