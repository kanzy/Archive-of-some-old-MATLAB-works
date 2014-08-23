



extractScansRange=[484, 501];
extractMzRange=[1135, 1150];

checkNum=190; %for 74-103+3
peptide.main=wholeResults{checkNum}.peptide;

% scansSumData = exms_msdataextract(extractScansRange, extractMzRange, flagND);
oct14_exms_msdataextract

figure
plot(scansSumData(:,1),scansSumData(:,2),'k.-','LineWidth',1)
hold on
axis([extractMzRange 0 max(scansSumData(:,2))*1.1]);
xlabel('m/z');