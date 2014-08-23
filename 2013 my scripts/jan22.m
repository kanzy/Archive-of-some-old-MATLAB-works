
pool1=[];
pool2=[];
m=0;n=0;
for i=1:size(finalTable1,1)
    if finalTable1(i,12)>=1
        m=m+1;
        pool1(m,1:3)=finalTable1(i,1:3);
    end
    if finalTable2(i,12)>=1
        n=n+1;
        pool2(n,1:3)=finalTable2(i,1:3);
    end
end
poolplot2