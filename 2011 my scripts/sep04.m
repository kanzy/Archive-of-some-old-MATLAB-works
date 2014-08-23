
n=0;
peptidesPool_distND_new={};
for i=1:size(peptidesPool,1)
    x=find(peptidesPool(i,1)==peptidesPool_new(:,1) & peptidesPool(i,2)==peptidesPool_new(:,2) & peptidesPool(i,3)==peptidesPool_new(:,3));
    if min(size(x))~=0
        n=n+1;
        peptidesPool_distND_new{1,n}=peptidesPool_distND{1,i};
    end
end
