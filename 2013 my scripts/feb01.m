

rcv=[];
sets={'pH8.6','pH8.3','pH5.6','pH4.2'};
names=[];
n=0;
for m=1:4
    uiimport %import the _wholeResults_afterCheck.mat of all-D datasets
    void=input('Enter to continue...');
    
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        n=n+1;
        rcv(n)=(finalTable(i,10)/finalTable(i,11))/0.9;
        names=[names; sets{m}];
    end
end
end

boxplot(rcv,names,'notch','on')
ylabel('D Recovery')