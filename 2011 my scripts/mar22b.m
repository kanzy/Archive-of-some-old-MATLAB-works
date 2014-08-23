

figure
peptidesPool=peptidesPool_Pepsin;
for i=1:size(peptidesPool,1)
    plot(peptidesPool(i,2)-peptidesPool(i,1)+1,peptidesPool(i,9),'r*')
    hold on
end
peptidesPool=peptidesPool_FP;
for i=1:size(peptidesPool,1)
    plot(peptidesPool(i,2)-peptidesPool(i,1)+1,peptidesPool(i,9),'b*')
    hold on
end
peptidesPool=peptidesPool_Tandem;
for i=1:size(peptidesPool,1)
    plot(peptidesPool(i,2)-peptidesPool(i,1)+1,peptidesPool(i,9),'g*')
    hold on
end
ylabel('Matched B & Y Ions Number')
xlabel('Peptide Length')