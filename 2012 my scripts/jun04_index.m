
function protIndex=jun04_index(A, prot)
protIndex=[];
m=0;
n=0;
iniAA=input('Tell the alignment starts from which amino acid (e.g. 1): ');
iniNum=input('Tell where is the this amino acid in the alignment (e.g. 1): ');
for i=1:size(A,1)
    str=A{i,1};
    if size(str,2)<5
        continue
    end
    if strcmp(str(1:4), prot)
        for j=5:size(str,2)
            if str(j)>='A' && str(j)<='Z'
                m=m+1;
                n=n+1;
                protIndex(1,m)=m+iniAA-1;
                protIndex(2,m)=n+iniNum-1;
            end
            if str(j)=='-'
                n=n+1;
            end
        end
    end
end






