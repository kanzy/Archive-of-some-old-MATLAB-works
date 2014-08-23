
m=0;
n=0;
record=[];
for i=1:size(wholeResults,1)
    if min(size(wholeResults{i,1}.findScansRanges))>0
        m=m+1;
        if wholeResults{i,1}.flagSkip~=1
            n=n+1;
            record(n)=i;
        end
    end
end
m
n
record
        