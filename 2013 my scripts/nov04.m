

fractionD=1

figure

for i=1:size(currSeq,2)
    if currSeq(i)=='H'
       plot([i,i], [0,1.2],'r', 'LineWidth',0.3)
       hold on
%        text(i, 1.25, 'H')
%        hold on
    end
    if currSeq(i)=='R'
       plot([i,i], [0,1.2],'b', 'LineWidth',0.3)
       hold on
%        text(i, 1.25, 'R')
%        hold on
    end
end
        
m=0;
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        m=m+1;
        START=finalTable(i,1);
        END=finalTable(i,2);
        rcvD=finalTable(i,10)/(finalTable(i,11)*fractionD);
        plot([START,END],[rcvD,rcvD],'k', 'LineWidth',2);
        hold on
    end
end

xlabel('Residue Number')
ylabel('Recovery of D')
title('RNase__AllD__Recovery__new (Red=H sites; Blue=R sites)')









