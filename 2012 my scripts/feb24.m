%%%revised from feb22.m

B=peptidesPool_Feb09;
B_distND=peptidesPool_Feb09_distND;

newIndex=[];
n=0;
for i=1:size(B,1)
    x=find(B(i,1)==peptidesPool(:,1) & B(i,2)==peptidesPool(:,2) & B(i,3)==peptidesPool(:,3));
    if min(size(x))==0 && B(i,8)<0.01
        n=n+1;
        newIndex(n)=i;
    end
end

m=size(peptidesPool,1);
for i=1:n
    peptidesPool(m+i,:)=B(newIndex(i),:);
    peptidesPool_distND{1,m+i}=B_distND{1,newIndex(i)};
end
        