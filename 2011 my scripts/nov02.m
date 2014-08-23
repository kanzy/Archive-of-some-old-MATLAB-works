
figure
for i=1:size(finalTableMM,1)
    if finalTableMM(i,12)>=1
        START=finalTable(i,1);
        END=finalTable(i,2);
        inten=sum(finalTable(i,20:end));
        if finalTableMM(i,13)==1
            semilogy([START,END],[inten,inten],'g')
        else
            semilogy([START,END],[inten,inten],'r')
        end
        hold on
    end
end