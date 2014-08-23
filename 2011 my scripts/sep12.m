

for i=1:size(finalTable,1)
    x=sum(finalTable(i,20:end));
    finalTable(i,13)=x;
end
finalTable=sortrows(finalTable, 13);