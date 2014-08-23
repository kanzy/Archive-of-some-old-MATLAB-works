


figure

subplot(1,2,1)
pred=[VarName1 VarName2 VarName3 VarName4 VarName5 VarName6];
test=VarName7;
n1=0;
n2=0;
Rand=0.5*(rand(size(pred,1),2)-0.5);
for i=1:size(pred)
    x=find(pred(i,:)==max(pred(i,:)));
    plot(test(i)+Rand(i,1), x+Rand(i,2), 'ro')
    hold on
    if x==test(i)
        n1=n1+1;
    else
        n2=n2+1;
    end
end
n1
n2


subplot(1,2,2)
pred=[VarName8 VarName9 VarName10 VarName11 VarName12 VarName13];
test=VarName14;
n1=0;
n2=0;
Rand=0.5*(rand(size(pred,1),2)-0.5);
for i=1:size(pred)
    x=find(pred(i,:)==max(pred(i,:)));
    plot(test(i)+Rand(i,1), x+Rand(i,2), 'ro')
    hold on
    if x==test(i)
        n1=n1+1;
    else
        n2=n2+1;
    end
end
n1
n2











