
goodModPepSet=[];
n=1;
for i=1:size(peptidesPool,1)
    if finalTable(i,12)==2 && peptidesPool(i,9)~=0
        goodModPepSet(n,:)=[peptidesPool(i,1:3), peptidesPool(i,9), finalTable(i,4), finalTable(i,7:8)];
        n=n+1;
    end
end
n=n-1
