
clear record
k=1;
for i=1:size(finalTable,1)
    if finalTable(i,12)==1
        record(k,1)=finalTable(i,2)-finalTable(i,1)+1;
        record(k,2)=(finalTable(i,8)-finalTable(i,7))*60;      
        k=k+1;
    end
end

scatter(record(:,1),record(:,2))
xlabel('Peptide Length')
ylabel('Elution Time (sec) //by NEWDXMS')
title('alpha-Synuclein')