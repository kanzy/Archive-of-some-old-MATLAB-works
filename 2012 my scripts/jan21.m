%%%for generating "A2"

A2=cell(11500,1);
for i=2:size(B2,1)
    disp(i)
    A2{i-1,1}=B2{i,1};
    A2{i-1,2}=B2{i,2};
    for j=1:size(A_protList,1)
        if strcmp(B2{i,1},A_protList{j,1})
            A2{i-1,3}=A_protTable(j,1);
            break
        end
    end
end