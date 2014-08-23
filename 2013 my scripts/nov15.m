

figure
        
m=0;
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        m=m+1;
        START=finalTable(i,1);
        END=finalTable(i,2);
    p1=[START, END]; % start and end aa# of each peptide
    p2=[m,m];
    plot(p1,p2,'k','LineWidth',1)
    hold on
    end
end

for i=1:size(currSeq,2)
    if currSeq(i)=='H'
       plot([i,i], [0,m],'r', 'LineWidth',0.3)
       hold on
       text(i, m+1, 'H')
       hold on
    end
    if currSeq(i)=='R'
       plot([i,i], [0,m],'b', 'LineWidth',0.3)
       hold on
       text(i, m+1, 'R')
       hold on
    end
end
set(gca,'xtick',0:10:150)
xlabel('Residue Number')
ylabel('Peptide Index')
title('SNase peptide map (Red=H sites; Blue=R sites)')









