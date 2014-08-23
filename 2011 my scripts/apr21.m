
record=[];
n=0;
n2=0;
for i=1:size(wholeResults,1)
    m=size(wholeResults{i}.findScansRanges,1);
    if m>1
        n=n+1;
        skipTests=wholeResults{i}.skipTests;
        record(n,1:3)=peptidesPool(i,1:3);
        record(n,4)=m;
        record(n,5)=0;
        record(n,6)=0;
        for j=1:m
            if sum(skipTests(j,:))==size(skipTests,2)
                record(n,5)=record(n,5)+1;
            else
                record(n,6)=record(n,6)+1;
            end
        end
        if record(n,5)>1
            n2=n2+1;
        end
    end
end
n2

        