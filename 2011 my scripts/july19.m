

inputSeq='HHHHHHIIKIIK';
pH=2.5;
TempC=0;

kcDH = fbmme_dh(inputSeq, pH, TempC, 'poly'); %unit: 1/s

figure
Times=[0, 10, 20, 40, 60];
for i=1:size(kcDH,1)
    subplot(4,3,i)
    if i==1
        Fractions=zeros(size(Times));
    else
        Fractions=exp(-kcDH(i)*Times*60);
    end
    plot(Times, Fractions, 'r*-')
    hold on
    title(['AA #',num2str(i)])
end