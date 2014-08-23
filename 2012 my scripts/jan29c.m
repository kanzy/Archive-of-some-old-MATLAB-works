%%%make "finalTable_IDmap" between varID and UniProtID

finalTable_IDmap=cell(size(finalTable,1),2);

sizer1=size(Ed_textdata,1)-1;
sizer2=size(Ep_textdata,1)-1;

for i=1:sizer1
    finalTable_IDmap{i,1}=finalTable(i,1);
    finalTable_IDmap{i,2}=Ed_textdata{i+1,2};
end

for i=1:sizer2
    finalTable_IDmap{i+sizer1,1}=finalTable(i+sizer1,1);
    finalTable_IDmap{i+sizer1,2}=Ep_textdata{i+1,2};
end