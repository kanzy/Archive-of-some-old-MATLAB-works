
N=0;

m=1;
deltaRT=[];

n=1;
pepPair=peptidesPool(1,:);
for i=2:size(peptidesPool,1)
    if peptidesPool(i,1)==peptidesPool(i-1,1) && peptidesPool(i,2)==peptidesPool(i-1,2)
        n=n+1;
        pepPair(n,:)=peptidesPool(i,:);
    else
        if n>1
            deltaRT(m)=max(pepPair(:,7))-min(pepPair(:,7));

            if deltaRT(m)>1
                disp('Warning:')
                pepPair
            end
            
            m=m+1;
            
            N=N+size(pepPair,1);
        end
        
        n=1;
        pepPair=peptidesPool(i,:);
    end
end

N