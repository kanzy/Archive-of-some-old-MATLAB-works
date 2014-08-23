%%%for MassMatrix modified database (indicate Disulfide bonds)

modSeq=[];
n=0;
for i=2:size(currSeq,2)
    n=n+1;
    modSeq(n)=currSeq(i);
    for j=1:25
        if i==VarName5(j) || i==VarName8(j)
            str=['($',num2str(j),')'];
            modSeq=[modSeq, str];
            n=n+size(str,2);
        end
    end
end