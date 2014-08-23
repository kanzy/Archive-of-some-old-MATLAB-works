
figure

subplot(3,1,1)
% hist(scores1,size(scores1,1)/5)
hist(scores1,150)
hold on
% xlabel('XCorr Score of SEQUEST')
ylabel('Number of Peptides')
title('MS/MS run 1')
v=axis;
axis([0 7 v(3) v(4)])

subplot(3,1,2)
% hist(scores2,size(scores2,1)/5)
hist(scores2,150)
hold on
% xlabel('XCorr Score of SEQUEST')
ylabel('Number of Peptides')
title('MS/MS run 2')
v=axis;
axis([0 7 v(3) v(4)])

subplot(3,1,3)
% hist(scores3,size(scores3,1)/5)
hist(scores3,150)
xlabel('XCorr Score of SEQUEST')
ylabel('Number of Peptides')
title('MS/MS run 3')
v=axis;
axis([0 7 v(3) v(4)])