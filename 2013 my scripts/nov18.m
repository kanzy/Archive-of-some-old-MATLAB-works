

usePepsSetOrigin=usePepsSet;
useDataSetOrigin=useDataSet;

for i=1:11
    usePeps=usePepsSet{1,i};
    useData=useDataSet{1,i};
    
    usePepsNew=[];
    useDataNew={};
    
    usePepsNew(1,:)=usePeps(1,:);
    useDataNew{1,1}=useData{1,1};
    useDataNew{1,2}=useData{1,2};
    useDataNew{1,3}=useData{1,3};
    m=1;
    for j=2:size(usePeps,1)
        if usePeps(j,1)==usePeps(j-1,1) && usePeps(j,2)==usePeps(j-1,2)
            %skip
        else
            m=m+1;
            usePepsNew(m,:)=usePeps(j,:);
            useDataNew{m,1}=useData{j,1};
            useDataNew{m,2}=useData{j,2};
            useDataNew{m,3}=useData{j,3};
        end
    end
    usePepsSet{1,i}=usePepsNew;
    useDataSet{1,i}=useDataNew;
end

clear usePeps useData usePepsNew useDataNew i j m


        