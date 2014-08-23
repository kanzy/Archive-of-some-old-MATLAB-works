%%%oct07.m:

%'Whole' format: col# 7, 12, 17, 22

list1=[]; n1=0;
list2=[]; n2=0;
list3=[]; n3=0;
list4=[]; n4=0;

for i=1:size(Whole,1)
    if ~isnan(Whole(i,7))
        n1=n1+1;
        list1(n1,1)=i;
    end
    if ~isnan(Whole(i,12))
        n2=n2+1;
        list2(n2,1)=i;
    end
    if ~isnan(Whole(i,17))
        n3=n3+1;
        list3(n3,1)=i;
    end
    if ~isnan(Whole(i,22))
        n4=n4+1;
        list4(n4,1)=i;
    end
end

%%%with above 4 lists, go to: http://bioinfogp.cnb.csic.es/tools/venny/index.html