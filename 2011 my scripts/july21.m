

pfList=zeros(149,1);
for i=1:149
    x=find(importData(:,1)==i);
    if min(size(x))>0
        for j=2:4
            if isnan(importData(x,j))~=1
                pfList(i)=importData(x,j);
            end
        end
    else
        pfList(i)=NaN;
    end
end
    
    