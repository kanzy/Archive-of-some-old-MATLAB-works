%%%2012-01-13 jan13.m: for making consolidated protein list from SwissVar table

n=1;
protList={};
protList{1,1}=textdata{2,2};
for i=3:size(textdata,1)
    if ~strcmp(textdata{i-1,2}, textdata{i,2})
        n=n+1;
        protList{n,1}=textdata{i,2};
    end
end
        
xlswrite('protList.xls', protList)