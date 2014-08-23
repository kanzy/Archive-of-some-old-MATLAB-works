newPool=[];
newPool_distND={};
n=0;
N=size(wholeResults,1);
for i=1:N
    if isfield(wholeResults{i},'findScansRanges') %Kan: 2011-11-09 added
        if min(size(wholeResults{i}.findScansRanges))>0
            n=n+1;
            newPool(n,:)=peptidesPool(i,:);
            newPool_distND{1,n}=peptidesPool_distND{1,i};
        end
    end
end
peptidesPool=newPool;
peptidesPool_distND=newPool_distND;