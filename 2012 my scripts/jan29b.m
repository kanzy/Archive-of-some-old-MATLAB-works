%%%A3 format: col1:RefSeqID, col2:UniProtAC, col3:UniProtID, col4:degree, col5:betweenness, col6:cluster_coefficient, col7:core_number
%%%update A2 to A3

A3=cell(size(A2,1),7);
for i=1:size(A2,1)
    disp(i)
    A3{i,1}=A2{i,1}; A3{i,2}=A2{i,2}; A3{i,4}=A2{i,3};
    A3{i,5}=bc(i); A3{i,6}=cc(i); A3{i,7}=cn(i);
    AC=A2{i,2};
    flag=0;
    for j=2:size(B3,1)
        if strcmp(AC, B3{j,1})
            A3{i,3}=B3{j,2};
            flag=1;
            break
        end
    end
    if flag==0
        A3{i,3}=NaN;
    end
end
A2=A3;
clear A3;