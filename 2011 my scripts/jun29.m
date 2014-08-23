
%%%comparison of how filled finalTable(20:end) consistent with ideal
%%%values:

X=2

msdfit_siminput

figure
plot(selectData(:,1), selectData(:,2)/max(selectData(:,2)), '.--')
hold on
mz=zeros(1, 1+maxND+maxD);
for i=1:1+maxND+maxD
    mz(i)=monoMZ+deltamass(i-1);
end
stem(mz, finalTable(1,20:end)/max(finalTable(1,20:end)))
hold on
stem(mz, finalTable_ideal(1,20:end)/max(finalTable_ideal(1,20:end)),'r')
% hold on
% stem(Peaks(:,1), Peaks(:,2)/max(Peaks(:,2)), 'g')