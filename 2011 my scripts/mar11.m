X1=[];
X1seq={};
n=1;
for i=1:size(peptidesPool_P,1)
    for j=1:size(mascot1_origin,1)
        if peptidesPool_P(i,1)==mascot1_origin(j,1) && ...
                peptidesPool_P(i,2)==mascot1_origin(j,2) && ...
                peptidesPool_P(i,3)==mascot1_origin(j,3) && ...
                peptidesPool_P(i,8)<0.01 && ...
                mascot1_origin(j,4)<3
            X1(n,:)=[peptidesPool_P(i,:), mascot1_origin(j,:)]
            X1seq{n,1}=currSeq(peptidesPool_P(i,1):peptidesPool_P(i,2))
            n=n+1;
        end
    end
end
        


X2=[];
X2seq={};
n=1;
for i=1:size(peptidesPool_P,1)
    for j=1:size(mascot1_origin,1)
        if peptidesPool_P(i,1)==mascot1_origin(j,1) && ...
                peptidesPool_P(i,2)==mascot1_origin(j,2) && ...
                peptidesPool_P(i,3)==mascot1_origin(j,3) && ...
                peptidesPool_P(i,8)>0.99 && ...
                mascot1_origin(j,4)>30
            X2(n,:)=[peptidesPool_P(i,:), mascot1_origin(j,:)]
            X2seq{n,1}=currSeq(peptidesPool_P(i,1):peptidesPool_P(i,2))
            n=n+1;
        end
    end
end



