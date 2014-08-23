
%%%for sub-pool 88 to 103:
subpool=[];
subpool_distND={};
n=0;
for i=297:342
    n=n+1;
    subpool(n,:)=peptidesPool(i,:);
    subpool_distND{1,n}=peptidesPool_distND{1,i};
end
peptidesPool_origin=peptidesPool;
peptidesPool_distND_origin=peptidesPool_distND;
peptidesPool=subpool;
peptidesPool_distND=subpool_distND;
