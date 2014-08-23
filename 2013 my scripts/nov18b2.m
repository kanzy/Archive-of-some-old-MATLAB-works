

usePepsSetOrigin=usePepsSet;
useDataSetOrigin=useDataSet;

for i=1:11
    usePeps=usePepsSet{1,i};
    useData=useDataSet{1,i};
    
    usePepsNew=[];
    useDataNew={};
    
    m=0;
    for j=2:2:size(usePeps,1)
            m=m+1;
            usePepsNew(m,:)=usePeps(j,:);
            useDataNew{m,1}=useData{j,1};
            useDataNew{m,2}=useData{j,2};
            useDataNew{m,3}=useData{j,3};
    end
    usePepsSet{1,i}=usePepsNew;
    useDataSet{1,i}=useDataNew;
end

clear usePeps useData usePepsNew useDataNew i j m


        