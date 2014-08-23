%%%revised from mar26.m
%%%for MassMatrix modified database (indicate Disulfide bonds)


% AlignStruct = localalign(pdbseq, currSeq)  //here, the PDB is 3VN4; currSeq is from Wenbing's MDTCS.txt


%%%//First, copy out SS bonds section text in .pdb file into an Excel table, then save as .csv file, then import into Matlab (to generate VarName5 & VarName8)

modSeq=[];
n=0;
for i=1:size(currSeq,2)
    n=n+1;
    modSeq(n)=currSeq(i);
    for j=1:12
        k=i+(3-260 + 311-27);  %//3 & 260 are from above alignment (start AA); 311 & 27 are for correcting the AA numbering shift within the PDB 
        if k==VarName5(j) || k==VarName8(j)
            str=['($',num2str(j),')'];
            modSeq=[modSeq, str];
            n=n+size(str,2);
        end
    end
end