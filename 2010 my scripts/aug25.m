
figure

n=0;
m=0;
for i=1:size(finalTable_new,1)
    if finalTable_new(i,12)==2 && finalTable_old(i,12)==1
        n=n+1;
        plot([i-0.1,i-0.1],[finalTable_old(i,7),finalTable_old(i,8)],'b')
        hold on
        plot([i+0.1,i+0.1],[finalTable_new(i,7),finalTable_new(i,8)],'r')
        hold on
        
        if finalTable_old(i,7)==finalTable_new(i,7) && finalTable_old(i,8)==finalTable_new(i,8)
            m=m+1;
        end
    end
end
n
m
        