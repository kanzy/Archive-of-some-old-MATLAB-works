
Stats=[];
n=0;
for i=1:size(wholeResults,1)
    if min(size(wholeResults{i}.findScansRanges))>0 && wholeResults{i}.flagSkip==0
        for j=1:size(wholeResults{i}.findScansRanges,1)
        Stats=[Stats; [wholeResults{i}.peptide(1,1:3), j, wholeResults{i}.skipTests(j,:)]];
        end
        n=n+1;
    end
end

a=1-Stats;
ct=zeros(1,6);
for i=1:6
    ct(i)=sum(a(:,i+4));
end

disp(['There are ',num2str(n),' found peptides failed skip test;'])
disp(' ')
disp(['There are ',num2str(size(a,1)),' foundScansRanges belonged to above peptides;'])
disp([num2str(ct(1)),' (',num2str(100*ct(1)/sum(ct)),'%) fails due to test#1: sumInten<threshold;'])
disp([num2str(ct(2)),' (',num2str(100*ct(2)/sum(ct)),'%) fails due to test#2: -1 & Max+1;'])
disp([num2str(ct(3)),' (',num2str(100*ct(3)/sum(ct)),'%) fails due to test#3: interval positions;'])
% disp([num2str(ct(4)),' (',num2str(100*ct(4)/sum(ct)),'%) fails due to test#4: overlapping intensity;'])
disp([num2str(ct(4)),' (',num2str(100*ct(4)/sum(ct)),'%) fails due to test#5: R^2<0.95;'])
disp([num2str(ct(5)),' (',num2str(100*ct(5)/sum(ct)),'%) fails due to test#6: RT position test;'])
disp([num2str(ct(6)),' (',num2str(100*ct(6)/sum(ct)),'%) fails due to test#7: isobaric/overlapping exist;'])