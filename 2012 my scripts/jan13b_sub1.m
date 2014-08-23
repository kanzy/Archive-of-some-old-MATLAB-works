%%%should be called by jan13b.m

flag=0;
for j=1:n
    if strcmp(A_protList{j,1}, refSeq)
        flag=1;
        A_protTable(j,1)=A_protTable(j,1)+1;
    end
end
if flag==0
    n=n+1;
    A_protList{n,1}=refSeq;
    A_protTable(n,1)=1;
end