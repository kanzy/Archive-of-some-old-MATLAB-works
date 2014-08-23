%%%update previous "finalTable"

finalTable=[finalTable, zeros(size(finalTable,1),3)];

for i=1:size(finalTable,1)
    disp(i)
    protID=finalTable_IDmap{i,2};
    flag=0;
    for j=1:size(A2,1)
        if strcmp(protID, A2{j,3})
            finalTable(i,10)=A2{j,5}; %betweenness
            finalTable(i,11)=A2{j,6}; %cluster_coefficient
            finalTable(i,12)=A2{j,7}; %core_number
            flag=1;
            break
        end
    end
    if flag==0
        finalTable(i,10)=NaN;
        finalTable(i,11)=NaN;
        finalTable(i,12)=NaN;
    end
end
