%%%2010-12-02 dec02.m: generate ideal overlapping data:

aSynWT='MDVFMKGLSKAKEGVVAAAEKTKQGVAEAAGKTKEGVLYVGSKTKEGVVHGVATVAEKTKEQVTNVGGAVVTGVTAVAQKTVEGAGSIAAATGFVKKDQLGKNEEGAPQEGILEDMPVDPDNEAYEMPSEEGYQDYEPEA';

currSeq=aSynWT;

finalTable=[];
n=1;
for i=113:139
    finalTable(n,1)=i;
    finalTable(n,2)=min(i+5,140);
    finalTable(n,3)=1;
    [peptideMass, distND, maxND, maxD]=pepinfo(currSeq(i:finalTable(n,2)));
    finalTable(n,4)=peptideMass/finalTable(n,3)+1.007276;
    finalTable(n,7:8)=[5,5];
    finalTable(n,12)=1;
    n=n+1;
end
