goodPool=[];
n=0;
N=size(wholeResults,1);
for i=1:N
    if isfield(wholeResults{i},'findScansRanges') %Kan: 2011-11-09 added
        %         if min(size(wholeResults{i}.findScansRanges))>0
        if finalTable(i,12)>=1;
            n=n+1;
            goodPool(n,:)=peptidesPool(i,:);
        end
    end
end
consolid_pool(goodPool,1,2);
