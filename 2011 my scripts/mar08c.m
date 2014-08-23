

n=0;
matchList=zeros(size(foundList,1),2);
matchList_Pep=cell(size(foundList,1),1);
mzThreshold=3;
for i=1:size(foundList,1)
    disp(['Now matching # ',num2str(i),' in foundList...'])
    matchList(i,1)=foundList(i,3);
    matchPeps=[];
    for j=1:size(theoryPool,1)
        if foundList(i,2)==theoryPool(j,3) && abs(foundList(i,1)-theoryPool(j,4))<=foundList(i,1)*(1e-6)*mzThreshold
            matchList(i,2)=matchList(i,2)+1;
            matchPeps=[matchPeps; theoryPool(j,:)];
        end
    end
    matchList_Pep{i}=matchPeps;
    if matchList(i,2)>0
        n=n+1;
    end
end
n/size(foundList,1)
