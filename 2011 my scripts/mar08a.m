
n=1;
foundList=[];
for i=1:size(Features,2)
    if FeaturesCheck{i}.judge==1
        foundList(n,1)=Features{i}.mzSet(1);
        foundList(n,2)=Features{i}.CS;
        foundList(n,3)=i;
        n=n+1;
    end
end