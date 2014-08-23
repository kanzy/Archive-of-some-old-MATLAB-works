%//remove fault fitting-data:
results=[fitChi2(:,2) fitParaSet];

%//Method A: until passing Normality Test
resultsA=[];
j=20;
for i=1:j:simFitTimes
    resultsAseg=sortrows(results(i:i+j-1,:),1);
    h=1;
    while (h~=0)
        rowNum=size(resultsAseg);
        resultsAseg=resultsAseg(1:rowNum(1)-1,:);
        h=jbtest(resultsAseg(:,2))|jbtest(resultsAseg(:,3))|jbtest(resultsAseg(:,4))|jbtest(resultsAseg(:,5));
    end
    resultsA=[resultsA;resultsAseg];
end
size_Of_Results_A=size(resultsA)
h=jbtest(resultsA(:,2))|jbtest(resultsA(:,3))|jbtest(resultsA(:,4))|jbtest(resultsA(:,5)) %//if h=0, all-combined set meet Normalityn
%save E:\USER\kanzy\ns\ns_data\chosenFitResultA.txt resultsA -ascii
%//calculate final results of kf,ku,ka,kd and their SD:
finalFitResultA=[mean(resultsA(:,2:5));std(resultsA(:,2:5))]